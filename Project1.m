
clc
clear all
close all

% load the data
startdate = '01/01/1994';
enddate = '01/01/2023';
f = fred
% france
Y = fetch(f,'CLVMNACSCAB1GQFR',startdate,enddate);
y = log(Y.Data(:,2));
q = Y.Data(:,1);
% japan
Yj = fetch(f,'JPNRGDPEXP',startdate,enddate);
yj = log(Yj.Data(:,2));
qj = Yj.Data(:,1);

lam = 1600

[ytilde,tauGDP] = qmacro_hpfilter(y, lam);
[yjtilde,taujGDP] = qmacro_hpfilter(yj, lam);

% plot detrended GDP
dates = 1994:1/4:2023.1/4;
figure
title('Detrended log(real GDP) 1994Q1-2023Q1'); hold on
plot(q, ytilde,'b', qj, yjtilde,'r')
datetick('x', 'yyyy-qq')

% compute sd(y), sd(yj), corr(y,yj) (from detrended series)
T = size(y,1);
ysd = std(ytilde)*100;
yjsd = std(yjtilde)*100;
corryyj = corrcoef(ytilde(1:T),yjtilde(1:T)); corryyj = corryyj(1,2);

disp(['Percent standard deviation of detrended log real GDP in France: ', num2str(ysd),'.']); disp(' ')
disp(['Percent standard deviation of detrended log real GDP in Japan: ', num2str(yjsd),'.']); disp(' ')
disp(['Contemporaneous correlation between detrended log real GDP in France and Japan: ', num2str(corryyj),'.']);
