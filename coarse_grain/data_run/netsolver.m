% solve SS numerically
% 3 node ,9 edge system
% Xiao Wang

%modified pcf, this script allows you to pass in a parameter file, and job 
%file information: 
%   jobIndex - the job number
%   numParametersPerChunk - how many parameter solutions should be stored in
%   a file
%   numChunksPerJob - how many chunks does each job create (files full of
%   parameter solutions)

function netsolver(network,parmfile,jobIndex,numParametersPerChunk,numChunksPerJob)

addpath('./functions/');

opt=optimset('Display','off','Jacobian','on','algorithm','levenberg-marquardt',...
    'TolFun',1e-4,'TolX',1e-4);
tic
[par] = init(parmfile);
toc1 = toc;

fprintf('init took: %.3f seconds\n', toc1);

firstChunk = jobIndex * numChunksPerJob;
lastChunk = ((jobIndex+1) * numChunksPerJob)-1;

chunkSize = numParametersPerChunk;

total = tic;
for i = firstChunk:lastChunk
    loop = tic;
    sweepPars(network,opt,par,i,chunkSize);
    fprintf('finished chunk %d in %.3f seconds\n',i,toc(loop));
end
time = toc(total);
fprintf('sweepPars took %.3f seconds overall, %.3f seconds/par set avg\n',time,time/(lastChunk-firstChunk));

end


function sweepPars(network,opt,par,chunkNum,chunkSize)

fn = ['network' num2str(network)];
fh = str2func(fn);

funfcn{1} = 'fungrad';
funfcn{2} = 'fsolve';
funfcn{3} = fh;
funfcn{4} = fh;
funfcn{5}=[];


n = size(par,2);
chunkStart = chunkNum*chunkSize+1;
%is this the last chunk?
if(chunkStart>n)
    return
end
    
if(chunkNum == floor(n/chunkSize))
    n = n - chunkStart+1;
else
    n = chunkSize;
end
ss = cell(n,1);

%meshgrid preparations
step = 10;
gridSize = (step+1)^3;
out = zeros(gridSize,4);

% numChunks is the number of chunks we want, run that many iterations or
% until we reach the last parameter set
for j = chunkStart:(chunkStart+n)-1
    a = double(par(1:3,j));
    b = double(par(4:6,j));
    c = double(par(7:9,j));
    
    ubound = a+b+c;
    
    [x,y,z] = meshgrid(0:(ubound(1)/step):ubound(1),...
        0:(ubound(2)/step):ubound(2),0:(ubound(3)/step):ubound(3));
    
    for i = 1:gridSize
        x0 = [x(i) y(i) z(i)];
        [xsol,~,exitflag] = fsolve_christophe(funfcn,x0,opt,a,b,c);
        out(i,:) = [xsol,exitflag];
    end
    [uv,~,~]=consolidator(out(out(:,4)==1,1:3),[],'median',0.01);
    ss{j-chunkStart+1} = uv;
end

outname = ['results' num2str(network) '_' num2str(chunkNum*chunkSize,'%07d') '-' num2str((chunkNum+1)*chunkSize,'%07d') '.mat'];
save(outname,'ss','-v7.3');
end

function [pars] = init(parmfile)
if(exist(parmfile, 'file'))
    pars = load(parmfile);
else
    fprintf('error, was unable to find ' + parmfile + '...');
    exit(1);
end

end
