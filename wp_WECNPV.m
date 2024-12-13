function [NPV] = wp_WECNPV(WECpower)

NPV = zeros(1,10613);       % 净现值
PV = 20;                    % 服役年限 (选用20年、30年工作时长)
r = 0.05;                   % 折现率（低风险5%、高风险10%）
CapEx = (1.5 * 0.75) / PV;  % 资本支出
OpEx = CapEx * 0.1;         % 运营支出
AEP = WECpower * 8760;      % 总输出波浪能（1*10613，kw/m）
for i=1:20
    
end

end

