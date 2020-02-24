function root = solvePeriod(tauc, d1)

ceilingRelaxationConstant = 0.8;
floorGrowthConstant = 2.0;
% Resolution parameters
countInX = 10;
countInY = 10;
% G = periodicify(@generalGreen, countInY, countInX);
dG = periodicify(@generalGreenDerivative, countInY, countInX, d1);


% Set upper bound
testCeiling = 1e4;
while dG(tauc, testCeiling) < 0
    testCeiling = testCeiling * ceilingRelaxationConstant;
end
% Set lower bound
testFloor = 1e-7;
while dG(tauc, testFloor) >= 0 && ...
    testFloor < testCeiling / ceilingRelaxationConstant
    testFloor = testFloor * floorGrowthConstant;
end

try
    root = fzero(@(t) dG(tauc, t),[testFloor testCeiling]);
catch
    disp([dG(tauc, testFloor) dG(tauc, testCeiling)]);
    error('X');
end