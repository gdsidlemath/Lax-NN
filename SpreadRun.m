

function [spreads, SpreadErrors, check, bestNetsSpread] = SpreadRun(n,games,testgames,gameind);
%clc
%load('NoNaNStats.mat')

%n = 10;

%games = RStats(:,1:350); testgames = RStats(:,351:450);
numNet = 100; numAvg = 10; node1 = 26;

SpreadError = zeros(1,n);

for i = 1:n;

[spreads, SpreadError(:,i), places, bestNetsSpread{i}] = ...
    ANNGameModelSpread(games,testgames,numNet,numAvg,node1);

end

mean(SpreadError,2)

%gameindex = 351:450;

m = length(gameind);

% predictionCombo = zeros(2,m,n);
% WinLossPredictCombo = zeros(2,m,n);
predictionspread = zeros(1,m,n);

spreads = [];

check = zeros(m,1);

for j = 1:n
    
    %[predictionCombo(:,:,j),WinLossPredictCombo(:,:,j),predictionspread(:,:,j),scores,WinLossStats,actualspread] =...
      %  GamePrediction(bestNetsCombo{j},gameindex,.5,.5);
    
    [predictionspread(:,:,j),actualspread] = SpreadPrediction(bestNetsSpread{j},testgames);
    
%     numGamesWrongCombo(j) = length(find(mean(abs(WinLossPredictCombo(:,:,j) - WinLossStats))));
    AvgspreaddiffCombo(j) = mean(abs(predictionspread(:,:,j) - actualspread));
    
    spreads = [spreads; predictionspread(:,:,j)];
    
    %check(find(predictionspread(:,:,j)) > 0) = check(find(predictionspread(:,:,j)) > 0) + 1;
    
end

%check(find(actualspread) > 0) = check(find(actualspread) > 0) + 1;

%length(find(check == n + 1))

spreads = [spreads; actualspread];

for p = 1:n+1
    check(find(spreads(p,:) <0)) = check(find(spreads(p,:) <0)) + 1;
end

meanpredictSpread = mean(predictionspread,3);
%predictCombospread = meanpredictCombo(1,:) - meanpredictCombo(2,:);

% for k = 1:m
%     homepredict1 = meanpredictCombo(1,k);
%     visitpredict1 = meanpredictCombo(2,k);
%     if homepredict1 > visitpredict1
%         meanWinLossCombo(1,k) = 1;
%     else
%         meanWinLossCombo(2,k) = 1;
%     end
%     
% end

%ComboModError = mean(numGamesWrongCombo);
AvgSpreadError = mean(AvgspreaddiffCombo);

%GamesWrong = (find(mean(abs(WinLossStats - meanWinLossCombo))));

%GameErrorCombo = length(find(mean(abs(WinLossStats - meanWinLossCombo))));
SpreadErrors = mean(abs(meanpredictSpread - actualspread));

%ComboModel = [ComboModError; ComboSpreadError; GameErrorCombo; SpreadErrors];

