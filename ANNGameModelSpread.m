
function [spreads, SpreadError, places, bestNets] = ANNGameModelSpread(games,testgames,numNet,numAvg,node1)

[m,n] = size(games);

gamestats = games;
gamestats(53:54,:) = [];

actualspread = games(53,:);

for jj = 1:numNet
    net{jj}=feedforwardnet([node1],'trainlm'); %build however many networks specified
    netg{jj}=train(net{jj},gamestats,actualspread);      %train the networks on games
    modelgames{jj}=sim(netg{jj},gamestats);         %evaluate model on games
    
    tempspread = modelgames{jj};
    
    spreaderror = tempspread - actualspread;
    
    AvgSpreadError(jj) = mean(abs(spreaderror))/mean(abs(actualspread));
    
    %GameError(jj) = size(find(mean(abs(WinLossStats - WinLossMod(:,:,jj)))),2);
    
    %PerGamesWrong(jj) = GameError(jj)/n;
    
end

for ee = 1:numAvg               %finding the best networks for CoM
    [val,place1] = min(AvgSpreadError);      %take minumum MSEs
    bestNets{ee} = netg{place1};  %save the best networks
    placeHold1(ee) = place1;
    AvgSpreadError(place1) = AvgSpreadError(place1) + 100;  %modify MSE so that it's not found again
end

places = placeHold1;

gametest = testgames;
gametest(53:54,:) = [];

[x,y] = size(gametest);

WinLossTest = zeros(2,y);

testspread = testgames(53,:);

for jj = 1:numAvg
    modelgamecombo{jj}=sim(bestNets{jj},gametest);     %evaluate the networks
end

for aa = 1:numAvg
    dubmodelgamecombo(aa,:) = modelgamecombo{aa};
end

modelspread = mean(dubmodelgamecombo,1);

SpreadError = mean(abs(modelspread))/mean(abs(actualspread));

spreads = [testspread; modelspread];
    

% GameErrorCombo = size(find(mean(abs(WinLossTest - WinLossCombo))),2);
%     
% PerGamesWrongCombo = GameErrorCombo/y;
% 
% AvgErrorCombo = mean(mean((abs(scoretest - model)),2));
% 
% AvgSpreadErrorCombo = mean(abs(combomodelspread - testspread));
% 
% ErrorCombo = [GameErrorCombo; PerGamesWrongCombo; AvgErrorCombo; AvgSpreadErrorCombo];

%diff = abs(scoretest - model);
%figure; hist(diff(:));


