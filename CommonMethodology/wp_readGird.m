function [lon,lat,depth] = wp_readGird(fortFilePath,pointNum)

% 读取网格坐标数据
address_data = importdata(fortFilePath);  %'fort2022.txt'
addresstxtData = address_data.data; 
txtData = addresstxtData(2:pointNum+1, :);  % 10614

% 读取经纬度坐标
lon = txtData(:, 2);
lat = txtData(:, 3);
depth = txtData(:, 4);
end

