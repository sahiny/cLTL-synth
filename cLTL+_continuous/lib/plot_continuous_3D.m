function plot_continuous_3D(x,Z)
h = size(x{1},2);
N = length(x);
cmap = jet(N);
fps = 1;

% state constraints
Px = Polytope([eye(3); -eye(3)], [10; 10; 10; 10; 10; 0]);

% input constraints
Pu = Polytope([eye(3); -eye(3)], [1; 1; 1; 1; 1; 1]);

% atomic propositions
ap_cell = {};

% ap1
[ap1, ap_cell] = AP([eye(3); -eye(3)],[-7; 1; 5; 9; 1; -3], ap_cell);
[ap2, ap_cell] = AP([eye(3); -eye(3)],[ 1; 1; 5; 1; 1; -3], ap_cell);
[ap3, ap_cell] = AP([eye(3); -eye(3)],[ 9; 1; 5; -7; 1; -3], ap_cell);


% Obstacles
Obs1 = Polytope([eye(3); -eye(3)], [-4; 7; 7; 6; 7; -3]);
Obs2 = Polytope([eye(3); -eye(3)], [ 6; 7; 7; -4; 7; -3]);
Obs = [Obs1, Obs2];
%%%%%%%%%%%

% visualization
min_distances = [];
for t = 1:h
    for tt = 1:fps+1
        figure(1);clf;hold on;
        subplot(2,2,1)
        hold on;
        plot(Polyhedron(Px.A,Px.b), 'color', 'white', 'alpha', 0.1);
        plot(Polyhedron(ap1.A,ap1.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(ap2.A,ap2.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(ap3.A,ap3.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black', 'alpha', 0.1);
        plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black', 'alpha', 0.1);
        
        poses = zeros(3,N);
        for n = 1:N
            xx = x{n}(1,t) * (fps+1-tt)/fps + x{n}(1,t+1) * (tt-1)/fps;
            yy = x{n}(2,t) * (fps+1-tt)/fps + x{n}(2,t+1) * (tt-1)/fps;
            zz = x{n}(3,t) * (fps+1-tt)/fps + x{n}(3,t+1) * (tt-1)/fps;
            plot3(xx,yy,zz, '.', 'color', cmap(n,:), ...
                    'markersize', 25, 'MarkerFaceColor', cmap(n,:))
            poses(:,n) = [xx yy zz]';
        end
        
        min_dist = 1000*ones(1,N);
        for n1 = 1:N
            Nothers = setdiff(1:N,n1);
            for n2 = 1:N-1
                if norm(poses(:,n1)-poses(:,Nothers(n2)),2) < min_dist(n1)
                    min_dist(n1) = norm(poses(:,n1)-poses(:,Nothers(n2)),2);
                end
            end
        end
        min_dist
view(0,0)
        subplot(2,2,2)
        hold on
        plot(Polyhedron(Px.A,Px.b), 'color', 'white', 'alpha', 0.1);
        plot(Polyhedron(ap1.A,ap1.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(ap2.A,ap2.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(ap3.A,ap3.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black', 'alpha', 0.1);
        plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black', 'alpha', 0.1);
        for n = 1:N
            xx = x{n}(1,t) * (fps+1-tt)/fps + x{n}(1,t+1) * (tt-1)/fps;
            yy = x{n}(2,t) * (fps+1-tt)/fps + x{n}(2,t+1) * (tt-1)/fps;
            zz = x{n}(3,t) * (fps+1-tt)/fps + x{n}(3,t+1) * (tt-1)/fps;
            plot3(xx,yy,zz, '.', 'color', cmap(n,:), ...
                    'markersize', 25, 'MarkerFaceColor', cmap(n,:))
        end
view(0,90)
subplot(2,2,3)
hold on;
        plot(Polyhedron(Px.A,Px.b), 'color', 'white', 'alpha', 0.1);
        plot(Polyhedron(ap1.A,ap1.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(ap2.A,ap2.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(ap3.A,ap3.b), 'color', 'green', 'alpha', 0.1);
        plot(Polyhedron(Obs(1).A,Obs(1).b), 'color', 'black', 'alpha', 0.1);
        plot(Polyhedron(Obs(2).A,Obs(2).b), 'color', 'black', 'alpha', 0.1);
        for n = 1:N
            xx = x{n}(1,t) * (fps+1-tt)/fps + x{n}(1,t+1) * (tt-1)/fps;
            yy = x{n}(2,t) * (fps+1-tt)/fps + x{n}(2,t+1) * (tt-1)/fps;
            zz = x{n}(3,t) * (fps+1-tt)/fps + x{n}(3,t+1) * (tt-1)/fps;
            plot3(xx,yy,zz, '.', 'color', cmap(n,:), ...
                    'markersize', 25, 'MarkerFaceColor', cmap(n,:))
        end
view(90,0)
        pause(.001);
        
        hold off
    end
end