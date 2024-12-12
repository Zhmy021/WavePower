clear;clc;close all;
addpath('CommonMethodology\');
addpath('Database\');
addpath('E:\张明阳\项目\SWAN_Taiwan_result')

%% 读取网格数据
[lon,lat,depth] = wp_readGird('fort2022.txt',10613);

%% 绘制并保存变异性（月变异性、季变异性）相关图像
% 读取h5数据，其中"/MV" "/SV" 为1*10613大小，代表10年变异性统计
% "/MVall" "/SVall" 为10*10613，代表10年每年变异性
MV = h5read("Variability.h5","/MV");
wp_makeMap(lon,lat,MV,0,0.4,0.05,"MV");

%% 波浪能源详细数据
%   "/PERIOD" "/SWH" "/Power" 其大小都为87600x10613，
%      周期  有效波高 波浪能密度，代表10年逐小时数据
%   "/TIME" 大小都为87600x1，代表10年间时间序列
%   "/WEC/"Group组下是结合了WEC功率密度谱计算得到的不同WEC逐小时可获得的能量
%   例如 "/WEC/AWS"是AWS在研究区内不同地点不同时间获取的能量大小
%   "/WEC/AWS" 大小为87600*10613，是10年逐小时的。
Period = h5read("SWAN_data.h5","/PERIOD");

%% 波浪能分布及WEC波浪能分布
[meanWEC, meanPower] = wp_WECmeanpower(h5filePath);
KK = mean(meanPower);