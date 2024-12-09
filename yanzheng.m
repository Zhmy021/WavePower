clc; clear; close all;

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

%% 3. 读取观测数据
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
st6 = result_S6_2022(1:4359);
%% 4. 绘制等值线图

time = 10:4368;
scatter(time, ob, 'filled', 'MarkerFaceColor', 'red');
hold on;
plot(time, st6, 'b', 'LineWidth', 2);

legend('观测数据', 'result_W_E_S_T_H 2022', 'result_S_T_6 2022');


idx = ~isnan(st6) & ~isnan(ob);
st6 = st6(idx);
ob = ob(idx);

plot(ob,st6,'ko', 'MarkerFaceColor', 'black', 'MarkerSize', 5)
axis equal
xlim([0.2, 4])
ylim([0.2, 4])
xlabel('Hs(m) Obs')
ylabel('Hs(m) SWAN_S_T_6')

r = corr(st6, ob);
R2 = r^2;
[b, bint, r, rint, stats] = regress(ob, [ones(size(st6)), st6]);

hold on
plot(st6, b(1) + b(2)*st6, 'r-','LineWidth',2)

grid on

hold on
plot([0, 6], [0, 6], 'b-','LineWidth',2)
legend('Scatter Plot', 'Regression Line', 'y=x Line')

Bias = mean(st6 - ob);
RMSE = sqrt(mean((st6 - ob).^2));
SI = 1 - RMSE / std(ob);
mae = mean(st6 - ob);
R = corrcoef(st6, ob);

hold on
R_text = sprintf('R = %0.2f', R(1,2));
bias_text = sprintf('Bias = %0.2f', Bias);
RMSE_text = sprintf('RMSE = %0.2f', RMSE);
MAE_text = sprintf('MAE = %0.2f', mae);
Y_text = sprintf('y = %0.2f x + %0.2f', b(2),b(1));
SI_text = sprintf('SI = %0.2f', SI);

text(0.3, 3.95, R_text, 'FontSize', 16, 'FontWeight', 'bold')
text(0.3, 3.85, bias_text, 'FontSize', 16, 'FontWeight', 'bold')
text(0.3, 3.75, RMSE_text, 'FontSize', 16, 'FontWeight', 'bold')
text(0.3, 3.65, MAE_text, 'FontSize', 16, 'FontWeight', 'bold')
text(0.3, 3.55, Y_text, 'FontSize', 16, 'FontWeight', 'bold')
text(0.3, 3.45, SI_text, 'FontSize', 16, 'FontWeight', 'bold')
%%

x_grid = linspace(min(ob), max(ob), 100);
y_ob = normpdf(x_grid, mean(ob), std(ob)); % 计算正态分布 N(mean(x), std(x)^2) 的 PDF
y_com = normpdf(x_grid, mean(st6), std(st6)); % 计算正态分布 N(mean(x), std(x)^2) 的 PDF
plot(x_grid, y_ob, 'b-', 'LineWidth', 2);
hold on;
plot(x_grid, y_com, 'r-', 'LineWidth', 2);
legend('Measurements', 'ERA5 & SWAN')
grid on
xlabel('Hs(m)')
ylabel('ProbabilityDensity')
title('2021', 'FontWeight', 'bold');
