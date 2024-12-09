clc; clear; close all;

%% 1. 读取观测数据
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

ob = ob(10:4368);

time = 10:4368;

ob = fillmissing(ob, 'linear');

fs = 1/1; % 采样频率 (Hz)，因为数据是每小时一个点，所以频率为1/1=1 Hz
n = length(ob); % 信号长度

X = fft(ob -mean(ob));

f = (0:n-1)*(fs/n); % 频率向量

% 绘制频域图
figure;
plot(f, abs(X)); % 绘制幅度谱
xlim([0 fs/2]); % 将 x 轴限制在 Nyquist 区间
xlabel('Frequency (Hz)'); % x 轴标签
ylabel('Magnitude'); % y 轴标签
title('Frequency Domain Representation of Wave Energy'); % 图形标题
grid on; % 显示网格

xlim([0 fs/2]);

d = designfilt('lowpassfir', 'FilterOrder', 10, 'CutoffFrequency', 0.4);
h = designfilt('highpassfir', 'FilterOrder', 10, 'CutoffFrequency', 0.4);
y1 = filter(d, ob -mean(ob));
y2 = filter(h, ob -mean(ob));

figure;
subplot(3,1,1);
plot(time, ob);
title('原始信号');
xlabel('时间 (s)');
ylabel('幅值');

subplot(3,1,2);
plot(time, y1+mean(ob));
title('滤波后的信号');
xlabel('时间 (s)');
ylabel('幅值');

subplot(3,1,3);
plot(time, y2);
title('滤波后的信号');
xlabel('时间 (s)');
ylabel('幅值');


