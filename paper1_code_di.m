clear;
clc;

% Import signal data with each column containing a signal recorded at...
% each geophone with time.
load signal_data.mat

% Vertical stacking/padding done ten times, it can be done using for-loop too.
sg = [sg;sg;sg;sg;sg;sg;sg;sg;sg;sg];

sz = size(sg); % size of signal array
M = sz(2); % calculate number of geophones
so = 5; % source offset used to generate signal
dx = 5; % geophone spacing used to generate signal
x = so+((1:M)-1)*dx; % geophone array position

% calculating length L equal to a power of 2 for doing FFT.
L = 2^nextpow2(sz(1)); 
fs = 100; % sampling frequency used to generate signal
fv = fs*linspace(0,1,L+1); % frequency vector
w = 2.*pi*fv; % circular frequency

U = fft(sg,L); % FFT of signal over length L
Un = U./abs(U); % normalizing the FFT data

kk=round((L+1)/(fs)*50); % finding index of f = 50 Hz
ff=round((L+1)/(fs)*1); % finding index of f = 1 Hz.
dc = 0.2; % velocity increment
c = 100:dc:1000; % defining velocity vector
N = length(c); % number of data points in velocity vector
W = zeros(kk-ff+1,N); % defining dispersion image data array W

% calculating dispersion image data in array W.
for j=1:N
    disp(j)
    for k=1:kk-ff+1 
        for g=1:M
            W(k,j)=W(k,j)+exp(1i*(w(k+ff-1)./c(j))*x(g)).*Un(k+ff-1,g).*dx;
        end
    end
end

% calculating normalized W = Wn
Wn = abs(W')./max(max(abs(W))); 

% plotting dispersion image data
f=fv(ff:kk);
figure;imagesc(f,c,Wn); colormap jet; shading interp; colorbar; axis xy; 
xlim([1 50]); ylim([100 1000]);
xlabel('Frequency (Hz)'); ylabel('Phase Velocity (m/s)');
dim=[.3 .65 .15 .2];
str = {'\itM = \rm48; \it\Deltax = \rm5 m','\itso = \rm5 m'};
annotation('textbox',dim,'String',str,'FitBoxToText','on',...
    'BackgroundColor','w','EdgeColor','k');

% The follong command in next line can be used to save Wn, f and c in dispersion_image_data.mat file
% save('dispersion_image.data','Wn','f','c');
