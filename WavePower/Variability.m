clear;clc;close all;
addpath('CommonMethodology\');
addpath('Database\');
addpath('E:\张明阳\项目\SWAN_Taiwan_result')
%% 1. 读取网格坐标数据
[lon,lat,depth] = wp_readGird('fort2022.txt',10613);

%% 2. 读取SWAN计算数据
data_Hsig = wp_readMatCus("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2022.mat",1,8760,10613);
data_Tm01 = wp_readMatCus("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2022.mat",5,8760,10613);

%% 3. 计算SWAN数据

Moon = [743, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720, 743];
SWAN_power = 0.5 * (data_Hsig .* data_Hsig .* data_Tm01);

mean_Moon = zeros(12, 10613);
mean_Season = zeros(4, 10613);
mean_year = mean(SWAN_power(2:end,:), 1); 
% 在SWAN模型运行中第一行（也就是第一个时间点往往出现Nan值影响计算）

Begin = 2;
for i = 1:12
    toMon = SWAN_power(Begin:Begin+M(i),:);
    mean_Moon(i,:) = mean(toMon,1);
    Begin = Begin+M(i)
end
clear i Begin toMon Moon
mean_Season(1,:) = (mean_Moon(3,:) + mean_Moon(4,:) + mean_Moon(5,:))/3;
mean_Season(2,:) = (mean_Moon(6,:) + mean_Moon(7,:) + mean_Moon(8,:))/3;
mean_Season(3,:) = (mean_Moon(9,:) + mean_Moon(10,:) + mean_Moon(11,:))/3;
mean_Season(4,:) = (mean_Moon(1,:) + mean_Moon(2,:) + mean_Moon(12,:))/3;

MV = (max(mean_Moon,[],1)-min(mean_Moon,[],1))./mean_year;
SV = (max(mean_Season,[],1)-min(mean_Season,[],1))./mean_year;

% 对MV、SV归一化处理
MV = (MV - min(MV)) / (max(MV) - min(MV));
SV = (SV - min(SV)) / (max(SV) - min(SV));

% s = sum(SWAN_power(2:end,:),1)/1000;
% mean_values = mean(WECuse_data)/3000;
% tatol = sum(WECuse_data,1)/1000;

wp_makeMap(lon,lat,MV);



