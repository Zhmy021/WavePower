function [SWAN_data] = wp_readMatCus(filename,kind,num,node)
%  wp_readMatCus   该函数用于从SWAN模型输出的mat文件中读取数据
%                  并构建数据矩阵.
%
%  WARNING: mat文件必须以规定格式存储，并由SWAN模型输出。
%
%  input:
%         filename      - mat文件存储位置
%         kind          - KIND中1为swh,2为tm01,3为dir,4为swell
%                         该部分以SWAN模型参数设置为准   
%         num           - 数据时序长度
%         node          - 数据element的个数
%  output:
%         SWAN_data     - 返回特定属性的数据矩阵
    SWAN_file = load(filename);
    field_names = fieldnames(SWAN_file);
    list = cell(numel(field_names), 1); 
    for i = 1:numel(field_names)
        list{i} = field_names{i};
    end

    SWAN = list(kind:7:end);
    
    % 初始化8760x27349的数据矩阵
    SWAN_data   = zeros(num, node);
    
    for i = 1:num
        Hsig_name   =   sprintf(SWAN{i});    
        SWAN_data(i, :)  =  SWAN_file.(Hsig_name);       
    end


