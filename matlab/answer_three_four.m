clc;
close all;
clear all;

time=[0.096,0.268,1.767,2.235,2.706,3.146,3.606,4.056,4.52,5.03,5.748,5.978,7.015,7.709,7.923,8.028,8.49,8.959,9.454,9.852,10.125,10.356,10.565,10.822,11.292,11.741,12.284,12.741,13.269,13.758,14.315,14.939,15.432];

% 载入音频文件
[audio, fs] = audioread('fmt.wav');

audio_ranges = cell(1, length(time)-1);
for i = 1:1:length(time)-1
    start_idx = round(time(i) * fs) + 1;
    end_idx = round(time(i+1) * fs);
    audio_ranges{i} = audio(start_idx:end_idx);
end

result=zeros(length(audio_ranges), 6, 3);
% 遍历音频数据
for i = 1:length(audio_ranges)
    sound(audio_ranges{i});
    Search(audio_ranges{i},fs);
    pause(time(i+1)-time(i));
end

function Search(w,fs)
r=zeros(5, 3);
% FFT 长度 2^k>=N(采样点数量)
w=repmat(w,1000,1); %重复1000次
N=length(w);
len=2^nextpow2(N);
% 傅里叶变换
y=fft(w,len);
% FFT结果是对称的，取左半边结果，再除以采样点数量以计算幅值，得到每个频率分量的单边幅值
h=y(1:len/2)/N;
% 取模得到单边幅值的振幅大小，x2 得到双边幅值的振幅大小
h=abs(h)*2;
x=fs/2*linspace(0,1,len/2);
figure;
plot(x,h);
for i=2:length(h)-1
    if h(i)>0.025 && h(i)>h(i+1) && h(i)>h(i-1)
        r(1,1)=i; %数据索引
        r(1,2)=x(i); %频率
        r(1,3)=h(i); %幅值
        break;
    elseif h(i)>0.0148 && h(i)>h(i+1) && h(i)>h(i-1) && h(i)>r(1,3)
        r(1,1)=i; %数据索引
        r(1,2)=x(i); %频率
        r(1,3)=h(i); %幅值
    end
end
disp(' ');
disp(['基频,','频率：',num2str(r(1,2))]);
for z=2:5 % 寻找二次谐波到五次谐波
    for i=z*r(1,1)-floor(len/fs):z*r(1,1)+floor(len/fs) % 误差允许 1 HZ
        if h(i)>h(i+1) && h(i)>h(i-1) && h(i)>r(z,3)
            r(z,1)=i; %数据索引
            r(z,2)=x(i); %频率
            r(z,3)=h(i); %幅值
        end
    end
    r(z,3)=r(z,3)/r(1,3); %归一化幅值
    disp([num2str(z),'次谐波,','频率：',num2str(r(z,2)),',归一化幅值',num2str(r(z,3))]);
end
end
