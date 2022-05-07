# ECE4803 ModellingFuzz
I created a fuzz pedal on Matlab. The goal is to replicate Z Squared DSP’s Vector Drive pedal process chain. There are seven adjustable parameters in my final delivery, such as parameters for adjusting distortion wave shape, and parameters for adjusting equalizer. The audio processing is not real-time. So, users will need to load their own guitar recordings in the code.

## Usage
The `fuzzModelling.m` is the replicated pedal, and the `testSinusoid.m` is for evaluating the processing with the sinusoid. The user only needs to change the first section of the `fuzzModelling.m` to import the file and adjust parameters for the model. The audio will automatically play after running the code. To stop the player, type stop(player) in the command window.\
\
file: input the audio file name. The audio file has to be in the same folder with the code \
Gain: controls input signals amplitude\
FREQ: controls frequency output of the distortion\
SHAPE: controls distortion wave shape\
HIGH: controls the value of high frequency cutoff. Any frequency above will be cutoff\
MID: controls the value of mid frequency cutoff\
LOW: controls the value of low frequency cutoff. Any frequency below will be cutoff\
Volume: controls the output volume\
BYPASS: bypass the processing chain, play the original signal
