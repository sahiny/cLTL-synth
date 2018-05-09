function plot_continuous_robotarium(x,Z, zLoop)
h = size(x{1},2)-1;
N = length(x);
cmap = jet(N);
fps = 5;

loopBegins = find(zLoop(:)==1,1);

% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=h)*(time) + (time>h)*(loopBegins + mod(time-h-1, h-loopBegins+1));

% state constraints
Px = Polytope([eye(2); -eye(2)], [10; 10; 0; 0]);

% input constraints
Pu = Polyhedron([eye(2); -eye(2)], [1; 1; 1; 1]);

% atomic propositions
ap_cell = {};

% narrow passage
[ap_narrow, ap_cell] = AP([eye(2); -eye(2)],[7; 8; -3; -7], ap_cell);

% Region A
[ap_A, ap_cell] = AP([eye(2); -eye(2)],[3; 10; 0; -5], ap_cell);

% Region C
[ap_C, ap_cell] = AP([eye(2); -eye(2)],[10; 10; 0; -5], ap_cell);

% Region E
[ap_E, ap_cell] = AP([eye(2); -eye(2)],[10; 5; 0; 0], ap_cell);

% Obstacles
Obs1 = Polytope([eye(2); -eye(2)], [8; 3; -6; -1]);
Obs2 = Polytope([eye(2); -eye(2)], [7; 10; -3; -8]);
Obs3 = Polytope([eye(2); -eye(2)], [7; 7; -3; -5]);
Obs = [Obs1, Obs2, Obs3];
pause('on')
for k = 1:2*h
    t = time_to_state_pos(k)
    for tt = 1:fps+1
        figure(1);clf;hold on;
        plot(Polyhedron(Px.A,Px.b), 'color', 'white');
        plot(Polyhedron(ap_A.A,ap_A.b), 'color', 'gray');
        plot(Polyhedron(ap_C.A,ap_C.b), 'color', 'gray');
        plot(Polyhedron(ap_narrow.A,ap_narrow.b), 'color', 'gray');
        plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black');
        plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black');
        plot(Polyhedron(Obs(3).A,Obs(3).b), 'color', 'black');
        poses = zeros(2,N);
        for n = 1:N
            xx = x{n}(1,t) * (fps+1-tt)/fps + x{n}(1,t+1) * (tt-1)/fps;
            yy = x{n}(2,t) * (fps+1-tt)/fps + x{n}(2,t+1) * (tt-1)/fps;
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
        min_dist
        assert(min(min_dist)>=0.6, 'Minimum dist violation');
        pause(.01);
        hold off
    end
end