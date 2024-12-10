function [] = wp_windRoseDraw(SwanFileFolderPath)
%读取SWAN计算数据
%"E:\张明阳\项目\SWAN_Taiwan_result\te_ST6_S6_2022.mat"
addpath('../CommonMethodology/');
files = dir(SwanFileFolderPath);
filePaths = {};

m1D = [];
m2D = [];
m3D = [];
m4D = [];
m1S = [];
m2S = [];
m3S = [];
m4S = [];
directionall = [];
windall = [];

for i = 1:length(files)
    % 检查是否是文件（排除 '.' 和 '..' 目录）
    if ~files(i).isdir
        % 构建完整的文件路径
        fullPath = fullfile(SwanFileFolderPath, files(i).name);
        % 存储到 cell 数组
        filePaths{end+1} = fullPath; % 或者使用 filePaths = [filePaths; {fullPath}];
    end
end

for year = 1:length(filePaths)
    % BSG 9358 DSN 2027
    windx = wp_readMat(filePaths{year},2027,2);
    windy = wp_readMat(filePaths{year},2027,3);

    wind = sqrt(windx.*windx+windy.*windy);
    direction = atan2d(windx, windy);

    windall = [windall;wind];
    directionall = [directionall;direction];
    
    m1D = [m1D;[direction(1:1416);direction(8017:end)]];
    m2D = [m2D;direction(1417:3624)];
    m3D = [m3D;direction(3625:5832)];
    m4D = [m4D;direction(5833:8016)];
    
    m1S = [m1S;[wind(1:1416);wind(8017:end)]];
    m2S = [m2S;wind(1417:3624)];
    m3S = [m3S;wind(3625:5832)];
    m4S = [m4S;wind(5833:8016)];
end

season = ["Winter","Spring","Summer","Autumn","FullYear"];
direc = {m1D,m2D,m3D,m4D,directionall};
spee = {m1S,m2S,m3S,m4S,windall};

for i = 1:5
    str = sprintf('SWAN-WIND\n%s',season(i));
    figure('Color', 'w');
    wind_rose(direc{i}, spee{i},'n',16,'quad',4,'lablegend','WindSpeed(m/s)')
    title(str, 'FontWeight', 'bold');
    %saveas(gcf, sprintf('wind_rose_%s.png', season(i)));
    %exportgraphics(gcf, sprintf('wind_rose_%s.eps', season(i)), 'ContentType', 'vector');
    %exportgraphics(gcf, sprintf('wind_rose_%s.pdf', season(i)), 'ContentType', 'vector');
    print(gcf, sprintf('wind_rose_%s.png', season(i)), '-dpng', '-r500'); % 500 DPI
    close(gcf);
end



