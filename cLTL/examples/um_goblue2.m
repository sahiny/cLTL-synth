Obs = zeros(13*21,1);
Obs=Obs(:)==1;

g = [1 1 1 1;
     1 0 0 0;
     1 0 1 1;
     1 0 0 1;
     1 1 1 1];
 
o = [1 1 1 1;
     1 0 0 1;
     1 0 0 1;
     1 0 0 1;
     1 1 1 1];
 
b = [1 1 1 0;
     1 0 0 1;
     1 1 1 1;
     1 0 0 1;
     1 1 1 0];
 
l = [1 0 0 0;
     1 0 0 0;
     1 0 0 0;
     1 0 0 0;
     1 1 1 1];
 
u = [1 0 0 1;
     1 0 0 1;
     1 0 0 1;
     1 0 0 1;
     1 1 1 1];

e = [1 1 1 1;
     1 0 0 0;
     1 1 1 1;
     1 0 0 0;
     1 1 1 1];
 
m = [1 0 0 0 1;
     1 1 1 1 1;
     1 0 1 0 1;
     1 0 1 0 1;
     1 0 1 0 1]; 

 goblue = [            zeros(1,21);
    zeros(5,6), g, zeros(5,1), o, zeros(5,6);
                zeros(1,21);
    zeros(5,1), b, zeros(5,1), l, zeros(5,1), u,zeros(5,1),e,zeros(5,1);
                zeros(1,21)];
            
goblue = flipud(goblue)';
            
um = [zeros(2,21);
    zeros(1,2) ones(1,17),zeros(1,2);
    zeros(1,2) 1 zeros(1,15) 1 zeros(1,2);
     zeros(5,3), ones(5,1) zeros(5,1),u,zeros(5,2),m,zeros(5,1) ones(5,1) zeros(5,3);
         zeros(1,2) 1 zeros(1,15) 1 zeros(1,2);
     zeros(1,2) ones(1,17),zeros(1,2);
     zeros(2,21)];
 
 um = flipud(um)';
 
%  um = 1:273;
%  um = mod(um(:),2);
 UM = find(um(:)==1);
nUM = find(um(:)==0)';
GO = find(goblue(:)==1);
nGO = find(goblue(:)==0)';

f_um = 'G(F(And(';
f_go = 'G(F(And(';

for i=1:length(UM)
   f_um = strcat(f_um, '[',num2str(UM(i)),',1],');  
end

f_um = strcat(f_um, 'Neg([',num2str(nUM),',1]))))');  

for i=1:length(GO)
   f_go = strcat(f_go, '[',num2str(GO(i)),',1],'); 
end

f_go = strcat(f_go, 'Neg([',num2str(nGO),',1]))))');  

grid_size=[13,21];
mygrid = ones(grid_size);

for i=1:numel(mygrid)
    if mod(i, grid_size(2))~=0 
        adj(i, i+1) = 1;
    end
    if mod(i, grid_size(2))~=1
        adj(i, i-1) = 1;
    end
    if i<=grid_size(2)*(grid_size(1)-1);
        adj(i, i+grid_size(2)) = 1;
    end
    if i>grid_size(2);
        adj(i, i-grid_size(2)) = 1;
    end
end
