% this method removes symmetrical parameter combinations as a function of
% node layout

%the old methodology used a O(n!) algorithm, which is gross, this one
%should be approximately O(nlogn)

function parm_arr = get_nodes_no_symmetry_fast(network, parms)


p1=single([0 0 1;1 0 0;0 1 0]);
p2 = p1';
p3 = single([0 1 0;1 0 0;0 0 1]);
p4 = single([0 0 1;0 1 0;1 0 0]);
p5 = single([1 0 0;0 0 1;0 1 0]);

parmsize = size(parms,1); 
parm_arr = zeros(parmsize,3,3);

%reshape the arrays
for parmi=1:parmsize;
   parm_arr(parmi,:,:) = reshape(parms(parmi,:),3,3);
end

%get the valid permutations for each network
if(network ==1 || network ==84)
    perms = zeros(5,3,3);
    perms(1,:,:) = p1;
    perms(2,:,:) = p2;
    perms(3,:,:) = p3;
    perms(4,:,:) = p4;
    perms(5,:,:) = p5;
elseif(network ==8)
    perms = zeros(1,3,3);
    perms(1,:,:) = p5;
else
    fprintf('only networks 1, 84, and 8 are supported\n');
end

parmchar = zeros(size(parm_arr,1),9);
%replace each parameter with its smallest permutation
startTime = tic;
for i=1:size(parm_arr,1)
    parmchar(i,:) = get_smallest_permutation(parm_arr(i,:,:), perms);
    %parmchar(i,:) = get_largest_permutation(parm_arr(i,:,:), perms);
    
    if(mod(i,1000)==0)
        fprintf('%d / %d completed in %.3f seconds\n',i,size(parm_arr,1),toc(startTime));
    end
end

%flatten them back out
%for parmi=1:parmsize;
%   parms(parmi,:) = reshape(parm_arr(parmi,:,:),1,9);
%end

%find the unique values
parm_arr = unique(parmchar,'rows');

end


%given a parameter and a set of possible permutations return the smallest
%possible permutation
function parm_min = get_smallest_permutation(parm1, perm_arr)

parm = squeeze(parm1);
parm_min = reshape(parm,1,9);
for i=1:size(perm_arr,1)
    perm = squeeze(perm_arr(i,:,:));
    parmtemp = reshape(perm*parm*perm',1,9);
    if(strcmp_christophe(parm_min,parmtemp)>0)
        parm_min = parmtemp;
    end
    
end
end

%given a parameter and a set of possible permutations return the smallest
%possible permutation
function parm_min = get_largest_permutation(parm1, perm_arr)

parm = squeeze(parm1);
parm_min = reshape(parm,1,9);
for i=1:size(perm_arr,1)
    perm = squeeze(perm_arr(i,:,:));
    parmtemp = reshape(perm*parm*perm',1,9);
    if(strcmp_christophe(parm_min,parmtemp)<0)
        parm_min = parmtemp;
    end
    
end
end

%find out if string 1 is greater than string 2, returns 1,0,-1 as T,eq,F
function c = strcmp_christophe(s1, s2)

l=min(length(s1), length(s2));

%find differences
i=find(s1(1:l)~=s2(1:l));
%if there are no differences then the longer string is greater
if isempty(i)
	if length(s1)<length(s2)
		c=-1;
	elseif length(s1)==length(s2)
		c=0;
	else
		c=1;
	end
	return
end
%only the first difference is significant
i=i(1);
if s1(i)<s2(i)
	c=-1;
else
	c=1;
end


end