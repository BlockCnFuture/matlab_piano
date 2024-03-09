clc;

load 'Guitar.MAT';
[s, fs] = audioread('fmt.wav');
sound(s, fs);