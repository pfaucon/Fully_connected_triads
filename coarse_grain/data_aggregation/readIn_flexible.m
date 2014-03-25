%this function takes the results generated in the various runs and merges
%them into a single file
%NOTE: make sure to addpath the directories with the dat files

%k should be the network number you are reading in,
%data_path is the relative(or absolute) path to the FOLDER which contains your .mat data files
%parfile_name is the path to the FILE which was used to generate the results
function readIn_flexible(k, data_path, parfile_name)
%clear all; close all;
addpath('./functions/')

load(parfile_name)

ss={};

%this is the pathname to the folder, it will need to be updated
%this should retrieve a list of all .mat files in the directory
% in theory in alphanumeric order, otherwise later steps can fail
s = what(data_path);

%for some reason 'what' can return 2 copies of the same thing, just pick
%one of them so matlab is happy (the first is always safe)
s=s(1);
n = size(s.mat,1);

for kk = 1:n
    temp=load([data_path '/' s.mat{kk}]);
    ss=cat(1,ss,temp.ss);
end

%allocate the space to store things, not doing this is exceptionally painful
%on mac matlab, their dynamic memory allocation is garbage
nn=size(ss,1);
c = zeros(nn, 1);  %count of unstable SS
c2 = zeros(nn,1);  %count of stable SS
steadyState = cell(nn,1); %initial condition space location of unstable SS
stableSteadyStates = cell(nn,1); %initial condition space location of stable SS

for i = 1:nn
    temp = ss{i};
    temp2 = onlySS(temp,k,pars(:,i));
    c(i) = size(temp,1);
    c2(i) = size(temp2,1);
    steadyState(i) = {temp};
    stableSteadyStates(i) = {temp2};
    if(mod(i,100000)==0)
        fprintf('current iteration %d\n',i);
    end
end

save(['ssCount_net_' num2str(k) '.mat'], 'c2', 'ss', 'stableSteadyStates');
end

function out = onlySS(uv,netInd,currentPar)
% fn = ['network' num2str(netInd)];
fh = str2func(['network' sprintf('%d',netInd)]);
%removed =0;
%rmInd=zeros(size(uv,1),1);
rmInd=[];
for i = 1:size(uv,1)
    [~,jac] = fh(uv(i,:),currentPar(1:3),currentPar(4:6),currentPar(7:9));
    a = real(eig(jac));
    if sum(a<0) < 3
        rmInd=[rmInd,i]; % not stable fix point
        %    removed = removed+1;
        %    rmInd(removed)=i;
    end
end
uv(rmInd,:)=[];
out = uv;
end