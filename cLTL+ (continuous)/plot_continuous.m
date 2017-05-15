function plot_continuous(x,Z)
h = size(x{1},2)-1;
N = length(x);
cmap = jet(N);
fps = 5;

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
for t = 1:h
    for tt = 1:fps+1
        figure(1);clf;hold on;
        plot(Polyhedron(Px.A,Px.b), 'color', 'white');
        plot(Polyhedron(ap_A.A,ap_A.b), 'color', 'gray');
        plot(Polyhedron(ap_C.A,ap_C.b), 'color', 'gray');
        plot(Polyhedron(ap_narrow.A,ap_narrow.b), 'color', 'gray');
        plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black');
        plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black');
        plot(Polyhedron(Obs(3).A,Obs(3).b), 'color', 'black');
        for n = 1:N
            xx = x{n}(1,t) * (fps+1-tt)/fps + x{n}(1,t+1) * (tt-1)/fps;
            yy = x{n}(2,t) * (fps+1-tt)/fps + x{n}(2,t+1) * (tt-1)/fps;
            plot(xx,yy,'o', 'color', cmap(n,:), ...
                    'markersize', 15, 'MarkerFaceColor', cmap(n,:))
        end
        pause(.05);
        hold off
    end
end