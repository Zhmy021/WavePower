function [filePaths] = wp_iterateFolder(SwanFileFolderPath)
% 遍历文件夹并返回所有文件路径
files = dir(SwanFileFolderPath);
filePaths = {};
for i = 1:length(files)
    % 检查是否是文件（排除 '.' 和 '..' 目录）
    if ~files(i).isdir
        % 构建完整的文件路径
        fullPath = fullfile(SwanFileFolderPath, files(i).name);
        % 存储到 cell 数组
        filePaths{end+1} = fullPath; % 或者使用 filePaths = [filePaths; {fullPath}];
    end
end
end

