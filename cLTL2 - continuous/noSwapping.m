function Mw = noSwapping(Mw)
%load 'GOBLUE_2016_11_30_18h52m'
%filename = 'noSwapping';
for t=1:length(Mw)
   Mwi = Mw{t};
   for i=1:size(Mwi,1)
       for j=1:size(Mwi,1)
           if i ~= j
               wij = Mwi(i,j);
               wji = Mwi(j,i);
               if wij + wji == 2
                  Mwi(i,j) = 0;
                  Mwi(j,i) = 0;
                  Mwi(i,i) = 1;
                  Mwi(j,j) = 1;
               end
           end
       end
   end
    Mw{t} = Mwi;
end
%save(filename,'WT','WT','Mw','Mw','ZLoop','ZLoop','A','A','mygrid','mygrid');