clear all
%filename = './data/GOBLUE_40horizon_2tau_2017_3_20_21h32m';
load(filename)
%Mw = noSwapping(Mw);
fps = 12;

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
        %disp(['agent: ', num2str(agent), ' time: ', num2str(t)])
        %end
		traces(agent, k) = find(abs(W{agent}(:,t)-1)< 1e-4);
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
grid_size = [10 10];
grid = ones(grid_size);

grid(1:5, 1:5) = 0.8;
grid(1:5, 6:10) = 0.6;

% narrow passage
grid(3, 4:7) = 0.4;


% Obstacles
grid([1:2,4:5], 5:6) = 0;
grid([2,4], [4,7]) = 0;
%mygrid([1:2,4:5], 4:7) = 0;
grid([8,9], [7,8]) = 0;

% charging station
grid(1:2,1:2) = 0.2;
grid(1:2,9:10) = 0.2;
grid(9:10,1:2) = 0.2;

vis = zeros(size(grid)+2);
vis(2:end-1,2:end-1)=grid;

T = 1:70;%[1 2 9 10 11 12 13 14 18 19 20 21];
cmap = jet(N);
pos_diff = [[0., 0.]; [0.3,0.3]; [0.3,-0.3]; [-0.3,-0.3]; [-0.3,0.3]];
v = VideoWriter('newmovie.avi');
v.FrameRate = 2*fps;
open(v);
%axis off
%ha = tight_subplot(3,7, [0.05 0.01], [0.01 0.04], 0.01);
for i=1:length(T)-1
	%axes(ha(i))
    for f = 1:fps
        figure(1)
        clf;
        hold on; xlim([0.5, 10.5]); ylim([0.5, 10.5])
        imshow(kron(grid,ones(250,250)), 'xdata', [0.5,10.5], 'ydata', [0.5,10.5])
        hold on;
        rectangle('position',[0.5 0.5 10 10],'LineWidth',2);
%         if (i == loopBegins || i == size(WT,2) || i == 2*size(WT,2) - loopBegins) && (f == 1) 
%                 rectangle('position',[0.5 0.5 10 10],'LineWidth',2,'EdgeColor','r');
%         end
        occup = ones(100,1);
        for n=1:N
            current_state = traces(n, T(i));
            next_state = traces(n, T(i+1));
            diff_ = pos_diff(occup(current_state),:);
            xpos = ind_to_pos_x(current_state) + diff_(1);
            ypos = ind_to_pos_y(current_state) + diff_(2);
            xposn = ind_to_pos_x(next_state) + diff_(1);
            yposn = ind_to_pos_y(next_state) + diff_(2);
            Xpos = (fps-f+1)*xpos/fps + (f-1)*xposn/fps;
            Ypos = (fps-f+1)*ypos/fps + (f-1)*yposn/fps;
            occup(current_state) = occup(current_state) + 1;
            plot(Xpos, Ypos, 'o', 'color', cmap(n,:), ...
                'markersize', 25, 'MarkerFaceColor', cmap(n,:))
%             if current_state ~= traces(n, T(i)+1)
%                 arrow_dest_x = Xpos + (ind_to_pos_x(traces(n, T(i)+1))+ diff_(1) - Xpos)*0.75;
%                 arrow_dest_y = Ypos + (ind_to_pos_y(traces(n, T(i)+1))+ diff_(2) - Ypos)*0.75;
%                 arrow([Xpos, Ypos], [arrow_dest_x, arrow_dest_y], 'length', 4, 'baseangle', 90, 'tipangle', 30, 'color', cmap(n,:));
%             end
        end
        title(['$$t=', num2str((T(i)-1)+(f-1)/fps), '$$'],'Interpreter','latex')
        hold off
        filename2 = sprintf('/Users/ysahin/Dropbox/MultiAgent - LTL counting/Vfinal/plots/%s_%03d.png', 'Earthquake', (T(i)-1)*fps+f-1);
        %print(filename2, '-dpng');
        frame = getframe;
        writeVideo(v,frame);
    end
end
close(v)
%print -depsc traces.eps