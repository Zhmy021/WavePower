
addpath('../m_map');  % m_map工具箱的文件夹路径


x = lon;
y = lat;
z = LOCE_min_KIND;
 
% 定义网格的x和y范围
x_range = linspace(min(x), max(x), 500);
y_range = linspace(min(y), max(y), 500);

% 创建网格坐标
[X, Y] = meshgrid(x_range, y_range);

Z = griddata(x, y, z, X, Y, 'nearest');

figure;
% 初始化M_Map
m_proj('mercator', 'long',[116.5 122],'lat',[21.75 27.5]); 

m_pcolor(X,Y,Z);
m_gshhs_h('patch',[1,1,1]);
m_grid('linestyle','none','tickdir','out','linewidth',3);

% levels = {'Pontoon', 'SeaPower', 'Langlee', 'COE_buoy', 'Aquayear', 'Wavebob', 'Pelamis','AWS'};
levels = { 'SeaPower', 'Langlee', 'COE_buoy', 'Aquayear', 'Wavebob'};
cmap = jet(length(levels));
colormap(cmap);
caxis([1 length(levels)]);

% 添加离散图例
cb = colorbar;
cb.Ticks = 1:length(levels);
cb.TickLabels = levels;

