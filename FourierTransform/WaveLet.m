
%% 1. 读取网格坐标数据

% 读取位置数据
address_data = importdata('fort2022.txt');
addresstxtData = address_data.data; 
txtData = addresstxtData(2:10614, :);

% 读取经纬度坐标
lon = txtData(:, 2);
lat = txtData(:, 3);
depth = txtData(:, 4);

%% 2. 读取SWAN计算数据
result_S6_2022 = READ_MAT("te2_ST6_S6_2022.mat",9358,1);
x = result_S6_2022;
% 选择小波基
wavelet = 'haar'; % 使用 Daubechies 1 小波(haar, db1, sym2)
% 进行小波分解
level = 5; % 分解层数
[C, L] = wavedec(x, level, wavelet);
A5 = appcoef(C, L, wavelet, 5); % 第5层逼近系数
D5 = detcoef(C, L, 5); % 第5层细节系数

figure;
t = 1:4368;
subplot(4,1,1);
plot(t, x);
title('原始信号');
xlabel('时间 (s)');
ylabel('幅值');

subplot(4,1,2);
plot(A5);
title('第5层逼近系数');
xlabel('样本');
ylabel('幅值');

subplot(4,1,3);
plot(D5);
title('第5层细节系数');
xlabel('样本');
ylabel('幅值');

% 重构信号
x_reconstructed = waverec(C, L, wavelet);

subplot(4,1,4);
plot(t, x_reconstructed);
title('重构信号');
xlabel('时间 (s)');
ylabel('幅值');

fs = 1000; % 采样频率
f = fs*(0:(length(x)/2))/length(x);
X = abs(fft(x));
X = X(1:length(f)); % 保留前半部分

% 获取各层细节系数频谱
D = cell(level,1);
for k = 1:level
    D{k} = abs(fft(detcoef(C, L, k)));
end

% 绘制结果
figure;

% 原始信号频谱
subplot(level+1, 1, 1);
plot(f, X);
title('原始信号频谱');
xlabel('频率 (Hz)');
ylabel('|X(f)|');

% 各层细节系数频谱
for k = 1:level
    subplot(level+1, 1, k+1);
    plot(f(1:2^(k-1):2184), D{k});
    title(['第 ' num2str(k) ' 层细节系数频谱']);
    xlabel('频率 (Hz)');
    ylabel(['|D' num2str(k) '(f)|']);
end




