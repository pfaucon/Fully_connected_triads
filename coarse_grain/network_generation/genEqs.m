%genEqs will load up the con.mat file generated by the screen and use it to
%define the networks that should be generated. con.mat essentially has +/-
%for all edges that can be used to define a network structure

function genEqs()
clear all; close all;

syms a1 a2 a3 b1 b2 b3 c1 c2 c3 x1 x2 x3 real

a= [a1 a2 a3]; b =[b1 b2 b3]; c =[c1 c2 c3]; x=[x1 x2 x3];

coe = [a;b;c];
load con.mat

grp = sum(sum((con==3),1),2);
newCon = con(:,:,grp(:) == 0);

n = size(newCon,3);

po=4; theta = 0.5;
eqs(:,:,1) = repmat(x.^po',1,3);


eqs(:,:,2) = theta^po;
eqs(:,:,3) = 0;
% temp = syms(size(eqs));
% dydt = syms(n,3);

denom = repmat(theta^po +(x.^po)',1,3);
for i = 1:n
    temp2 = newCon(:,:,i);
    for j =1:3
        for k = 1:3
            temp(j,k) = eqs(j,k,temp2(j,k))./denom(j,k);
        end
    end
    dydt(:,i)= (sum(temp.*coe,1)-x)';
    jac(:,:,i) = jacobian(dydt(:,i),x);
end

table={'a1','a(1)';...
    'a2','a(2)';...
    'a3','a(3)';...
    'b1','b(1)';...
    'b2','b(2)';...
    'b3','b(3)';...
    'c1','c(1)';...
    'c2','c(2)';...
    'c3','c(3)';...
    'x1','x(1)';...
    'x2','x(2)';...
    'x3','x(3)'
    };
sym2m(dydt,jac,table);

% sym2m(dydt,jac,table);

function out = sym2m(dydt,jac,table)

n = size(dydt,2);

%if we don't have a functions folder then make one
if(exist('./functions','dir') == 0)
    mkdir('./functions')
end

for i = 1:n
    der = char(dydt(:,i)); jacob=char(jac(:,:,i));
    der = der(8:(end-1)); jacob = jacob(8:(end-1));
    for j = 1:size(table,1)
        der = strrep(der,table{j,1},table{j,2});
        jacob = strrep(jacob,table{j,1},table{j,2});
    end
    % this code changes the derivative vector into a column vector
    % in matlab 2010a used by Xiao the top version works
    % in later versions of matlab the bottom version works
    der = strrep(der,'],[',';');
    der = strrep(der,'], [',';');
    der(1)=[];
    der(end-1)=[];
    jacob = strrep(jacob,'],','];');
    
    fname = ['network' num2str(i) '.m'];
    fid = fopen(['./functions/' fname],'wt');
    if fid==-1
        fprintf('Could not open %s.\n',fname);
    else
        fprintf(fid,'function [dydt,jac]=network%s(x,a,b,c)\n\n',num2str(i));
        fprintf(fid,'dydt=%s;\n',der);
        fprintf(fid,'jac=%s;\n',jacob);
        fclose(fid);
    end
end