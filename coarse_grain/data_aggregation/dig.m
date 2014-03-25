%this file takes the outputs of readIn and generates the required figures
%with them.  This version also returns a copy of all numbers that were
%calculated


function [mx, ave, filterMx, multiProb] = dig()
clear all; close all;
load ssCount_augmented.mat
plotStat(c,0)
[mx, ave, filterMx, multiProb] = plotStat(c2,1);

function [mx, ave, filterMx, multiProb] = plotStat(c,type)
[m,n]= size(c);
mx = max(c,[],1);
filterMx = zeros(size(mx));
ave = zeros(1,n);
multiProb = zeros(1,n);
for col  = 1:104
    count = hist(c(:,col),1:mx(col));
    filterMx(col) = find(count>100,1,'last');        
    prob = count/sum(count);
    ave(col) = prob*(1:mx(col))';
    if type == 1
        multiProb(col) = sum(prob(5:end)); %fully connected, use 5
    else
        multiProb(col) = sum(prob(12:end));
    end
end

figure
subplot(2,2,1)
plot(mx,'r-o','linewidth',2)
% axis([1 585 0 inf])
set(gca,'fontsize',18)
ylabel('Max Multistability','fontsize',18)

subplot(2,2,2)
plot(ave,'r-o','linewidth',2)
% axis([1 585 0 inf])
set(gca,'fontsize',18)
ylabel('Ave Multistability','fontsize',18)

subplot(2,2,3)
plot(filterMx,'r-o','linewidth',2)
% axis([1 585 0 inf])
set(gca,'fontsize',18)
xlabel('Network Index','fontsize',18)
ylabel('FilterMx Multistability','fontsize',18)

subplot(2,2,4)
plot(multiProb,'r-o','linewidth',2)
xlabel('Network Index','fontsize',18)
ylabel('prob of multistability')