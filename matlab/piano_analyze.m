clc;
clear all;
close all;

time=[1.099 3.004 4.452 6.326 9.454 10.941 12.578 14.055 16.494 17.924 20.092 20.901 24.441 25.025];

% 载入音频文件
[audio, fs] = audioread('voice.wav');

audio_ranges = cell(1, length(time)/2);
index=0;
for i = 1:2:length(time)-1
    start_idx = round(time(i) * fs) + 1;
    end_idx = round(time(i+1) * fs);
    index=index+1;
    audio_ranges{index} = audio(start_idx:end_idx);
end

result=zeros(length(audio_ranges), 6, 3);
% 遍历音频数据
basefs=32.7; %钢琴 琴键上C1是32.7Hz
for i = 1:length(audio_ranges)
    sound(audio_ranges{i});
    
    audio_data=audio_ranges{i};
    
    [upper_env, lower_env] = envelope(audio_data, 1000, 'peak');
    % 绘制包络曲线
    t = (0:length(audio_data)-1)/8000;
    figure;
    plot(t, audio_data, t, upper_env, t, lower_env);
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Audio Data', 'Upper Envelope', 'Lower Envelope');
    
    Search(audio_ranges{i},fs,basefs);
    basefs=basefs*2; %每提升一个八度，频率x2
    
    pause(time(i+1)-time(i));
end

function Search(w,fs,basefs)
r=zeros(11, 3);
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
    if h(i)>r(1,3) && ((basefs~=32.7 && x(i)>=basefs-20 && x(i)<=basefs+20) || (basefs==32.7 && x(i)>=basefs-0.5 && x(i)<=basefs+0.5)) %基频误差允许20Hz,C1特殊处理，只允许0.5Hz误差
        if x(i)>=8000
            %防止越界
            break;
        end
        r(1,1)=i; %数据索引
        r(1,2)=x(i); %频率
        r(1,3)=h(i); %幅值
    end
end
disp(' ');
disp(['基频,','频率：',num2str(r(1,2)),'幅值：',num2str(r(1,3))]);
ex=false;
ss=[];
for z=2:11 % 寻找二次谐波到11次谐波
    for i=z*r(1,1)-floor(basefs/2)*floor(len/fs):z*r(1,1)+floor(basefs/2)*floor(len/fs) % 误差允许 basefs 的一半
        if x(i)>=8000
            %防止越界
            ex=true;
            break;
        end
        if h(i)>h(i+1) && h(i)>h(i-1) && h(i)>r(z,3)
            r(z,1)=i; %数据索引
            r(z,2)=x(i); %频率
            r(z,3)=h(i); %幅值
        end
    end
    if ex==true
        break;
    end
    r(z,3)=r(z,3)/r(1,3); %归一化幅值
    disp([num2str(z),'次谐波,','频率：',num2str(r(z,2)),',归一化幅值',num2str(r(z,3))]);
    ss(z-1)=r(z,3);
end
disp(ss);
end
