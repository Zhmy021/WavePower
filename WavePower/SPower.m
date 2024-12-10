clear;clc;close all;
addpath('../CommonMethodology/');
addpath('E:\张明阳\项目\SWAN_Taiwan_result');
%% 1. 读取网格坐标数据
[lon,lat,depth] = wp_readGird('fort2022.txt',10613);

%% 2. 读取SWAN计算数据
SWAN_SWH = wp_readMatCus("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2015.mat",1,8760,10613);
SWAN_PERIOD = wp_readMatCus("E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2015.mat",5,8760,10613);

%% 3. 计算SWAN数据

EXCEL_FILE_PATH = "C:\Users\zmyzq\Desktop\WEC种类参数.xlsx";
WEC_LIST = {'Pontoon','SeaPower','Langlee','OE_buoy','AquaBuOY','Wavebob','Pelamis','AWS'};
block_size = 8760;


% for start_row = 1:block_size:87600
% 
%     fprintf('start from %d to %d\n',start_row,start_row+8759);
% 
%     SWH_block = h5read("database_h5\SWAN_data.h5", '/SWH', [start_row 1], [block_size 10613]);
%     PERIOD_block = h5read("database_h5\SWAN_data.h5", '/PERIOD', [start_row 1], [block_size 10613]);
%     
%     WP_block = 0.5 * (SWH_block .* SWH_block .* PERIOD_block);
%     WP_block(isnan(WP_block)) = 0;
%     h5write("database_h5\SWAN_data.h5", '/Power', WP_block, [start_row 1], [block_size 10613]);
%     
%    for index = 1:8
%         disp(['start  ',WEC_LIST{index}])
%         WECuse_block   = zeros(8760, 10613);
%         power_function = getWEC(EXCEL_FILE_PATH, WEC_LIST{index});
% 
%         for i = 1:8760
%             hs = SWH_block(i, :);
%             tm = PERIOD_block(i, :);
%             WECuse_block(i, :) = power_function(tm, hs);
%         end
%         
%         WECuse_block(isnan(WECuse_block)) = 0;
%         
%         strut = ['/WEC/', WEC_LIST{index}];
%     
%         h5write("database_h5\SWAN_data.h5", strut, WECuse_block, [start_row 1], [block_size 10613]);
%     end
%     
% end

%% 波浪能分布及WEC波浪能分布
meanWEC = zeros(8, 10,10613);
meanPower = zeros(10, 10613);
ind = 1;
for start_row = 1:8760:87600
    
    fprintf('start from %d to %d\n',start_row,start_row+8759);
    
    for index = 1:1:8
        disp(['start  ',WEC_LIST{index}])
        strut = ['/WEC/', WEC_LIST{index}];
        WEC_block = h5read("database_h5\SWAN_data.h5", strut, [start_row 1], [8760 10613]);
        meanWEC_block = mean(WEC_block);
        meanWEC(index,ind,:) = meanWEC_block;
    end

    Power_block = h5read("database_h5\SWAN_data.h5", '/Power', [start_row 1], [8760 10613]);

    meanPower_block = mean(Power_block);
    
    meanPower(ind,:) = meanPower_block;

    ind = ind + 1;

end
%% 
meanPower = zeros(10, 10613);
ind = 1;
for start_row = 1:8760:87600
    
    fprintf('start from %d to %d\n',start_row,start_row+8759);

    Power_block = h5read("database_h5\SWAN_data.h5", '/PERIOD', [start_row 1], [8760 10613]);

%     [rows, cols] = size(Power_block);

%     % 初始化一个 1 x cols 的数组来保存每一列大于 2 的频率
%     freq = zeros(1, cols);
%     
%     % 遍历每一列
%     for j = 1:cols
%         % 统计该列大于 2 的元素个数
%         count = sum(Power_block(:,j) > 5);
%         % 计算频率并存入 freq 数组
%         freq(j) = count / rows;
%     end
    
    meanPower_block = mean(Power_block);
    
    meanPower(ind,:) = meanPower_block;

    ind = ind + 1;

end
KK = mean(meanPower);
%%

% for start_row = 1:8760:87600
%     
%     ll = h5read("database_h5\SWAN_data.h5", '/WEC/Pelamis', [start_row 1], [8760 10613]);
% 
%     meanPower_block = mean(ll);
% 
%     meanPower(ind,:) = meanPower_block;
%     ind = ind + 1;
% end

