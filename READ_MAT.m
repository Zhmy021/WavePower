function result = READ_MAT(filename, pointadress,KIND)
% KIND中1为swh，2为swell，4为dir,5为tm01,5wei

    SWAN = load(filename);%'te2_ST6_S6_2022.mat'
    field_names = fieldnames(SWAN);
    
    % 存储属性字段名称
    list = cell(numel(field_names), 1);
    
    for i = 1:numel(field_names)
        list{i} = field_names{i};
    end
    
    list = list(KIND:7:end);
    
    % 初始化744x10613的数据矩阵
    SWAN_data = zeros(4368, 10613);
    
    for i = 1:4368
        field_name = sprintf(list{i});
        SWAN_data(i, :) = SWAN.(field_name);
    end

    s = SWAN_data(:,pointadress);

    result = s;
