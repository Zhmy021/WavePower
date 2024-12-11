function [] = wp_makeMap(lon,lat,data,mind,maxd,intervals,filename)
addpath('../m_map');  % m_map工具箱的文件夹路径
% 离散点的x、y和z数据
x = lon; y = lat; z = data; % 单个时间点数据
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
clabel(C, h, 'FontSize', 8, 'Color', 'k', 'LabelSpacing', 50);
m_grid('tickdir','out', ...
       'yaxislocation','right',...
       'xaxislocation','top', ...
       'ylabeldir','end',...
       'xlabeldir','middle', ...
       'ticklen',.02, ...
       'fontsize',12);
m_gshhs_h('patch',[0.6 0.6 0.6]);

% m_ruler([.1 .6],.08,3,'fontsize',10);
m_northarrow(117.2,27,.7,'type',3);

ax=m_contfbar(0.07,[0 0.9],[mind maxd], [mind:intervals:maxd],'edgecolor','k');
% 相对左侧位置（0-1），色条相对下边位置（0-1）
xlabel(ax,'','color','k');
set(ax, 'FontSize', 12);
set(gcf, 'Position', [50, 50, 800, 600]); % gcf 获取当前图形句柄
print(gcf, sprintf('wind_rose_%s.png', filename), '-dpng', '-r500'); % 500 DPI
end

