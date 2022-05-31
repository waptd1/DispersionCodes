clear;
clc;

% Import .mat file containing dispersion image data; Normalized Wn matrix,...
% frequency vector f and velocity vector c.
load dispersion_image_data.mat

% or import .mat or .xlsx file containing Wn, c and f matrix e.g. Wn = xlsread('Wn.xlsx');
% or define frequency vector in the script itself e.g. f=[0 0.5 1.0 1.5 2.0 ...]; 

% Wn = input('Wn = '); 
% f = input('f = '); 

% Select frequency then find its index, this can be found manually also...
% by directly scanning through frequency vector c.

fr = 15; % choosen frequency
fi = find(abs(f-fr)<.02); % index of fr in f.

% select the vector from Wn corresponding to f=fr Hz
wn = Wn(:,fi);

% Now choosing the window along vector c for searching modes. The velocity...
% window can be selected by looking at the dispersion image along the...
% chosen frequency. This window can be based on the choice of number...
% of modes and which modes' quality factor is to be calculated.
% e.g. velocity window between c=250 and c=700 m/s is chosen for f=15 Hz...
% for three modes by looking at the dispersion image for f=15 Hz.


crr = 250; % intitial value for window of c
css = 700; % final value for window of c
ci = find(abs(c-crr)<.001); % index for crr
cf = find(abs(c-css)<.001); % index for css 

% Loop to determine cr and cs for each mode and saving it in array q. 
% It can be picked manually too using GUI directly from plot of wn.

tv = 0.35; % threshold value of Wn is defined for extracting modes
wn(wn<tv)=-1;
z=1; % counter
for i=ci:cf
    if wn(i)*wn(i+1)<0
        if mod(z,2)~=0
            q(1,z)=c(i+1);
            z=z+1;
        else
            q(1,z)=c(i);
            z=z+1;
        end
    end
end

% calculating quality factor and saving it in array qf
wn = Wn(:,fi); % selecting vector of Wn corresponding to fr
ts = sum(wn); % total sum of Wn (or wn) along vector c for fr
sz = size(q); % calculating size of q
m = sz(2); 

% define quality factor array
qf = zeros(1,m/2); 
ct = 1; % loop counter will become equal to number of modes extracted
for i=1:2:m
    qf(ct)=1-sum(wn(find(abs(c-q(1,i))<.001):...
    find(abs(c-q(1,i+1))<.001)))/ts;
    ct=ct+1;
end

% Repeat the above code for calculating quality factor for different modes...
% for the choosen frequency fr

% plot of modes (wn) for chosen frequency.
wn(wn<tv)=NaN;
figure; box on;
hold on;
p=plot(c(ci:cf),wn(ci:cf)); p.Color='k';
r=plot([c(ci) c(cf)], [0.35 0.35]); r.Color='r';
for i=1:length(q)
    ln=line([q(i) q(i)], [0 0.35]);
    ln.Color='b';
end
hold off;
legend(r,{'Wn = 0.35'});
dim=[.7 .75 .1 .1];
str = {'\rmfr = ' num2str(fr)};
annotation('textbox',dim,'String',str,'FitBoxToText','on',...
    'BackgroundColor','w','EdgeColor','k');
xlim([c(ci) c(cf)]); ylim([0 1]);
xlabel('Phase Velocity (m/s)');
ylabel('Normalized Amplitude');
