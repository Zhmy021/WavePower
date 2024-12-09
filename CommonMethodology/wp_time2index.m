function sequence_number = wp_time2index(datetime_str)
%  wp_time2index    该函数用于将具体的时间格式（datetime）转化为序号
%
%  input:
%       datetime_str    - 具体的时间（datetime）格式数据
%  output:
%       sequence_number - 一年中特定小时所代表的序号（1-8760）

    % 将输入的时间字符串转换为 datetime 对象
    datetime_obj = datetime(datetime_str);
    
    % 计算时间序号
    start_date = datetime(year(datetime_obj), 1, 1, 0, 0, 0);
    sequence_number = (datetime_obj - start_date) / hours(1) + 1;
    
    % 确保序号在 1 到 8760 之间
    sequence_number = max(1, min(8760, floor(sequence_number)));
end