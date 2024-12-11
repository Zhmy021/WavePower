function [] = wp_swhRoseDraw(SwanFileFolderPath)
%%  读取SWAN计算数据
% BSG 9358 DSN 2027
addpath('../CommonMethodology/');
%"E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2022.mat"
m1D = [];
m2D = [];
m3D = [];
m4D = [];
m1S = [];
m2S = [];
m3S = [];
m4S = [];
SWHall = [];
DIRall = [];

filePaths = wp_iterateFolder(SwanFileFolderPath);

for year = 1:length(filePaths)
    % BSG 9358 DSN 2027
    SWH = wp_readMat(filePaths{year},2027,1);
    DIR = wp_readMat(filePaths{year},2027,4);

    SWHall = [SWHall;SWH];
    DIRall = [DIRall;DIR];
    
    m1D = [m1D;[DIR(1:1416);DIR(8017:end)]];
    m2D = [m2D;DIR(1417:3624)];
    m3D = [m3D;DIR(3625:5832)];
    m4D = [m4D;DIR(5833:8016)];
    
    m1S = [m1S;[SWH(1:1416);SWH(8017:end)]];
    m2S = [m2S;SWH(1417:3624)];
    m3S = [m3S;SWH(3625:5832)];
    m4S = [m4S;SWH(5833:8016)];
end

season = ["Winter","Spring","Summer","Autumn","FullYear"];
direc = {m1D,m2D,m3D,m4D,DIRall};
swh = {m1S,m2S,m3S,m4S,SWHall};

for i = 1:5
    str = sprintf('SWAN-SWH\n%s',season(i));
    figure('Color', 'w');
    wind_rose(direc{i}, swh{i},'n',16,'quad',4,'lablegend','SWH(m)')
    title(str, 'FontWeight', 'bold');
    %saveas(gcf, sprintf('wind_rose_%s.png', season(i)));
    %exportgraphics(gcf, sprintf('wind_rose_%s.eps', season(i)), 'ContentType', 'vector');
    %exportgraphics(gcf, sprintf('wind_rose_%s.pdf', season(i)), 'ContentType', 'vector');
    print(gcf, sprintf('wind_rose_%s.png', season(i)), '-dpng', '-r500'); % 500 DPI
    close(gcf);
end

