function plot_emergency(x, zLoop, tau, epsilon)
w = warning('off','all');
h = size(x{1},2)-1-tau;
N = length(x);
cmap = jet(N);
fps = 5;

loopBegins = find(zLoop(:)==1,1);

% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=h)*(time) + (time>h)*(loopBegins + mod(time-h-1, h-loopBegins+1));

% state constraints
Px = Polytope([eye(2); -eye(2)], [10; 10; 0; 0]);

% input constraints
Pu = Polytope([eye(2); -eye(2)], [1; 1; 1; 1]);

% atomic propositions
ap_cell = {};

% narrow passage
[ap_narrow, ap_cell] = AP([eye(2); -eye(2)],[7; 8; -3; -7], ap_cell);

% passage ends
[ap_narrow11, ap_cell] = AP([eye(2); -eye(2)],[3; 9; -2; -8], ap_cell);
[ap_narrow12, ap_cell] = AP([eye(2); -eye(2)],[3; 7; -2; -6], ap_cell);
[ap_narrow21, ap_cell] = AP([eye(2); -eye(2)],[8; 9; -7; -8], ap_cell);
[ap_narrow22, ap_cell] = AP([eye(2); -eye(2)],[8; 7; -7; -6], ap_cell);


% Region A
[ap_A, ap_cell] = AP([eye(2); -eye(2)],[3; 10; 0; -5], ap_cell);

% Region C
[ap_C, ap_cell] = AP([eye(2); -eye(2)],[10; 10; -7; -5], ap_cell);

% Region E
% [ap_E, ap_cell] = AP([eye(2); -eye(2)],[10; 5; 0; 0], ap_cell);

% Region F
[ap_F1, ap_cell] = AP([eye(2); -eye(2)],[2; 2; 0; 0], ap_cell);
[ap_F2, ap_cell] = AP([eye(2); -eye(2)],[2; 10; 0; -8], ap_cell);
[ap_F3, ap_cell] = AP([eye(2); -eye(2)],[10; 10; -8; -8], ap_cell);


% Obstacles
Obs1 = Polytope([eye(2); -eye(2)], [8; 3; -6; -1]);
Obs2 = Polytope([eye(2); -eye(2)], [7; 10; -3; -8]);
Obs3 = Polytope([eye(2); -eye(2)], [7; 7; -3; -5]);
Obs = [Obs1, Obs2, Obs3];

% visualization
figure(1);
for i = 1:2*h
    clf;hold on;
    plot(Polyhedron(Px.A,Px.b), 'color', 'white');
    plot(Polyhedron(ap_A.A,ap_A.b), 'color', 'gray');
    plot(Polyhedron(ap_C.A,ap_C.b), 'color', 'gray');
    plot(Polyhedron(ap_narrow.A,ap_narrow.b), 'color', 'gray');
    plot(Polyhedron(ap_narrow11.A,ap_narrow11.b), 'color', 'gray');
    plot(Polyhedron(ap_narrow12.A,ap_narrow12.b), 'color', 'gray');
    plot(Polyhedron(ap_narrow21.A,ap_narrow21.b), 'color', 'gray');
    plot(Polyhedron(ap_narrow22.A,ap_narrow22.b), 'color', 'gray');

    plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black');
    plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black');
    plot(Polyhedron(Obs(3).A,Obs(3).b), 'color', 'black');
    
    
    plot(Polyhedron(ap_F1.A,ap_F1.b), 'color', 'gray');
    plot(Polyhedron(ap_F2.A,ap_F2.b), 'color', 'gray');
    plot(Polyhedron(ap_F3.A,ap_F3.b), 'color', 'gray');
    
    t = time_to_state_pos(i);
    for n = 1:N
        rectangle('Position', [x{n}(1,t)-epsilon x{n}(2,t)-epsilon 2*epsilon 2*epsilon], 'FaceColor', 'r')
        plot(x{n}(1,t), x{n}(2,t), 'ok', 'MarkerFaceColor', 'k')
    end
    hold off
end
w = warning('on','all');
