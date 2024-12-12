clear;clc;close all;
addpath('../CommonMethodology/');
addpath('E:\张明阳\项目\SWAN_Taiwan_result');
%% 1. 读取网格坐标数据
[lon,lat,depth] = wp_readGird('fort2022.txt',10613);

%% 2. 读取SWAN计算数据
SWAN_SWH = wp_readMatCus("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2015.mat",1,8760,10613);
SWAN_PERIOD = wp_readMatCus("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2015.mat",5,8760,10613);

%% 波浪能分布及WEC波浪能分布
[meanWEC, meanPower] = wp_WECmeanpower(h5filePath);
KK = mean(meanPower);

%% 单位长度下能源转换效率（kw/m）
WECPontoon = mean(squeeze(meanWEC(1,:,:)))/80;
WECSeaPower = mean(squeeze(meanWEC(2,:,:)))/16.75;
WECLanglee = mean(squeeze(meanWEC(3,:,:)))/25;
WECOE_buoy = mean(squeeze(meanWEC(4,:,:)))/24;
WECAquayear = mean(squeeze(meanWEC(5,:,:)))/6;
WECWavebob = mean(squeeze(meanWEC(6,:,:)))/20;
WECPelamis = mean(squeeze(meanWEC(7,:,:)))/150;
WECAWS = mean(squeeze(meanWEC(8,:,:)))/60;
zz_wec_kw_m_list = [WECPontoon,WECSeaPower,WECLanglee,WECOE_buoy,WECAquayear,WECWavebob,WECPelamis,WECAWS];
xx_wec_kw_m_list = [WECPontoon;WECSeaPower;WECLanglee;WECOE_buoy;WECAquayear;WECWavebob;WECPelamis;WECAWS];

h5create("MeanPower.h5","/WEC-ECEPUL-1d",size(zz_wec_kw_m_list));
h5write("MeanPower.h5","/WEC-ECEPUL-1d",zz_wec_kw_m_list);
h5create("MeanPower.h5","/WEC-ECEPUL-2d",size(xx_wec_kw_m_list));
h5write("MeanPower.h5","/WEC-ECEPUL-2d",xx_wec_kw_m_list);

% ECEPUL Energy conversion efficiency per unit length

%% WEC平均能量转换量
WECPontoon = mean(squeeze(meanWEC(1,:,:)));
WECSeaPower = mean(squeeze(meanWEC(2,:,:)));
WECLanglee = mean(squeeze(meanWEC(3,:,:)));
WECOE_buoy = mean(squeeze(meanWEC(4,:,:)));
WECAquayear = mean(squeeze(meanWEC(5,:,:)));
WECWavebob = mean(squeeze(meanWEC(6,:,:)));
WECPelamis = mean(squeeze(meanWEC(7,:,:)));
WECAWS = mean(squeeze(meanWEC(8,:,:)));
zz_wec_meanpower_list = [WECPontoon,WECSeaPower,WECLanglee,WECOE_buoy,WECAquayear,WECWavebob,WECPelamis,WECAWS];
xx_wec_meanpower_list = [WECPontoon;WECSeaPower;WECLanglee;WECOE_buoy;WECAquayear;WECWavebob;WECPelamis;WECAWS];

h5create("MeanPower.h5","/WEC-ECEMEAN-2d",size(xx_wec_meanpower_list));
h5write("MeanPower.h5","/WEC-ECEMEAN-2d",xx_wec_meanpower_list);
h5create("MeanPower.h5","/WEC-ECEMEAN-1d",size(zz_wec_meanpower_list));
h5write("MeanPower.h5","/WEC-ECEMEAN-1d",zz_wec_meanpower_list);

% ECEMEAN Energy conversion efficiency mean

%%  WEC容量系数
weclr_Pontoon = mean(squeeze(meanWEC(1,:,:)))/3619;
weclr_SeaPower = mean(squeeze(meanWEC(2,:,:)))/3587;
weclr_Langlee = mean(squeeze(meanWEC(3,:,:)))/1665;
weclr_OE_buoy = mean(squeeze(meanWEC(4,:,:)))/2880;
weclr_Aquayear = mean(squeeze(meanWEC(5,:,:)))/250;
weclr_Wavebob = mean(squeeze(meanWEC(6,:,:)))/1000;
weclr_Pelamis = mean(squeeze(meanWEC(7,:,:)))/750;
weclr_AWS = mean(squeeze(meanWEC(8,:,:)))/2470;
zz_wec_lr_list = [weclr_Pontoon,weclr_SeaPower,weclr_Langlee,weclr_OE_buoy,weclr_Aquayear,weclr_Wavebob,weclr_Pelamis,weclr_AWS];
xx_wec_lr_list = [weclr_Pontoon;weclr_SeaPower;weclr_Langlee;weclr_OE_buoy;weclr_Aquayear;weclr_Wavebob;weclr_Pelamis;weclr_AWS];

h5create("MeanPower.h5","/WEC-CapFac-2d",size(xx_wec_lr_list));
h5write("MeanPower.h5","/WEC-CapFac-2d",xx_wec_lr_list);
h5create("MeanPower.h5","/WEC-CapFac-1d",size(zz_wec_lr_list));
h5write("MeanPower.h5","/WEC-CapFac-1d",zz_wec_lr_list);

% CapFac capacity factor

