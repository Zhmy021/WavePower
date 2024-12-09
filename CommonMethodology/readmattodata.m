function [SWAN_data] = readmattodata(filename,kind,num,node)
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


