function result = wp_readMat(filename,pointadress,KIND)
%  wp_readMat   该函数用于从SWAN模型输出的mat文件中读取数据
%               并查找特定点的特定属性值的时间序列矩阵.
%
%  WARNING: mat文件必须以规定格式存储，并由SWAN模型输出。
%
%  input:
%         filename      - mat文件存储位置
%         pointadress   - 查找点的序号
%         KIND          - KIND中1为swh,2为windx,3为windy,4为dir
%                         5为tm01,6为Velx，7为Vely
%                         该部分以SWAN模型参数设置为准               
%  output:
%         result        - 返回特定点的特定属性值的时间序列矩阵


    SWAN = load(filename);  %'te2_ST6_S6_2022.mat'
    field_names = fieldnames(SWAN);
    
    % 存储属性字段名称
    list = cell(numel(field_names), 1);
    
    for i = 1:numel(field_names)
        list{i} = field_names{i};
    end
    
    list = list(KIND:7:end);
    
    % 初始化8760x10613的数据矩阵
    SWAN_data = zeros(8760, 10613);
    
    for i = 1:8760
        field_name = sprintf(list{i});
        SWAN_data(i, :) = SWAN.(field_name);
    end

    s = SWAN_data(:,pointadress);

    result = s;
