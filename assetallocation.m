function  assetallocation(Price,Names)
filename ='Portfolio.xlsx';
T = readtable(filename);
headings = T.Properties.VariableNames(1:end)';
CouponRate = xlsread(filename,'A:A');
Holdings = xlsread(filename,'B:B');
terms = xlsread(filename,'C:C');
Blotter = dataset({Names,'Names'},{Price, 'Price'}, {Holdings, 'Holdings'});
Money = sum(Blotter.Price .* Blotter.Holdings);
Blotter.InitPort = (1/Money)*(Blotter.Price .* Blotter.Holdings);
Blotter.CouponRate = CouponRate;
%disp(Blotter);
mean = [ 0.05; 0.1; 0.12; 0.18 ];
covariance =  [ 0.0064 0.00408 0.00192 0;
    0.00408 0.0289 0.0204 0.0119;
    0.00192 0.0204 0.0576 0.0336;
    0 0.0119 0.0336 0.1225 ];
 X = portsim(mean'/12, covariance/12,12)
[Y, T] = ret2tick(X, [], 1/12)         
plot(T, log(Y));
hold on;
title('\bfSimulated Asset Class Total Return Prices');
xlabel('Year');
ylabel('Log Total Return Price');
legend(Names,'Location','best');
potfolio = Portfolio('Name', 'Portfolio','AssetList', Names, 'InitPort', Blotter.InitPort,'RiskFreeRate',0.01/(5*365));
potfolio = setDefaultConstraints(potfolio);
potfolio = setGroups(potfolio, [ 0, 1, 1, 1,], [], 0.75);
potfolio = addGroups(potfolio, [ 0, 0, 0, 1,], [], 0.30);

potfolio = setAssetMoments(potfolio, mean/12, covariance/12);
potfolio = estimateAssetMoments(potfolio, Y, 'DataFormat', 'Prices');
potfolio.AssetMean = 12*potfolio.AssetMean;
potfolio.AssetCovar = 12*potfolio.AssetCovar;

%display(potfolio);
[lb, ub] = estimateBounds(potfolio);
[m, cov] = getAssetMoments(potfolio); 
plotFrontier(potfolio, 40);
hold on;
q = setCosts(potfolio,CouponRate,CouponRate);
%display(q);
[prsk0, pret0] = estimatePortMoments(potfolio, potfolio.InitPort);

preturn = estimatePortReturn(potfolio, potfolio.estimateFrontierLimits);
qret = estimatePortReturn(q, q.estimateFrontierLimits);

displayReturns(pret0, preturn, qret);

Level = 0.3;
qret = estimatePortReturn(q, q.estimateFrontierLimits);
qwgt = estimateFrontierByReturn(q, interp1([0, 1], qret, Level));
[qrsk, qret] = estimatePortMoments(q, qwgt);
displayReturnLevel(Level, qret, qrsk);
q = setTurnover(q, qrsk);
[qwgt, qbuy, qsell] = estimateFrontierByRisk(q, 0.15);
qbuy(abs(qbuy) < 1.0e-5) = 0;
qsell(abs(qsell) < 1.0e-5) = 0;  
Blotter.Port = qwgt;
Blotter.Buy = qbuy;
Blotter.Sell = qsell;
display(Blotter);
TC = Money * sum(Blotter.CouponRate .* (Blotter.Buy + Blotter.Sell));
Blotter.Holding = Money * (Blotter.Port ./ Blotter.Price);
Blotter.BuyShare = Money * (Blotter.Buy ./ Blotter.Price);
Blotter.SellShare = Money * (Blotter.Sell ./ Blotter.Price);
display(Blotter);
plotFrontier(q, 40);
hold on
scatter(estimatePortRisk(q, qwgt), estimatePortReturn(q, qwgt), 'filled', 'r');
h = legend('Initial Portfolio', 'Efficient Frontier', 'Final Portfolio', 'location', 'best');
set(h, 'Fontsize', 8);
hold off
end

