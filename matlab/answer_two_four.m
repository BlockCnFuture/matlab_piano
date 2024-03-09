clc;

% 创建 MySound 类的实例
s=MySound();
%获取节拍时长
P=s.Get_P();

%待合成音乐
x=[];

%《东方红》第一小节
x=[x,Harmonics(s, '5', P * 1 / 4, 0)];
x=[x,Harmonics(s, '5', P * 1 / 4 / 2, 0)];
x=[x,Harmonics(s, '6', P * 1 / 4 / 2, 0)];
%-------------------------------------
x=[x,Harmonics(s, '2', P * 1 / 4 * 2, 0)];
%-------------------------------------
x=[x,Harmonics(s, '1', P * 1 / 4, 0)];
x=[x,Harmonics(s, '1', P * 1 / 4 / 2, 0)];
x=[x,Harmonics(s, '6',P * 1 / 4 / 2, -1)];
%-------------------------------------
x=[x,Harmonics(s, '2', P * 1 / 4 * 2, 0)];

% 播放合成后的音乐信号
sound(x,8000);
figure;
plot(1:length(x), x);

%元素逐乘，实现包络
function result = envelope(sound)
% 计算包络时间点
t = (0:length(sound)-1)/(length(sound)-1);
% 计算包络函数
envelope = zeros(size(sound));
envelope(t < 1/4.5) = 1.5 / (1/4.5) * t(t < 1/4.5);
envelope(t >= 1/4.5 & t < 1.5/4.5) = 1.5 - (0.5/(1.5/4.5-1/4.5)) * (t(t >= 1/4.5 & t < 1.5/4.5) - 1/4.5);
envelope(t >= 1.5/4.5 & t < 3/4.5) = 1;
envelope(t >= 3/4.5 & t <= 1) = 1 - (1/(1-3/4.5)) * (t(t >= 3/4.5 & t <= 1) - 3/4.5);
% 对信号幅度进行包络调整
result = envelope .* sound;
end

%包络并增加谐波分量
function result=Harmonics(s, key,duration,ex)
x = [];
x = 1 * envelope(s.SoundCreat_F(key, duration, ex + 0)); %基波
x= x + 0.2 * envelope(s.SoundCreat_F(key, duration, ex + 1)); %二次谐波
x = x + 0.3 * envelope(s.SoundCreat_F(key, duration, ex + log2(3))); %三次谐波
result = x;
end