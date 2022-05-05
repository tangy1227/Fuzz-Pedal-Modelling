%% Importing Audio and Parameters
file = 'clean.mp3';
gain = 30; % Choose range between 1-100
FREQ = 5; % Choose range between 1-10
SHAPE = 8; % Choose range between 1-10, change how much amplitude offset apply to the signal before distorting
lowpass_value = 10000; % range between 1Hz-20kHz
bandstop_value = 1;
highpass_value = 500; % range between 100Hz-20kHz
Volume = 40; % Choose range between 0-100

%% Player the audio
player = processChain(file,gain,SHAPE,FREQ,...
    lowpass_value,bandstop_value,highpass_value,Volume);
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

% Low-pass Filter
function filter_LP = lowpassFilter(audio, fc, fs)
lp = fir1(48,fc*2/fs,'low');
audio = filter(lp,1,audio);
filter_LP = audio;
end

% Band-pass Filter
function filter_BP = bandpassFilter(audio,highpass_value,lowpass_value,fs)
bp = fir1(48,[highpass_value*2/fs,lowpass_value*2/fs],'bandpass');
audio = filter(bp,1,audio);
filter_BP = audio;
end

% Band-stop Filter
function filter_BS = bandstopFilter(audio,highpass_value,lowpass_value,...
    bandstop_value, fs)
bp = fir1(bandstop_value,[highpass_value*2/fs,lowpass_value*2/fs],'stop');
audio = filter(bp,1,audio);
filter_BS = audio;
end

% processChain
function player = processChain(file,gain,SHAPE,FREQ,lowpass_value,...
    bandstop_value,highpass_value,Volume_out)
[audio,fs] = audioread(file);
signal_mono = audio(:,1); % make the audio mono
signal_mono = highpassFilter(signal_mono,100,fs); % remove DC offsets, bass frequencies

[audio_env, ~] = envelope(signal_mono, 512); % calculate envelope
signal = gain * (signal_mono + audio_env.*(SHAPE/10)); % adds amplitude offset
signal_distorted = fuzz_distortion(signal, FREQ/10);

% signal_distorted = highpassFilter(signal_distorted,highpass_value,fs);
% signal_distorted = lowpassFilter(signal_distorted,lowpass_value,fs); 
signal_distorted = bandpassFilter(signal_distorted,highpass_value,lowpass_value,fs); 
% signal_distorted = bandstopFilter(signal_distorted,highpass_value,lowpass_value,...
%     bandstop_value, fs);

% signal_distorted = highpass(signal_distorted,highpass_value,fs);
% signal_distorted = lowpass(signal_distorted,lowpass_value,fs); 
player = audioplayer(((Volume_out/100) .* signal_distorted), fs);
end
