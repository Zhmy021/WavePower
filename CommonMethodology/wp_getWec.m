function [power_function] = wp_getWec(ExcelFilePath, WEC_Name)
%  wp_getWec    该函数用于从Excel中读取Wec能量密度谱并构建二维线性插值函数
%               返回的函数用于动态计算物理环境下Wec实时功率输出，对于超出
%               密度谱范围的功率值设为Nan.
%
%  WARNING: Excel文件必须以规定格式存储。
%
%  input:
%        ExcelFilePath  - WEC密度谱储存位置
%        WEC_Name       - 使用WEC名称作为对象
%  output:
%       power_function  - 函数接受（x,y）两个参数分别代表swh与period，
%                         该函数用于返回

    % 读取EXCEL文件
    excel_file = xlsread(ExcelFilePath, WEC_Name);
    % 获取有效波高（swh）与波周期（peroid）离散程度
    r = excel_file(1, 1);
    l = excel_file(1, 2);
    % 读取效波高（m）与波周期（s）离散值与功率（kwh）数据
    X_grid = excel_file(1, 3:3+r-1);
    Y_grid = excel_file(2:l+1, 2);
    Z = excel_file(2:l+1, 3:3+r-1);
    
    % 准备数据网格
    [X, Y] = meshgrid(X_grid, Y_grid);
    X_data = X(:);
    Y_data = Y(:);
    power_data = Z(:);
    
    % 进行曲面拟合并创建用于预测的函数
    [fitobj, ~] = fit([X_data, Y_data], power_data, 'linearinterp');
    
    power_function = @(x, y) fitobj(x, y);
   
end