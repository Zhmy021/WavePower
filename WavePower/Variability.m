clear;clc;close all;
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
SWAN_file = load("E:\张明阳\SWAN_Taiwan_result\te_ST6_S6_2021.mat");
field_names = fieldnames(SWAN_file);

list = cell(numel(field_names), 1);

for i = 1:numel(field_names)
    list{i} = field_names{i};
end

SWAN_Hsig   = list(1:7:end);
SWAN_Dir    = list(4:7:end);
SWAN_Tm01   = list(5:7:end);

% 初始化8760x27349的数据矩阵
Hsig_data   = zeros(8760, 10613);
Dir_data    = zeros(8760, 10613);
Tm01_data   = zeros(8760, 10613);

for i = 1:8760
    Hsig_name   =   sprintf(SWAN_Hsig{i});
    Dir_name    =   sprintf(SWAN_Dir{i});
    Tm01_name   =   sprintf(SWAN_Tm01{i});

    Hsig_data(i, :)  =  SWAN_file.(Hsig_name);
    Dir_data(i, :)   =  SWAN_file.(Dir_name);
    Tm01_data(i, :)  =  SWAN_file.(Tm01_name);
end
%% 清理工作区
clear Hsig_name Dir_name Tm01_name
clear SWAN_Hsig SWAN_Dir SWAN_Tm01
clear i list SWAN_file field_names address_data
%% 3. 计算SWAN数据

M = [744, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720,744];

mean_M = zeros(12, 10613);
mean_S = zeros(4, 10613);

SWAN_power = 0.5 * (Hsig_data .* Hsig_data .* Tm01_data);

mean_year = mean(SWAN_power(2:end,:), 1);

BEG = 2;
for i = 1:12
    toMon = SWAN_power(BEG:BEG+M(i)-2,:);
    mean_M(i,:) = mean(toMon,1);
    BEG = BEG+M(i);
end
mean_S(1,:) = (mean_M(3,:) + mean_M(4,:) + mean_M(5,:))/3;
mean_S(2,:) = (mean_M(6,:) + mean_M(7,:) + mean_M(8,:))/3;
mean_S(3,:) = (mean_M(9,:) + mean_M(10,:) + mean_M(11,:))/3;
mean_S(4,:) = (mean_M(1,:) + mean_M(2,:) + mean_M(12,:))/3;

MV = (max(mean_M,[],1)-min(mean_M,[],1))./mean_year;

SV = (max(mean_S,[],1)-min(mean_S,[],1))./mean_year;

% 假设矩阵存储在变量 matrix 中
MV = (MV - min(MV)) / (max(MV) - min(MV));
SV = (SV - min(SV)) / (max(SV) - min(SV));


%% 4. 绘制等值线图

addpath('../m_map');  % m_map工具箱的文件夹路径

% s = sum(SWAN_power(2:end,:),1)/1000;

%mean_values = mean(WECuse_data)/3000;

% tatol = sum(WECuse_data,1)/1000;


% 离散点的x、y和z数据
x = lon;
y = lat;
z = SV; % 单个时间点数据

% 定义网格的x和y范围
x_range = linspace(min(x), max(x), 2000);
y_range = linspace(min(y), max(y), 2000);

% 创建网格坐标
[X, Y] = meshgrid(x_range, y_range);

Z = griddata(x, y, z, X, Y, 'natural');

m_proj('mercator', 'long',[116.5 122],'lat',[21.75 27.5]); 

% 绘制等高线图
[C, h] = m_contourf(X, Y, Z);

hold on;

clabel(C, h, 'FontSize', 8, 'Color', 'k', 'LabelSpacing', 150, 'Rotation', 0);

m_grid('tickdir','out','yaxislocation','right',...
            'xaxislocation','top','xlabeldir','end','ticklen',.02);

m_gshhs_h('patch',[0.6 0.6 0.6]);

% m_ruler([.1 .6],.08,3,'fontsize',10);

% m_northarrow(117.2,27,.7,'type',3);

ax=m_contfbar(0.07,[0 0.9],[0 0.6], [0:0.02:0.6],'edgecolor','none','endpiece','no');

xlabel(ax,'','color','k');
