function readIn()
load pars
ni = 104;
for k = 1:ni
    ss={};
    
    data_path=['./results_' num2str(k) ];
    s = what(data_path);
    
    %for some reason 'what' can return 2 copies of the same thing, just pick
    %one of them so matlab is happy (the first is always safe)
    s=s(1);
    n = size(s.mat,1);
    
    for kk = 1:n
        temp=load([data_path '/' s.mat{kk}]);
        ss=cat(1,ss,temp.ss);
    end
    
    nn=size(ss,1);
    k
    if k==1;
        c = zeros(nn, ni);
        c2 = zeros(nn,ni);
    end
    parfor i = 1:nn
        temp = ss{i};
        temp2 = onlySS(temp,k,par(:,i));
        c(i,k) = size(temp,1);
        c2(i,k) = size(temp2,1);
    end
end
% toc
matlabpool close
save ssCount.mat c c2

function out = onlySS(uv,netInd,currentPar)
% fn = ['network' num2str(netInd)];
fh = str2func(['network' sprintf('%d',netInd)]);

rmInd=[];
for i = 1:size(uv,1)
    [dydt,jac] = fh(uv(i,:),currentPar(1:3),currentPar(4:6),currentPar(7:9));
    a = real(eig(jac));
        if sum(a<0) < 3
        rmInd=[rmInd,i]; % not stable fix point
        end
end
uv(rmInd,:)=[];
out = uv;