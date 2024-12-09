function [power_function] = getWEC(ExcelFilePath, WEC_Name)

    excel_file = xlsread(ExcelFilePath, WEC_Name);
    
    
    r = excel_file(1, 1);
    l = excel_file(1, 2);
    
    
    % 读取数据
    X_grid = excel_file(1, 3:3+r-1);
    Y_grid = excel_file(2:l+1, 2);
    Z = excel_file(2:l+1, 3:3+r-1);
    
    % 准备数据
    [X, Y] = meshgrid(X_grid, Y_grid);
    
    % 将数据转换为合适的格式
    X_data = X(:);
    Y_data = Y(:);
    power_data = Z(:);
    
    % 进行曲面拟合
    [fitobj, ~] = fit([X_data, Y_data], power_data, 'linearinterp');
    
    % 创建用于预测的函数
    power_function = @(x, y) fitobj(x, y);
   
end