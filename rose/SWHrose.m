clc,clear
%%  读取SWAN计算数据
% BSG 9358 DSN 2027
addpath('../CommonMethodology/');

SWH = wp_readMat("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2022.mat",2027,1);
DIR = wp_readMat("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2022.mat",2027,4);


m1D = [DIR(1:1416);DIR(8017:end)];
m2D = DIR(1417:3624);
m3D = DIR(3625:5832);
m4D = DIR(5833:8016);

m1S = [SWH(1:1416);SWH(8017:end)];
m2S = SWH(1417:3624);
m3S = SWH(3625:5832);
m4S = SWH(5833:8016);

% Winter Spring Summer Autumn
str = sprintf('SWAN-DSN\n2022 Autumn');
wind_rose(m4D, m4S,'n',16,'quad',4,'lablegend','WindSpeed(m/s)')
title(str, 'FontWeight', 'bold');

