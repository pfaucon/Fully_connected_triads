%genPars will generate all combinations of parameters with 5 possibilities
%for mutual connection edges, and 3 possibilities for auto-activation edges

function pars = genPars()
a = reshape(combinator(single(5),9,'p','r')',9,[]);

ind=[1,5,9];
% five pars: 0.1 0.2 0.5 1 5
% for self regulation, only 3 values:
% 0.1 0.5 1
a = a(:,sum(a(ind,:)==2,1)==0);
a = a(:,sum(a(ind,:)==5,1)==0);

pars = zeros(size(a));

for i = 1:size(a,1)
    for j = 1:size(a,2)
        switch a(i,j)
            case 1
                pars(i,j)=0.1;
            case 2
                pars(i,j)=0.2;
            case 3
                pars(i,j)=0.5;
            case 4
                pars(i,j)=1;
            case 5
                pars(i,j)=5;
            otherwise
                disp('Unknown value.')
        end
        
    end
end
save par.mat pars;
end