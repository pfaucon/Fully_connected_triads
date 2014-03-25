%this file is for generic fine-grain runs, it does not take advantage of
%symmetry in the results. It does save them to a file for later use

function pars = genPars()
a = reshape(combinator(single(5),9,'p','r')',9,[]);


a(:,sum(abs(a-3),1)==0 | sum(abs(a-4),1)==0)=[];

pars = zeros(size(a));

for i = 1:size(a,1)
    for j = 1:size(a,2)
        switch a(i,j)
            case 1
                pars(i,j)=0.1;
            case 2
                pars(i,j)=0.5;
            case 3
                pars(i,j)=1;
            case 4
                pars(i,j)=2;
            case 5
                pars(i,j)=5;
            otherwise
                disp('Unknown value.')
        end
        
    end
end
save par_fg.mat pars;
end