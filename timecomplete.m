function sequence_number = timecomplete(datetime_str)
    % 将输入的时间字符串转换为 datetime 对象
    datetime_obj = datetime(datetime_str);
    
    % 计算时间序号
    start_date = datetime(year(datetime_obj), 1, 1, 0, 0, 0);
    sequence_number = (datetime_obj - start_date) / hours(1) + 1;
    
    % 确保序号在 1 到 8760 之间
    sequence_number = max(1, min(8760, floor(sequence_number)));
end