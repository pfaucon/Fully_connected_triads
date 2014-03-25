function out = stable_steady(steadyStates,netInd,currentPar)
% fn = ['network' num2str(netInd)];
fh = str2func(['network' sprintf('%d',netInd)]);
%removed =0;
%rmInd=zeros(size(uv,1),1);
rmInd=[];
for i = 1:size(steadyStates,1)
    [~,jac] = fh(steadyStates(i,:),currentPar(i,1:3),currentPar(i,4:6),currentPar(i,7:9));
    a = real(eig(jac));
        if sum(a<0) < 3
        rmInd=[rmInd,i]; % not stable fix point
    %    removed = removed+1;
    %    rmInd(removed)=i;
        end
end
steadyStates(rmInd,:)=[];
out = steadyStates;


%just to remember how to use this
function plot_stable_steady()
    load ssCount.mat
    
    network =8;
    %find indices of all the parameter sets which have >= 6 stable steady states 
    list = find(c2(:,network) >= 6);
    
    %the parameters that correspond to those steady states
    parms = pars(:,list);
    
    %how many states did each parameter have?
    sstates = c2(list,network);

    %now each column is the 9 parameters with the 10th row containing the
    %number of steady states
    combo = cat(1,parms,sstates');
    
    %retrieve a reference to the 69th parameter combination with more than
    %5 stable steady states (2 auto, .1 cross control), sanity check
    list(69)
    
    ss8 = stable_steady(ss{list(1)},8,pars(:,list(1)))
    ss6 = stable_steady(ss{list(69)},8,pars(:,list(69)))
    
    %graph them
    x8 = ss8(:,1)
    y8 = ss8(:,2)
    z8 = ss8(:,3)
    
    x6 = ss6(:,1)
    y6 = ss6(:,2)
    z6 = ss6(:,3)
    
    hold on
    plot3(x8,y8,z8,'r*');
    plot3(x6,y6,z6,'b*');
    
    xlabel('x')
    ylabel('y')
    zlabel('z')
    


end

    function SVD
        
        %grab the first 100,000 parameter sets
        
        parmini = pars;
parmini = parmini(:,100000:end)=[]
parmini = parmini(900000:end)=[]
parmini(900000:end)=[]
parmini = pars;
parmini(900001:end)=[];
help reshape
parmini = reshape(parmini,9,[]);
        
    end
