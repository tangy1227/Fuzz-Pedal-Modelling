fs = 8000;
t = 0:1/fs:1;
signal = sin(2*pi*t);
noise = 1/2*rand(size(signal));
noisy = signal+noise;

lp = lowpassFilter(noisy,10,fs);
plot(t,noisy,t,lp)

function envelope_follower = envelopeFollower(signal,fs)
lp1 = dsp.FIRFilter('Numerator',firpm(20,[0 0.03 0.1 1],[1 1 0 0]));
% Envelope detector connects all the peaks in this signal

% squaring the input signal (demodulates the input)
% amplify by factor of two (match the final energy to its original energy)
signal = 2 * signal .* signal;

% downsampling
downsample_factor = 15;
signal = downsample(signal, downsample_factor);

% sending the signal through a lowpass filter
% signal = lowpass(signal,10,fs/downsample_factor);
signal = lp1(signal);

% sqrt(signal) to reverse the scaling distortion
signal = sqrt(signal);
envelope_follower = signal;
end

% Band-pass Filter
function filter_BP = bandpassFilter(audio, fc, fs)
% w = 0:1/100:500;
% high_pass = (j*w)./(1+j*w);
% low_pass = 1./(1+j*w);
% band_pass = high_pass .* low_pass;
bp = fir1(48,fc*2*pi/fs,'bandpass');
audio = filter(bp,1,audio);
filter_BP = audio;
end

% High-pass Filter
function filter_HP = highpassFilter(audio, fc, fs)
hp = fir1(48,fc*2*pi/fs,'high');
audio = filter(hp,1,audio);
filter_HP = audio;
end

% Low-pass Filter
function filter_LP = lowpassFilter(audio, fc, fs)
lp = fir1(48,fc*2*pi/fs,'low');
audio = filter(lp,1,audio);
filter_LP = audio;
end
