clc;

load 'Guitar.MAT';

% FFT 长度 2^k>=N(采样点数量)
fs=8000;
wave2proc=repmat(wave2proc,100,1); %重复一百次
N=length(wave2proc);
len=2^nextpow2(N);
% 傅里叶变换
y=fft(wave2proc,len);
% FFT结果是对称的，取左半边结果，再除以采样点数量以计算幅值，得到每个频率分量的单边幅值
h=y(1:len/2)/N;
% 取模得到单边幅值的振幅大小，x2 得到双边幅值的振幅大小
h=abs(h)*2;
x=fs/2*linspace(0,1,len/2);
plot(x,h);