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
% BSG 9358 DSN 2027
% result_S6_2022 = READ_MAT("E:\张明阳\SWAN_Taiwan_result\te_ST6_S6_2022.mat",2027,1);
result_S6_2022 = READ_MAT("E:\张明阳\SWAN_Taiwan_result\te_ST6_S6_2022.mat",2027,4);
windx = READ_MAT("E:\张明阳\SWAN_Taiwan_result\te_ST6_S6_2022.mat",2027,2);
windy = READ_MAT("E:\张明阳\SWAN_Taiwan_result\te_ST6_S6_2022.mat",2027,3);

wind = sqrt(windx.*windx+windy.*windy);

m1D = [result_S6_2022(1:1416);result_S6_2022(8017:end)];
m2D = result_S6_2022(1417:3624);
m3D = result_S6_2022(3625:5832);
m4D = result_S6_2022(5833:8016);

m1S = [wind(1:1416);wind(8017:end)];
m2S = wind(1417:3624);
m3S = wind(3625:5832);
m4S = wind(5833:8016);

% Winter Spring Summer Autumn
str = sprintf('SWAN-DSN\n2022 Autumn');
wind_rose(m4D, m4S,'n',16,'quad',4,'lablegend','WindSpeed(m/s)')
title(str, 'FontWeight', 'bold');

