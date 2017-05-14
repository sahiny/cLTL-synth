function grid_plot(filename)
load(filename)
% % Loop closes at 10
% 
% % Gives state vector index in loop at 'time'
% time_to_state_pos = @(time) (time<=20)*(time) + (time>20)*(10 + mod(time-10, 11));
% 
% % Gives control index in loop at 'time'-1 (to be used to obtain state at 'time')
% time_to_control_pos = @(time) (time<=19)*(time-1) + (time>19)*(10 + mod(time-11, 11));

k = length(ZLoop);
loopBegins = find(ZLoop(:)==1,1);

% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=k)*(time) + (time>k)*(loopBegins + mod(time-k-1, k-loopBegins+1));

% Gives control index in loop at 'time'-1 (to be used to obtain state at 'time')
time_to_control_pos = @(time) (time<=k+1)*(time-1) + (time>k+1)*(loopBegins + mod(time-k-2, k-loopBegins+1));


% Return coordinates in a grid world
ind_to_pos_x = @(ind) (1+floor((ind-1)/10));
ind_to_pos_y = @(ind) (1+mod((ind-1),10));

I = size(A,2);  % num of states
N = length(W);   % num of agents
K = 2*size(W{1},2);   % horizon

traces = zeros(N, K);


% Populate rest of traces
for k=1:K
	t = time_to_state_pos(k);
	for agent=1:N
		% Find a feasible destination
        %if isempty(find(W{agent}(:,t)==1))
            disp(['agent: ', num2str(agent), ' time: ', num2str(t)])
        %end
		traces(agent, k) = find(W{agent}(:,t)==1);
	end
end

% % Test that it worked
% w_test = zeros(I,K);
% for k=1:K
% 	for n=1:N
% 		state = traces(n,k);
% 		w_test(state,k) = w_test(state,k) + 1;
% 	end
% end
% for k=1:5
% 	assert(sum(abs(w_test(:,k) - WT(:,k))) == 0)
% end

clf; 
set(gca, 'LooseInset', get(gca,'TightInset'))

% NO's gridworld
grid_size = [10, 10];
grid = ones(grid_size);

grid(1:5, 1:5) = 0.2;
grid(1:5, 6:10) = 0.8;

% narrow passage
grid(3, 4:7) = 0.5;
grid([1:2,4:5], 5:6) = 0;
grid([2,4], [4,7]) = 0;
grid([7,8], [7,8]) = 0;

vis = zeros(size(grid)+2);
vis(2:end-1,2:end-1)=grid;

T = [1 6 10 11 12 20 33 41];%[1 2 9 10 11 12 13 14 18 19 20 21];
T = 1:21;
cmap = jet(N);
pos_diff = [[0., 0.]; [0.3,0.3]; [0.3,-0.3]; [-0.3,-0.3]; [-0.3,0.3]];

axis off
ha = tight_subplot(3,7, [0.05 0.01], [0.01 0.04], 0.01);
for i=1:length(T)
	axes(ha(i))
	hold on; xlim([0.5, 10.5]); ylim([0.5, 10.5])
	imshow(kron(grid,ones(25,25)), 'xdata', [0.5,10.5], 'ydata', [0.5,10.5])
	rectangle('position',[0.5 0.5 10 10],'LineWidth',2);
	if i == loopBegins || i == length(ZLoop)+1
        	rectangle('position',[0.5 0.5 10 10],'LineWidth',2,'EdgeColor','r');
    end
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
