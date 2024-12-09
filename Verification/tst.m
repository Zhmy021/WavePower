clear;clc;close all;
%% 1. 读取网格坐标数据

% 读取位置数据
address_data = importdata('fort.txt');

% 读取经纬度坐标
lon = address_data(:, 2);
lat = address_data(:, 3);
depth = address_data(:, 4);

clear address_data addresstxtData txtData
%% 2. 读取SWAN计算数据

SWH = readmattodata("E:\张明阳\SWAN_Taiwan_result\Taiwan2022.mat",1,8760,10613);
PERIOD = readmattodata("E:\张明阳\SWAN_Taiwan_result\Taiwan2022.mat",5,8760,10613);


%% 4. 绘制等值线图

addpath('../m_map');  % m_map工具箱的文件夹路径

power = SWH .* SWH .* PERIOD * 0.5;

mean_Power = mean(power);


% 离散点的x、y和z数据
x = lon;
y = lat;
%z = (mean_Aquavalues./mean_Power)*100/5.7; % 单个时间点数据
z = mean_Power;
 
% 定义网格的x和y范围
x_range = linspace(min(x), max(x), 2000);
y_range = linspace(min(y), max(y), 2000);

% 创建网格坐标
[X, Y] = meshgrid(x_range, y_range);

Z = griddata(x, y, z, X, Y, 'natural');

m_proj('mercator', 'long',[116.5 122],'lat',[21.75 27.5]); 

% 绘制等高线图
%[C, h] = m_contourf(X, Y, Z);

hold on;

%clabel(C, h, 'FontSize', 8, 'Color', 'k', 'LabelSpacing', 150, 'Rotation', 0);

m_contourf(X, Y, Z);
m_grid('box','fancy','tickdir','in');
m_gshhs_h('color','k');

% m_ruler([.1 .6],.08,3,'fontsize',10);

% m_northarrow(117.2,27,.7,'type',3);

colormap(jet);
ax = m_contfbar(0.07, [0 1], [0 30], [0:1:30],'edgecolor','none','endpiece','no');

% ax=m_contfbar(0.07,[0 0.9],[0 50], [0:0.10:50],'edgecolor','none','endpiece','no');

xlabel(ax,'','color','k');


clear ans ax C h x y z X Y Z x_range y_range
