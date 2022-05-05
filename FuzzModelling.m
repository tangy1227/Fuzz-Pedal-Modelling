%% Importing Audio and Parameters
file = 'SO_DE_145_guitar_bang_pluck_clean_Dbmaj.wav';

GAIN = 30; % Choose range between 1-100
FREQ = 5; % Choose range between 1-10
SHAPE = 8; % Choose range between 1-10, changing distortion wave shape
HIGH = 5000; % range between 1Hz-20kHz (lowpass_value)
MID = 30; % Choose range between 0-30, higher value gives more MID cutoff
LOW = 200; % range between 100Hz-500Hz (highpass_value)
Volume = 20; % Choose range between 0-100

%% Player the audio
player = processChain(file,GAIN,SHAPE,FREQ,HIGH,MID,LOW,Volume);
play(player)
% Type stop(player) in Command Window to pause the audio

%% Functions
% Fuzz Distortion
function fuzz = fuzz_distortion(audio, clip_val)
for a = 1:length(audio)
    if (audio(a) > clip_val)
        audio(a) = audio(a) / (1+abs(audio(a)));
    elseif (audio(a) < -clip_val)
        audio(a) = audio(a) / (1+abs(audio(a)));
    else
        audio(a) = audio(a);
    end
end
fuzz = audio;
end

% High-pass Filter
function filter_HP = highpassFilter(audio, fc, fs)
hp = fir1(48,fc*2/fs,'high');
audio = filter(hp,1,audio);
filter_HP = audio;
end

% Band-pass Filter
function filter_BP = bandpassFilter(audio,highpass_value,lowpass_value,fs)
bp = fir1(48,[highpass_value*2/fs,lowpass_value*2/fs],'bandpass');
audio = filter(bp,1,audio);
filter_BP = audio;
end

% Notch Filter
function filter_notch = notchFilter(audio,notch_gain, fs)
w0 = 500*2/fs;
Q = w0/5;
[num,den]=iirnotch(w0,Q,notch_gain);
filter_notch = filter(num, den, audio);
end

% processChain
function player = processChain(file,gain,SHAPE,FREQ,lowpass_value,...
    MID,highpass_value,Volume_out)
[audio,fs] = audioread(file);
signal_mono = audio(:,1); % make the audio mono
signal_mono = highpassFilter(signal_mono,100,fs); % remove DC offsets, bass frequencies

[audio_env, ~] = envelope(signal_mono, 512); % calculate envelope
signal = gain * (signal_mono + audio_env.*(SHAPE/10)); % adds amplitude offset
signal_distorted = fuzz_distortion(signal, FREQ/10);

% signal_distorted = highpassFilter(signal_distorted,highpass_value,fs);
% signal_distorted = lowpassFilter(signal_distorted,lowpass_value,fs); 

signal_distorted = bandpassFilter(signal_distorted,highpass_value,lowpass_value,fs); 
signal_distorted = notchFilter(signal_distorted,MID, fs);
% signal_distorted = bandstopFilter(signal_distorted,highpass_value,lowpass_value,...
%     bandstop_value, fs);

player = audioplayer(((Volume_out/100) .* signal_distorted), fs);
end
