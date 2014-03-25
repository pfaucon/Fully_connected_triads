%this file should contain all of the necessary components needed to run
%the exiperiments fully

%standard'ish functions are included from the parent directory
addpath('standard functions');
addpath('network_generation/');
addpath('data_run');
addpath('data_aggregation/');

%generate the functional form derivatives and jacobian 
screen;
genEqs;

%generate non-symmetrical parameter sets so we don't do more work than we
%need to
genPars;

%run the low resolution version
%NOTE: this takes a LONG time, an example of the script used to distribute
%on saguaro (ASU compute cluster) is shown below
network = 84;
chunksPerJob = 5;
parmsPerChunk = 10;
netsolver(84,'par.mat',network,parmsPerChunk,chunksPerJob);


%perform the runs (this should probably be performed with a batch submit
%like we did on sagauro, code attached is bash, scripttop is a generic
%torque script header with job length info etc...
%NOTE: make sure that copying this into a new bash script doesn't bork the
%line endings
% #!/bin/sh
% 
% matlab_exec=matlab
% njobs=422 
% nParametersPerChunk=500
% nChunksPerJob=2
% net=84
% 
% for f in {njobs} 
% do
%  cstart=$(($f * $nChunksPerJob))
%   X="addpath ~/FCT_research; addpath ~/FCT_research/Code;addpath ~/FCT_research/Code/functions; netsolver($net,$f,$nParametersPerChunk,$nChunksPerJob)"
%   echo ${X} > matlab_command_$f.m
%   echo "${matlab_exec} -nodisplay -nosplash < ~/FCT_research/matlab_command_$f.m" > command
% 
%   #this is the part that should interface with the PBS server
%   cat scripttop > run_job
%   cat command >> run_job
% 
%   #this is a torque (job scheduler) command
%   qsub run_job
% done

%once all the files have been generated copy them back to this system
%somewhere.  With readIn you'll have to separate them by folder, this
%version was designed to read in a subset of the results (e.g. net84 only)
readIn_flexible(network,['./results_' num2str(network)],'par.mat');

%readIn can be used instead if you have done a full run with all results
%stored in ./results_## where ## is the number of the network with no
%padding (results_1, not results_01)
%readIn;

%on the results of readIn we can run dig to get our statistics and generate
%our graphs
%dig;
