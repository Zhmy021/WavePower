function [scores] = wp_entropy(data)
%  wp_entropy   该函数用于根据不同方案与指标进行熵值法计算.
%
%  WARNING: data输入数据必须以规定格式存储。
%
%  input:
%        data   - 输入数据矩阵，行为方案数，列为指标数
%  output:
%        scores - 返回不同方案对应的得分数
%
%  此处显示详细说明:
%       假设有 4 种方案，3 个指标
%       data = [100 80 90;      % 方案1
%               150 70 60;      % 方案2
%               150 70 60;      % 方案3
%               80  90 100];    % 方案4
    
    % 步骤 1：标准化决策矩阵
    [m, n] = size(data);
    normalized_data = zeros(m, n);
    
    for j = 1:n
        if j < 4  % 假设前两个是效益型指标
            % 对于效益型指标
            normalized_data(:, j) = data(:, j) ./ sum(data(:, j));
        else  % 假设第三个是成本型指标
            % 对于成本型指标
            normalized_data(:, j) = min(data(:, j)) ./ data(:, j);
        end
    end
    
    % 步骤 2：计算熵值
    H = zeros(1, n);
    k = 1 / log(m); % 归一化常数
    
    for j = 1:n
        p = normalized_data(:, j);
        H(j) = -k * sum(p .* log(p + eps)); % 加 eps 避免 log(0)
    end
    
    % 步骤 3：计算冗余度
    D = 1 - H;
    
    % 步骤 4：计算权重
    weights = D / sum(D);
    
    % 步骤 5：综合得分
    scores = normalized_data * weights';
    
    % 显示结果
    disp('每个方案的综合得分:');
    disp(scores);

end


