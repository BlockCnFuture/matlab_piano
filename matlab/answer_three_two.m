clc;

load 'Guitar.MAT';
[s, fs] = audioread('fmt.wav');

figure;
subplot(211);
plot(1:length(realwave), realwave);
title('realwave');
subplot(212);
plot(1:length(wave2proc), wave2proc);
title('wave2proc');

%重采样，变成250个点
w=resample(realwave,250,243);
% 将信号重塑为一个10行25列的矩阵，每行代表一个周期内的点
w_matrix = reshape(w, 25, 10)';
% 周期平均操作，对矩阵的每一列求平均，得到一个周期
w_mean = mean(w_matrix);
% 将信号重复，变成10个周期
w=repmat(w_mean,1,10);
% 重采样，变成243个点
w=resample(w,243,250);
figure;
plot(1:length(wave2proc), wave2proc);
title('wave2proc');
hold on;
plot(1:length(w), w,'r');
title('my wave2proc');