%%
% %WEC = mean(squeeze(meanWEC(7,:,:)));
% r = 0.05;
% CapEx = 1.5 * 0.75;
% PV = 20;
% OpEx = CapEx * 0.1;
% OpExs = 0;
% AEP = WEC*8760;
% AEPs = zeros(1, 10613);
% 
% for i = 1:1:PV
%     OpExs = OpExs + OpEx/((1+r)^i);
%     AEPs = AEPs + AEP./((1+r)^i);
% end
% LCOE = (1000000*(CapEx+OpExs))./AEPs*1000;
% LCOE(LCOE>1000) = NaN;
%% 最小LCOE平准化度电成本
lowWECLCOE = zeros(8, 10613);
ma = [3.619,3.587,1.665,2.88,0.25,1,0.75,2.47];
for j = 1:1:8
    WEC = mean(squeeze(meanWEC(j,:,:)));
    r = 0.05;
    CapEx = 1.5 * ma(j);
    PV = 20;
    OpEx = CapEx * 0.1;
    OpExs = 0;
    AEP = WEC*8760;
    AEPs = zeros(1, 10613);
    
    for i = 1:1:PV
        OpExs = OpExs + OpEx/((1+r)^i);
        AEPs = AEPs + AEP./((1+r)^i);
    end
    LCOE = (1000000*(CapEx+OpExs))./AEPs*1000;
    lowWECLCOE(j,:) = LCOE;
end

LOCE_min_KIND = zeros(1, 10613);
for j = 1:10613
    [~, LOCE_min_KIND(j)] = min(lowWECLCOE(2:6, j));
end
clear i j LCOE AEP AEPs CapEx ma  OpEx OpExs PV r WEC
zz_wec_LCOE = [lowWECLCOE(1,:),lowWECLCOE(2,:),lowWECLCOE(3,:),lowWECLCOE(4,:),lowWECLCOE(5,:),lowWECLCOE(6,:),lowWECLCOE(7,:),lowWECLCOE(8,:)];

data = [zz_wec_kw_m_list;zz_wec_lr_list;zz_wec_meanpower_list;zz_wec_LCOE]';
data(isinf(data))=3000;



zzz_res = [res(1:10613)';res(10614:21226)';res(21227:31839)';res(31840:42452)';res(42453:53065)';res(53066:63678)';res(63679:74291)';res(74292:84904)'];
%% 最大单位长度能源提取

WECPontoon = mean(squeeze(meanWEC(1,:,:)))/80;
WECSeaPower = mean(squeeze(meanWEC(2,:,:)))/16.75;
WECLanglee = mean(squeeze(meanWEC(3,:,:)))/25;
WECOE_buoy = mean(squeeze(meanWEC(4,:,:)))/24;
WECAquayear = mean(squeeze(meanWEC(5,:,:)))/6;
WECWavebob = mean(squeeze(meanWEC(6,:,:)))/20;
WECPelamis = mean(squeeze(meanWEC(7,:,:)))/150;
WECAWS = mean(squeeze(meanWEC(8,:,:)))/60;

maxWECPower = [WECPontoon;WECSeaPower;WECLanglee;WECOE_buoy;WECAquayear;WECWavebob;WECPelamis;WECAWS];

WECPower_max_KIND = zeros(1, 10613);
for j = 1:10613
    [~, WECPower_max_KIND(j)] = max(maxWECPower(:, j));
end
clear  WECPontoon WECSeaPower WECLanglee WECOE_buoy WECAquayear WECWavebob WECPelamis WECAWS j
%%

addpath('../m_map');  % m_map工具箱的文件夹路径
% tatol = sum(WECuse_data,1)/1000;
% index = (depth < 50) & (depth > 100);
% mean_values(index) = 0;
% 离散点的x、y和z数据
res = [zz_wec_LCOE;zz_wec_meanpower_list;zz_wec_lr_list;zz_wec_kw_m_list]
zzz_res = [res(1:10613)';res(10614:21226)';res(21227:31839)';res(31840:42452)';res(42453:53065)';res(53066:63678)';res(63679:74291)';res(74292:84904)'];
[~, rowIndex] = max(zzz_res, [], 1);
x = lon;
y = lat;
z = rowIndex;
 
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
m_grid('linestyle','none','tickdir','out','linewidth',3);
m_gshhs_h('patch',[1,1,1]);

% m_ruler([.1 .6],.08,3,'fontsize',10);

% m_northarrow(117.2,27,.7,'type',3);

colormap(jet);
ax = m_contfbar(0.07, [0 1], [0 1], [1:1:8],'edgecolor','none','endpiece','no');

% ax=m_contfbar(0.07,[0 0.9],[0 50], [0:0.10:50],'edgecolor','none','endpiece','no');

xlabel(ax,'','color','k');

clear ans ax C h x y z X Y Z x_range y_range

S = struct('Geometry', 'Point', 'Lat', num2cell(lat), 'Lon', num2cell(lon),'mean_power', num2cell(mean_Power'),'LOCEminkind', ...
    num2cell(LOCE_min_KIND'),'lrLangee', num2cell(weclr_Langlee') ...
    ,'lrOE_buoy', num2cell(weclr_OE_buoy') ...
    ,'lrpelamis', num2cell(weclr_Pelamis') ...
    ,'lrpontoon', num2cell(weclr_Pontoon') ...
    ,'lrseapower', num2cell(weclr_SeaPower'));

% 指定Shapefile的文件名
shapefileName = 'points.shp';

% 将结构体数组写入Shapefile
shapewrite(S, shapefileName);

