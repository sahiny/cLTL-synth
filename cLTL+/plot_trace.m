function plot_trace(filename,fps)
filename = strcat('./data/',filename);
load(filename)
Mw = noSwapping(Mw);
[size1,size2] = size(mygrid);
k = length(ZLoop);
loopBegins = find(ZLoop(:)==1,1);

% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=k)*(time) + (time>k)*(loopBegins + mod(time-k-1, k-loopBegins+1));

% Gives control index in loop at 'time'-1 (to be used to obtain state at 'time')
time_to_control_pos = @(time) (time<=k+1)*(time-1) + (time>k+1)*(loopBegins + mod(time-k-2, k-loopBegins+1));

% Return coordinates in a grid world
ind_to_pos_x = @(ind) (1+floor((ind-1)/size2));
ind_to_pos_y = @(ind) (1+mod((ind-1),size2));

I = size1*size2;  % num of states
N = round(sum(WT(:,1)));   % num of agents
K = k*2;   % horizon

traces = zeros(round(N), round(K));
WT = round(WT);
% Populate initial conditions
num_trace = 1;
for state = 1:I
	for i = 1:WT(state,1)
		traces(num_trace, 1) = state;
		num_trace = num_trace + 1;
	end
end

% Populate rest of traces
for i=2:K
	control_time = time_to_control_pos(i);
	control = Mw{control_time};
	for agent=1:N
		% Find a feasible destination
		current_state = traces(agent, i-1);
		destination = find(control(current_state,:) > 0.1, 1);
		control(current_state, destination) = control(current_state, destination) - 1;

		% Assign destination
		traces(agent, i) = destination;
	end
end

% Test that it worked
% w_test = zeros(I,K);
% for i=1:K
% 	for agent=1:N
% 		state = traces(agent,i);
% 		w_test(state,i) = w_test(state,i) + 1;
% 	end
% end
% for i=1:5
% 	assert(sum(abs(w_test(:,i) - WT(:,i))) == 0)
% end
cmap = jet(N);

clf; 
T = 1:K-1;
Xpos = ind_to_pos_x(traces(:,1))-.5;%1+rand(N,1);
Ypos = ind_to_pos_y(traces(:,1))-.5;%1+rand(N,1);
%axis off
%ha = tight_subplot(3,4, [0.05 0.01], [0.01 0.04], 0.01);
for i=1:length(T)
            NXpos = ind_to_pos_x(traces(:,i+1))-.5;%1+rand(N,1);
            NYpos = ind_to_pos_y(traces(:,i+1))-.5;%%+rand(N,1);
    for f=1:fps
        figure(1)
        clf;hold on; grid on;
        xlim([0, size2]); ylim([0, size1]);
        set(gca,'xtick',0:size2),set(gca,'ytick',0:size1);
        for g = 1:I
            xpos = ind_to_pos_x(g);
            ypos = ind_to_pos_y(g);
            rectangle('position',[xpos-1 ypos-1 xpos ypos],'LineWidth',.5);
            if mygrid(xpos,ypos)==0
                rectangle('position',[xpos-1 ypos-1 1 1],'FaceColor',[0 0 0]); 
            elseif mygrid(xpos,ypos)==.2 
                rectangle('position',[xpos-1 ypos-1 1 1],'FaceColor',[0.2 0.2 0.2]);
            elseif mygrid(xpos,ypos)==.8
                rectangle('position',[xpos-1 ypos-1 1 1],'FaceColor',[0.8 0.8 0.8]);
            elseif mygrid(xpos,ypos)==.5
                rectangle('position',[xpos-1 ypos-1 1 1],'FaceColor',[0.5 0.5 0.5]); 
            end
        end
        rectangle('position',[0 0 size2 size1],'LineWidth',2);

        %occup = ones(100,1);
        for agent=1:N
            %current_state = traces(agent, T(i));
            %diff_ = pos_diff(occup(current_state),:);
            xpos = Xpos(agent);
            ypos = Ypos(agent);
            nxpos = NXpos(agent);
            nypos = NYpos(agent);
            myxpos = (fps+1-f)*xpos/fps + (f-1)*nxpos/fps;
            myypos = (fps+1-f)*ypos/fps + (f-1)*nypos/fps;
            %occup(current_state) = occup(current_state) + 1;
            plot(myxpos, myypos, 'o', 'color', cmap(n,:), ...
			'markersize', 5, 'MarkerFaceColor', cmap(n,:));
    % 		if current_state ~= traces(n, T(i)+1)
    % 			arrow_dest_x = xpos + (ind_to_pos_x(traces(n, T(i)+1))+ diff_(1) - xpos)*0.75;
    % 			arrow_dest_y = ypos + (ind_to_pos_y(traces(n, T(i)+1))+ diff_(2) - ypos)*0.75;
    % 			arrow([xpos, ypos], [arrow_dest_x, arrow_dest_y], 'length', 4, 'baseangle', 90, 'tipangle', 30, 'color', cmap(n,:));
    % 		end
        end
        title(['$$t=', num2str(T(i)+(f-1)/fps), '$$'],'Interpreter','latex')
        hold off
        filename2 = sprintf('./plots/%s_%03d.png', filename, f+fps*(i-1));
        %print(filename2, '-dpng');
    end
        Xpos = NXpos;
        Ypos = NYpos;
end
