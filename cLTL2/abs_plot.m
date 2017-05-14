clear all
load('Abs.mat')

% Loop closes at 18
l = LoopBegins
% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=20)*(time) + (time>20)*(l + mod(time-l, l+1));

% Gives control index in loop at 'time'-1 (to be used to obtain state at 'time')
time_to_control_pos = @(time) (time<=19)*(time-1) + (time>19)*(l + mod(time-l-1, l+1));

% Return coordinates in a grid world
ind_to_pos_x = @(ind) (1+floor((ind-1)/9));
ind_to_pos_y = @(ind) (1+mod((ind-1),13));

I = numel(grid);  % num of states
N = sum(W0);   % num of agents
K = 50;   % horizon

traces = zeros(N, K);

% Populate initial conditions
num_trace = 1;
for state = 1:I
	for i = 1:WT(state,1)
		traces(num_trace, 1) = state;
		num_trace = num_trace + 1;
	end
end

Mwn=cell(1,20);
for i=1:20
    Mwn{i} = reshape(Mw((i-1)*I*I+1:i*I*I),size(A,1),size(A,2));
end
% Populate rest of traces
for k=2:K
	control_time = time_to_control_pos(k);
	control = Mwn{control_time};
	for agent=1:N
		% Find a feasible destination
		current_state = traces(agent, k-1);
		destination = find(control(current_state,:) > 0.1, 1);
		control(current_state, destination) = control(current_state, destination) - 1;

		% Assign destination
		destination;
		traces(agent, k) = destination;
	end
end

% Test that it worked
w_test = zeros(I,K);
for k=1:K
	for n=1:N
		state = traces(n,k);
		w_test(state,k) = w_test(state,k) + 1;
	end
end
for k=1:5
	assert(sum(abs(w_test(:,k) - WT(:,k))) == 0)
end

clf; 
set(gca, 'LooseInset', get(gca,'TightInset'))

vis = zeros(size(grid)+2);
vis(2:end-1,2:end-1)=grid;

T = [1 2 9 10 11 12 13 14 18 19 20 21];
cmap = jet(N);
pos_diff = [[0., 0.]; [0.3,0.3]; [0.3,-0.3]; [-0.3,-0.3]; [-0.3,0.3]];

axis off
ha = tight_subplot(3,4, [0.05 0.01], [0.01 0.04], 0.01);
for i=1:length(T)
	axes(ha(i))
	hold on; xlim([0.5, 10.5]); ylim([0.5, 10.5])
	imshow(kron(grid,ones(25,25)), 'xdata', [0.5,10.5], 'ydata', [0.5,10.5])
	rectangle('position',[0.5 0.5 10 10],'LineWidth',2);
	occup = ones(100,1);
	for n=1:N
		current_state = traces(n, T(i));
		diff_ = pos_diff(occup(current_state),:);
		xpos = ind_to_pos_x(current_state) + diff_(1);
		ypos = ind_to_pos_y(current_state) + diff_(2);
		occup(current_state) = occup(current_state) + 1;
		plot(xpos, ypos, 'o', 'color', cmap(n,:), ...
			'markersize', 5, 'MarkerFaceColor', cmap(n,:))
		if current_state ~= traces(n, T(i)+1)
			arrow_dest_x = xpos + (ind_to_pos_x(traces(n, T(i)+1))+ diff_(1) - xpos)*0.75;
			arrow_dest_y = ypos + (ind_to_pos_y(traces(n, T(i)+1))+ diff_(2) - ypos)*0.75;
			arrow([xpos, ypos], [arrow_dest_x, arrow_dest_y], 'length', 4, 'baseangle', 90, 'tipangle', 30, 'color', cmap(n,:));
		end
	end
	title(['$$t=', num2str(T(i)), '$$'],'Interpreter','latex')
end

print -depsc traces.eps