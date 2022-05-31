% This code generates the sythetic signal.

clear; 
clc;

% Import dispersion plot data saved as matrix cf. The data is sampled at...
% each frequency interval of df = 0.5 Hz in the given example
load dispersion_plot_data_complex.mat

df = 0.5; % frequency interval
td = 1/df; % total duration of signal

% define sampling frequency and calculate time interval
fs = 100; % sampling frequency
dt = 1/fs; % sampling time interval
t = 0:dt:td-dt; % time vector 
f = 0:df:100; % frequency vector
w = 2*pi*f; % circular frequency

N = td/dt; % number of sample points in the signal along time

% define number of geophones,source offset and geophone spacing.
M = 48; % number of geophones
so = 5; % source offset
dx = 5; % geophone spacing 

x = so+((1:M)-1)*dx; % geophone array position

% Calculate wavenumber from the dispersion plot data.
% The rows of cf represents each mode data with frequency, with first...
% row as 1st mode and 2nd row as 2nd mode and so on. The zero or NaN...
% values means there is no data for those modes at particular frequencies.

sf = size(cf);
nm = sf(1); % number of modes is equal to number of rows in cf.
km(1:sf(1),:) = w./cf(1:sf(1),:); % wave number for each modal data
km(isnan(km))=0; km(isinf(km))=0; % used to replace NaN and Inf values with zero

Am = 1; % constant relative amplitude at each frequency
a = 1; % decay coefficient

% calculate synthetic signal
s = zeros(length(t),length(x)); % define signal array
for i=1:nm
    disp(i)
    ff=find(cf(i,:),1,'first'); % for finding first non zero value in cf in each row
    for j=1:length(t)
        for k=1:length(x)
            for n=ff:length(f)-1
                s(j,k)=s(j,k)+Am*exp(-a*x(k))*exp(1j*(-w(n)*t(j)+km(i,n)*x(k)));

% When relative amplitude and decay coefficient are function of frequency...
% use following line.
%                 s(j,k)=s(j,k)+Am(i,n)*exp(-a(n)*x(k))*exp(1j*(-w(n)*t(l)+km(i,n)*x(k)));
            end
        end
    end
end

% synthetic signal with time at each geophone
sg = real(s);

% The follong command in next line can be used to save sg in signal_data.mat file
% save('signal_data','sg'); % uncomment it to run the command 

% plot of dispersion data
cf(cf==0)=NaN;
figure;plot(f,cf,'LineStyle','-.'); 
lgd = legend('\itMode\rm-1','\itMode\rm-2','\itMode\rm-3');
xlim([0 50]); ylim([100 1000]);
title('Input frequency vs velocity dispersion curves');
xlabel('Frequency (Hz)'); ylabel('Phase Velocity (m/s)'); 
colormap jet;
axis xy; 

% plot of synthetic signal
mx=max(sg); sgnor=sg./mx;
sz=size(sg);
v=zeros(sz(1),sz(2)); vx=(.27:.27:.27*sz(2));
for i=1:sz(2)
    v(:,i)=v(:,i)+vx(i);
end
s2=sgnor+v; 
figure;plot(s2(:,1:4:M),t); % every 4th geophone's signal is plotted
hold on;
ax=gca; 
ax.Units='normalized';
ax.Position=[.095 .16 .88 .71];
axpos = ax.Position;
ax.XTick=round(s2(1,1:8:M),5);
ax.XTickLabel=1:length(1:4:M)/length(1:8:M):length(1:4:M);
ax.YTick=0:.5:2; 
ax.TickDir='out';
ax.XAxisLocation='bottom';
ax.YAxisLocation='left';
ax.XDir='normal';
ax.YDir='reverse';
set(ax,'box','off','color','none')
b = axes('Position',axpos,'box','on','xtick',[],'ytick',[]);
axes(ax);     

xlabel('Geophones');
ylabel('Time (s)');

ax2 = axes('Position',axpos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ax2.XLim=ax.XLim;
ax2.XTick=round(s2(1,1:8:M),5);
ax2.XTickLabel=x(1:8:M);
ax2.YTick=[];
ax2.TickDir='out';
xlabel('Distance from source (m)');