listPontoon = mean(squeeze(meanWEC(1,:,:)),2)/80;
listSeaPower = mean(squeeze(meanWEC(2,:,:)),2)/16.75;
listLanglee = mean(squeeze(meanWEC(3,:,:)),2)/25;
listOE_buoy = mean(squeeze(meanWEC(4,:,:)),2)/24;
listAquayear = mean(squeeze(meanWEC(5,:,:)),2)/6;
listWavebob = mean(squeeze(meanWEC(6,:,:)),2)/20;
listPelamis = mean(squeeze(meanWEC(7,:,:)),2)/150;
listAWS = mean(squeeze(meanWEC(8,:,:)),2)/50;
listPower = mean(meanPower,2);

list = [listPontoon,listSeaPower,listLanglee,listOE_buoy,listAquayear,listWavebob,listPelamis,listAWS];


% M = [744, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720,744];

% mean_M = zeros(12, 10613);
% mean_S = zeros(4, 10613);



% BEG = 2;
% for i = 1:12
%     toMon = WECuse_data(BEG:BEG+M(i)-2,:);
%     mean_M(i,:) = mean(toMon,1);
%     BEG = BEG+M(i);
% end
% mean_S(1,:) = (mean_M(3,:) + mean_M(4,:) + mean_M(5,:))/3;
% mean_S(2,:) = (mean_M(6,:) + mean_M(7,:) + mean_M(8,:))/3;
% mean_S(3,:) = (mean_M(9,:) + mean_M(10,:) + mean_M(11,:))/3;
% mean_S(4,:) = (mean_M(1,:) + mean_M(2,:) + mean_M(12,:))/3;
clear EXCEL_FILE_PATH hs i tm WEC_LIST power_function

%% 4. 绘制等值线图

realwavepower = mean(meanPower,1);


% s = sum(SWAN_power(2:end,:),1)/1000;
% mean_WP = mean(WP)*6;

mean_Power = mean(meanPower);

WECPontoon = mean(squeeze(meanWEC(1,:,:)))/80;
WECSeaPower = mean(squeeze(meanWEC(2,:,:)))/16.75;
WECLanglee = mean(squeeze(meanWEC(3,:,:)))/25;
WECOE_buoy = mean(squeeze(meanWEC(4,:,:)))/24;
WECAquayear = mean(squeeze(meanWEC(5,:,:)))/6;
WECWavebob = mean(squeeze(meanWEC(6,:,:)))/20;
WECPelamis = mean(squeeze(meanWEC(7,:,:)))/150;
WECAWS = mean(squeeze(meanWEC(8,:,:)))/60;
zz_wec_kw_m_list = [WECPontoon,WECSeaPower,WECLanglee,WECOE_buoy,WECAquayear,WECWavebob,WECPelamis,WECAWS];


WECPontoon = mean(squeeze(meanWEC(1,:,:)));
WECSeaPower = mean(squeeze(meanWEC(2,:,:)));
WECLanglee = mean(squeeze(meanWEC(3,:,:)));
WECOE_buoy = mean(squeeze(meanWEC(4,:,:)));
WECAquayear = mean(squeeze(meanWEC(5,:,:)));
WECWavebob = mean(squeeze(meanWEC(6,:,:)));
WECPelamis = mean(squeeze(meanWEC(7,:,:)));
WECAWS = mean(squeeze(meanWEC(8,:,:)));
zz_wec_meanpower_list = [WECPontoon,WECSeaPower,WECLanglee,WECOE_buoy,WECAquayear,WECWavebob,WECPelamis,WECAWS];


% 
weclr_Pontoon = mean(squeeze(meanWEC(1,:,:)))/3619;
weclr_SeaPower = mean(squeeze(meanWEC(2,:,:)))/3587;
weclr_Langlee = mean(squeeze(meanWEC(3,:,:)))/1665;
weclr_OE_buoy = mean(squeeze(meanWEC(4,:,:)))/2880;
weclr_Aquayear = mean(squeeze(meanWEC(5,:,:)))/250;
weclr_Wavebob = mean(squeeze(meanWEC(6,:,:)))/1000;
weclr_Pelamis = mean(squeeze(meanWEC(7,:,:)))/750;
weclr_AWS = mean(squeeze(meanWEC(8,:,:)))/2470;
zz_wec_lr_list = [weclr_Pontoon,weclr_SeaPower,weclr_Langlee,weclr_OE_buoy,weclr_Aquayear,weclr_Wavebob,weclr_Pelamis,weclr_AWS];


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
WECPelamis = mean(squeeze(meanWEC(7,:,:)))/150*8760;
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

