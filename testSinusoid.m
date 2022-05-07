%% Generate testing sinusiod
% gain = 1;
% fs = 44100;
% duration = 2;
% ampOffset = 0.8;
% % sinusoid_test = sinusoid4test(gain, duration, fs, ampOffset);
% sinusoid_test = sinusoid4test_noOffset(gain, duration, fs);
% audio_distorted = fuzz_distortion(sinusoid_test, 0.01);

%% Plot for testing sinusoid
hold on
gain = [100, 10, 1];
fs = 44100;
duration = 2;
t = 0:1/fs:duration;
ampOffset = 0.8; % Change shape here

for g = gain
    
%     sinusoid_test = sinusoid4test(g, duration, fs, ampOffset); 
    sinusoid_test = sinusoid4test_noOffset(g, duration, fs); % No offset testing
    
    audio_distorted = fuzz_distortion(sinusoid_test, 0.01);
    plot(t(1:500), audio_distorted(1:500))
end

xlabel('Time(s)')
ylabel('Amplitude')

% title(sprintf('%d%% Amplitude Offset Distortion', ampOffset*100))
title('Clipping With Constant Offset')

legend('gain=100','gain=10','gain=1')
set(gcf,'Position',[100 100 850 640])
hold off

%% Functions
function sinusoid_test = sinusoid4test(gain, duration, fs, ampOffset)
t = 0:1/fs:duration;
% sinusoid_noEnvOffset = sin(2*pi*300*t) + 8;
sinusoid = sin(2*pi*300*t);
% calculate envelope
[audio_env, ~] = envelope(sinusoid, 512);
% adding envelope to the signal as offset
sinusoid_test = gain * (sinusoid + audio_env.*ampOffset);
end

function sinusoid_test = sinusoid4test_noOffset(gain, duration, fs)
t = 0:1/fs:duration;
sinusoid = sin(2*pi*300*t);
sinusoid_test = gain * sinusoid + 8; % Add 8 as instructed on the website
end

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
