clc; clear; close all;

%% 1. 读取SWAN计算数据
result_S6_2022 = READ_MAT("te2_ST6_S6_2022.mat",9358,1);

%% 2. 读取观测数据
folder_path = './中国台站观测数据2022/';
file_list = dir(fullfile(folder_path, '*.txt'));

ob = [];

for i = 1:length(file_list)
    % 读取当前文件的数据
    observation_data = importdata(fullfile(folder_path, file_list(i).name));
    ob_data = observation_data.data;
    
    % 对数据进行处理
    ob_col = ob_data(:,2); % 取第二列数据
    ob_col(ob_col > 50 | ob_col < 0.2) = NaN; % 将超出范围的值设为NaN
    
    % 将当前文件的数据拼接到ob矩阵
    ob = [ob; ob_col];
end

time = 10:4368;
ob = ob(10:4368);
ob = fillmissing(ob, 'linear');
st6 = result_S6_2022(1:4359);

fs = 1/1; % 采样频率 (Hz)，因为数据是每小时一个点，所以频率为1/1=1 Hz
n = length(ob); % 信号长度

X1 = fft(ob -mean(ob));
X2 = fft(st6 -mean(st6));

f = (0:n-1)*(fs/n); % 频率向量

figure;
subplot(2,1,1);
plot(f, abs(X1));
xlim([0 fs/2])
ylim([0 400])
title('观测数据');
xlabel('时间 (s)');
ylabel('幅值');

subplot(2,1,2);
plot(f, abs(X2));
xlim([0 fs/2])
ylim([0 400])
title('SWAN模拟数据');
xlabel('时间 (s)');
ylabel('幅值');

d = designfilt('lowpassfir', 'FilterOrder', 10, 'CutoffFrequency', 0.3);
h = designfilt('highpassfir', 'FilterOrder', 10, 'CutoffFrequency', 0.3);

Yd_ob = filter(d, ob -mean(ob));
Yh_ob = filter(h, ob -mean(ob));

Yd_swan = filter(d, st6 -mean(st6));
Yh_swan = filter(h, st6 -mean(st6));

%% 原始数据转换
figure;
subplot(3,2,1);
plot(time, ob);
title('观测数据原始信号');
xlabel('时间 (s)');
ylabel('幅值');

subplot(3,2,3);
plot(time, Yd_ob+mean(ob));
title('观测数据滤波低通信号');
xlabel('时间 (s)');
ylabel('幅值');

subplot(3,2,5);
plot(time, Yh_ob);
title('观测数据滤波高通信号');
xlabel('时间 (s)');
ylabel('幅值');


%% SWAN模拟数据

subplot(3,2,2);
plot(time, st6);
title('SWAN模拟原始信号');
xlabel('时间 (s)');
ylabel('幅值');

subplot(3,2,4);
plot(time, Yd_swan+mean(st6));
title('SWAN模拟滤波低通信号');
xlabel('时间 (s)');
ylabel('幅值');

subplot(3,2,6);
plot(time, Yh_swan);
title('SWAN模拟滤波高通信号');
xlabel('时间 (s)');
ylabel('幅值');












