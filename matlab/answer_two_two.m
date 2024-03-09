clc;

% 创建 MySound 类的实例
s=MySound();
%获取节拍时长
P=s.Get_P();

%待合成音乐
x=[];

%《东方红》第一小节
x=[x,envelope(s.SoundCreat_F('5', P * 1 / 4, 0))];
x=[x,envelope(s.SoundCreat_F('5', P * 1 / 4 / 2, 0))];
x=[x,envelope(s.SoundCreat_F('6', P * 1 / 4 / 2, 0))];
%-------------------------------------
x=[x,envelope(s.SoundCreat_F('2', P * 1 / 4 * 2, 0))];
%-------------------------------------
x=[x,envelope(s.SoundCreat_F('1', P * 1 / 4, 0))];
x=[x,envelope(s.SoundCreat_F('1', P * 1 / 4 / 2, 0))];
x=[x,envelope(s.SoundCreat_F('6', P * 1 / 4 / 2, -1))];
%-------------------------------------
x=[x,envelope(s.SoundCreat_F('2', P * 1 / 4 * 2, 0))];

% 播放合成的音乐
sound(x,8000);

% 绘制信号波形
plot(1:length(x), x);

%元素逐乘，实现包络
function result=envelope(sound)
result=sound .* exp(-(0:length(sound)-1)/(length(sound)/4));
end