

function [ComboModel, GamesWrong, predictCombospread] = TestRun(n,games,testgames);
%clc
%load('NoNaNStats.mat')

%n = 10;

%games = RStats(:,1:350); testgames = RStats(:,351:450);
numNet = 100; numAvg = 10; node1 = 13;

ErrorCombo = zeros(4,n);

for i = 1:n;

[combomodel, ErrorCombo(:,i), places, bestNetsCombo{i}] = ...
    ANNGameModelCombo(games,testgames,numNet,numAvg,node1);

end

mean(ErrorCombo,2)

gameindex = 351:450;

m = length(gameindex);

predictionCombo = zeros(2,m,n);
WinLossPredictCombo = zeros(2,m,n);
predictspreadCombo = zeros(1,m,n);

for j = 1:n
    
    [predictionCombo(:,:,j),WinLossPredictCombo(:,:,j),predictspreadCombo(:,:,j),scores,WinLossStats,actualspread] =...
        GamePrediction(bestNetsCombo{j},gameindex,.5,.5);
    
    numGamesWrongCombo(j) = length(find(mean(abs(WinLossPredictCombo(:,:,j) - WinLossStats))));
    AvgspreaddiffCombo(j) = mean(abs(predictspreadCombo(:,:,j) - actualspread));
    
end

meanpredictCombo = mean(predictionCombo,3);
predictCombospread = meanpredictCombo(1,:) - meanpredictCombo(2,:);

for k = 1:m
    homepredict1 = meanpredictCombo(1,k);
    visitpredict1 = meanpredictCombo(2,k);
    if homepredict1 > visitpredict1
        meanWinLossCombo(1,k) = 1;
    else
        meanWinLossCombo(2,k) = 1;
    end
    
end

ComboModError = mean(numGamesWrongCombo);
ComboSpreadError = mean(AvgspreaddiffCombo);

GamesWrong = (find(mean(abs(WinLossStats - meanWinLossCombo))));

GameErrorCombo = length(find(mean(abs(WinLossStats - meanWinLossCombo))));
SpreadErrorCombo = mean(abs(predictCombospread - actualspread));

ComboModel = [ComboModError; ComboSpreadError; GameErrorCombo; SpreadErrorCombo];

