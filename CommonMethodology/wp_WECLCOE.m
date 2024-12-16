function [] = wp_WECLCOE(inputArg1,inputArg2)
    
% Overnight Capital Cost (OCC)，即"隔夜资本成本”，是能源项目评估中的一个重要概念。
% 它指的是在假设项目可以在一夜之间完成建设的情况下，项目的总建设成本。
% 换句话说，OCC是项目在建设期间的所有资本支出的总和，不考虑时间价值和融资成本。
% OCC通常包括以下几个部分：
%   直接成本：
%       设备和材料成本
%       劳动力成本
%       施工管理成本
%       土地购置成本
%   间接成本：
%       项目管理费用
%       许可和审批费用
%       保险费用
%       法律和咨询费用
%   其他成本：
%       不可预见费用
%       环境影响评估费用
%       社区和公共关系费用

% CRP（Capital Recovery Period，资本回收期）
% 资本回收期是指项目从开始投资到收回全部初始投资所需的时间。
% 它是评估项目投资回报速度的一个重要指标。
% 资本回收期越短，意味着投资者可以更快地收回投资，风险相对较低。
% CRP = 初始投资/年净现金流
% 净现金流 = 年净收入 - 运营成本 - 税费

% FCR Fixed Charge Rate, 固定费用率
% 通常用于评估项目的财务可行性和风险。
% 它表示在项目的整个生命周期内，每年需要支付的固定费用占总投资的比例。
% 固定费用通常包括利息、折旧、摊销和保险等。
% FCR = 年固定费用/初始投资
% 年固定费用 = 利息 + 折旧 + 摊销 +保险

% CAPEX （Capital Expenditure，资本支出）
% 指的是企业在固定资产（如设备、建筑物、基础设施等）上的投资。
% CAPEX通常用于购买、升级、维护或扩展企业的长期资产，以支持企业的长期运营和发展。
% CAPEX = ConFinFActor * (OCC * CapRegMult + GCC)

% LCOE = ((FCR * CAPEX + FOM)*1000/(CF * 8760)) + VOM + Fuel
% LCOE = ((CRF * ProFinFactor * ConFinFactor * (OCC * CapRegMult + GCC) + FOM) * 1000 / (CF * 8760)) + VOM + Fuel

%% 财务假设
CRP = 30; % 资本回收期（Capital Recovery Period）
CRF = 0.058; % 资本回收系数Capital Recovery Factor

M = 5; % 折旧期(Depreciation Period)
C = 3; % 施工工期(年)(Construction Duration)
EPDC = 0.02;% 施工期间的股本溢价(Equity Premium During Construction)

r = 0.05; % 折现率（低风险5%、高风险10%）



i = 0.025; % 通货澎率（Inflation Rate）0.0274 0.0256 0.025
IR = 0.041; % 假定债务利率0.07。
            % (ReEDS 中所有技术的利率为5.4%，名义利率为8%）
            % 计算得到海上风场的债务率0.041
IDC = 0.07; % 施工期间的利息(Interest During Construction)
RROE = 0.105; % 股权收益率Rate of Return on Equity Nominal
              % 股权融资资产份额的假定回报率。
              % (所有技术的回报率为 10%，名义回报率为 13%）

DF = 0.513; % 债务比例 Debt Fraction
TR = 0.257; % 税率Tax Rate (Federal and State)
WACC = 0.0491; % 加权平均资本成本Weighted Average Cost of Capital
               % 为资产融资所支付的平均预期利率
               % Nominal 0.0778
               % real 0.0491
%% 外部获取或计算得到
CFF = 1.109; % 建筑融资因素 Construction Finance Factor
FOM = ;% 固定运行和维护费用Fixed Operation and Maintenance Expenses ($/kW-yr)
CFC = ; % 建筑融资成本Construction Financing Cost ($/kW)
OCC = ;% 隔夜资本成本Overnight Capital Cost ($/kW)
GCC = OffSpurCost
% Grid Connection Costs (GCC) ($/kW) 并网成本
% OffshoreSpurLineCosts (OffSpurCost) ($/kW) 海上支线成本

% Variable Operation and Maintenance Expenses ($/MWh) = 0;


% Calculated Rate of Return on Equity Real 0.076
%%

CapEx = 1.5 * 0.75; % 资本支出
OpEx = CapEx * 0.1; % 运营支出
PV = 20;            % WEC服役年限

OpExs = 0;
AEP = WEC*8760;
AEPs = zeros(1, 10613);

for i = 1:1:PV
    OpExs = OpExs + OpEx/((1+r)^i);
    AEPs = AEPs + AEP./((1+r)^i);
end
LCOE = (1000000*(CapEx+OpExs))./AEPs*1000;
LCOE(LCOE>1000) = NaN;


% OpExs = 0;
% AEP = WEC*8760;
% AEPs = zeros(1, 10613);

end

