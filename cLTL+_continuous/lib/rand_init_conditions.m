
epsilon = 0.25;
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

% Initial condition
numTrial = 20;
X0 = cell(20,1);
for jj = 1:numTrial
xx0 = zeros(2, 10);
num_valid = 0;
while num_valid < 10
    is_valid = true;
    x0 = 10*rand(2,1);
    % check collision with obs
    if sum(Obs1.A*x0 <= Obs1.b + epsilon) == 4
        continue;
    end
    if sum(Obs2.A*x0 <= Obs2.b + epsilon) == 4
        continue;
    end
    if sum(Obs3.A*x0 <= Obs3.b + epsilon) == 4
        continue;
    end
    if sum(ap_narrow.A*x0 <= ap_narrow.b + epsilon) == 4
        continue;
    end
    if sum(Px.A*x0 <= Px.b - epsilon) < 4
        continue;
    end
    % check collision with other dudes
    for j = 1:num_valid
        is_valid = true;
        if sqrt((xx0(1,j) - x0(1))^2 + (xx0(2,j) - x0(2))^2) < 2*epsilon
            is_valid = false;
            break;
        end
    end
    if is_valid
        xx0(:, num_valid+1) = x0;
        num_valid = num_valid + 1;
    end
end
X0{jj} = xx0;
end