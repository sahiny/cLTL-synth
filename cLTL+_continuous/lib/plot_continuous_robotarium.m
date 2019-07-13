function plot_continuous_robotarium(x,Z, zLoop, tau)
w = warning('off','all');
h = size(x{1},2)-1-tau;
N = length(x);
cmap = jet(N);
fps = 5;

loopBegins = find(zLoop(:)==1,1);

% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=h)*(time) + (time>h)*(loopBegins + mod(time-h-1, h-loopBegins+1));

% state constraints
Px = Polytope([eye(2); -eye(2)], [.6; .35; .6; .35]);

% input constraints
Pu = Polytope([eye(2); -eye(2)], [.2; .2; .2; .2]);

% atomic propositions
ap_cell = {};

% narrow passage
[ap_narrow, ap_cell] = AP([eye(2); -eye(2)],[.2; .25; .2; -.05], ap_cell);

% Region A
[ap_A, ap_cell] = AP([eye(2); -eye(2)],[-.2; 0.35; .6; 0.05], ap_cell);

% Region C
[ap_C, ap_cell] = AP([eye(2); -eye(2)],[.6; .35; -.2; .05], ap_cell);

% Region E
[ap_E, ap_cell] = AP([eye(2); -eye(2)],[.75; -.05; 0; .35], ap_cell);

% Region F
[ap_F1, ap_cell] = AP([eye(2); -eye(2)],[-.4; -.15; .6; .35], ap_cell);
[ap_F2, ap_cell] = AP([eye(2); -eye(2)],[-.4; .35; 0.6; -.15], ap_cell);
[ap_F3, ap_cell] = AP([eye(2); -eye(2)],[.6; .35; -.4; -.15], ap_cell);


% Obstacles
Obs1 = Polytope([eye(2); -eye(2)], [.4; -.15; -.2; .25]);
Obs2 = Polytope([eye(2); -eye(2)], [.2; .35; .2; -.25]);
Obs3 = Polytope([eye(2); -eye(2)], [.2; .05; .2; .05]);
Obs = [Obs1, Obs2, Obs3];
%%%%%%%%%%%

pause('on')
for k = 1:2*h
    t_current = time_to_state_pos(k)
    t_next = time_to_state_pos(k+1);
    for tt = 1:fps+1
        figure(1);clf;hold on;
        plot(Polyhedron(Px.A,Px.b), 'color', 'white');
        plot(Polyhedron(ap_A.A,ap_A.b), 'color', 'gray');
        plot(Polyhedron(ap_C.A,ap_C.b), 'color', 'gray');
        plot(Polyhedron(ap_narrow.A,ap_narrow.b), 'color', 'gray');
        plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black');
        plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black');
        plot(Polyhedron(Obs(3).A,Obs(3).b), 'color', 'black');
        plot(Polyhedron(ap_F1.A,ap_F1.b), 'color', 'gray');
        plot(Polyhedron(ap_F2.A,ap_F2.b), 'color', 'gray');
        plot(Polyhedron(ap_F3.A,ap_F3.b), 'color', 'gray');
        poses = zeros(2,N);
        for n = 1:N
            xx = x{n}(1,t_current) * (fps+1-tt)/fps + x{n}(1,t_next) * (tt-1)/fps;
            yy = x{n}(2,t_current) * (fps+1-tt)/fps + x{n}(2,t_next) * (tt-1)/fps;
%             xx = xx*1.2/10 - 0.6;
%             yy = yy*0.7/10 - 0.35;
            plot(xx,yy,'o', 'color', cmap(n,:), ...
                    'markersize', 15, 'MarkerFaceColor', cmap(n,:))
            poses(:,n) = [xx; yy];
        end
        min_dist = 1000*ones(1,N);
        for n = 1:N
            Nothers = setdiff(1:N,n);
            for n2 = 1:N-1
                if norm(poses(:,n) - poses(:,Nothers(n2))) < min_dist(n)
                    min_dist(n) = norm(poses(:,n) - poses(:,Nothers(n2)));
                end
            end
        end
        min_dist;
%        assert(min(min_dist)>=0.08, 'Minimum dist violation');
        pause(.01);
        hold off
    end
end
w = warning('on','all');
