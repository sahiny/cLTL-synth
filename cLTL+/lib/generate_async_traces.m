function [traces_async, loopBegins] = generate_async_traces(W, loopBegins, tau, upperLimit, varargin)

if nargin == 5
    stutter_prob = varargin{1};
else
    stutter_prob = 0.1;
end

% Original time horizon
k = size(W{1},2)-1;
h = k;

% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=k)*(time) + (time>k)*(loopBegins + mod(time-k-1, k-loopBegins+1));

% Gives control index in loop at 'time'-1 (to be used to obtain state at 'time')
time_to_control_pos = @(time) (time<=k+1)*(time-1) + (time>k+1)*(loopBegins + mod(time-k-2, k-loopBegins+1));

I = size(W{1},1);  % num of states
N = length(W);   % num of agents
K = ceil(upperLimit/size(W{1},2)+2)*size(W{1},2);   % horizon

% compute long traces
traces_sync = zeros(N, K);
index_sync = zeros(1, K);
% Populate traces
for k=1:K
	t = time_to_state_pos(k);
    index_sync(k) = t;
	for agent=1:N
		traces_sync(agent, k) = find(abs(W{agent}(:,t)-1)< 1e-4);
	end
end

% Now introduce asynchrony
traces_async = traces_sync;
index_async = ones(N,upperLimit);
for t=2:upperLimit
    prev_index = index_async(:,t-1);
    current_index = prev_index;
    
    % Start with agent1 and move according to stutter probability
    if rand(1) > stutter_prob
        current_index(1) = prev_index(1)+1 ;
    end
    
    % Now move rest of the agents 
    for agent = 2:N
       if max(current_index(1:agent)) - current_index(agent) > tau
           % Agents cannot lag too much
           current_index(agent) = current_index(agent) + 1;
       elseif current_index(agent) - min(current_index(1:agent)) == tau
           % Agents cannot lead too much
           continue
       elseif rand(1) > stutter_prob 
           % Other than that move with stutter probability
           current_index(agent) = current_index(agent) + 1;
       end
    end
    
    index_async(:,t) = current_index;
    
    for agent = 1:N
        traces_async(agent,t) = traces_sync(agent,current_index(agent));
    end
    
    anchor_time = min(index_async(:,t));
    isLoop = find(ismember(traces_async(:,1:t-1)',traces_async(:,t)','rows'),1);
    if anchor_time >= h && ~isempty(isLoop)
        % If we repeat an aggregate state after looping once, stop
        if t-1-isLoop < h - loopBegins
            continue
        end
        loopBegins = isLoop;
        traces_async = traces_async(:,1:t);
        return
    end
end


% If repetation does not occur, move sync after upperLimit until repetation
current_index = index_async(:,upperLimit);
while isempty(find(ismember(traces_async(:,1:end-1)',traces_async(:,end)','rows'),1))
    % Move one step in sync
    next_index = current_index + ones(N,1);
    next_trace = zeros(N,1);
    for agent = 1:N
        next_trace(agent) = traces_sync(agent,next_index(agent));
    end
    
    traces_async = [traces_async next_trace];
    current_index = next_index;
    index_async = [index_async next_index];
end

loopBegins = find(ismember(traces_async(:,1:end-1)',traces_async(:,end)','rows'),1);