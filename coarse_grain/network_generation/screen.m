function main()
clear all; close all;

con = reshape(combinator(single(3),9,'p','r')',3,3,[]);

ind = sum(sum((con>2),1),2) > 5;

con(:,:,ind(:)) = [];
p1=single([0 0 1;1 0 0;0 1 0]);
p2 = p1';
p3 = single([0 1 0;1 0 0;0 0 1]);
p4 = single([0 0 1;0 1 0;1 0 0]);
p5 = single([1 0 0;0 0 1;0 1 0]);


i = 1;
while ~ (i>size(con,3))
    n = size(con,3);
    ind = findMatch(p1,con,i,n);
    con(:,:,ind) = [];
    
    n = size(con,3);
    ind = findMatch(p2,con,i,n);
    con(:,:,ind) = [];
    
    n = size(con,3);
    ind = findMatch(p3,con,i,n);
    con(:,:,ind) = [];
    
    n = size(con,3);
    ind = findMatch(p4,con,i,n);
    con(:,:,ind) = [];
    
    n = size(con,3);
    ind = findMatch(p5,con,i,n);
    con(:,:,ind) = [];
    
    i = i+1;
end
save con.mat con

function ind = findMatch(perm,con,i,n)
ind=[];
mat = con(:,:,i);
temp = perm*mat*perm';

if ~isequal(temp,mat)
    for j = (i+1):n
        a = abs(con(:,:,j)-temp);
        if sum(a(:)) == 0
            ind=[ind j];
        end
    end
end