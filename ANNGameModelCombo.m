
function [combomodel, ErrorCombo, places, bestNetsCombo] = ANNGameModelCombo(games,testgames,numNet,numAvg,node1)

[m,n] = size(games);

WinLossStats = zeros(2,n);

gamestats = games;
gamestats(13,:) = [];
gamestats(25:26,:) = [];

scores = games;
scores(1:12,:) = [];
scores(2:13,:) = [];
scores(3,:) = [];

actualspread = scores(1,:) - scores(2,:);

for i = 1:n
    homescore = scores(1,i);
    visitscore = scores(2,i);
    if homescore > visitscore
        WinLossStats(1,i) = 1;
    else
        WinLossStats(2,i) = 1;
    end
end

WinLossMod = zeros(2,n,numNet);

for jj = 1:numNet
    net{jj}=feedforwardnet([node1],'trainlm'); %build however many networks specified
    netg{jj}=train(net{jj},gamestats,scores);      %train the networks on games
    modelgames{jj}=sim(netg{jj},gamestats);         %evaluate model on games
    
    tempscore = modelgames{jj};
    
    for i = 1:n
        homescore = tempscore(1,i);
        visitscore = tempscore(2,i);
        if homescore > visitscore
            WinLossMod(1,i,jj) = 1;
        else
            WinLossMod(2,i,jj) = 1;
        end
    end
    
    predictspread = homescore - visitscore;
    
    spreaderror = predictspread - actualspread;
    
    AvgSpreadError(jj) = mean(abs(spreaderror))/mean(abs(actualspread));
    
    GameError(jj) = size(find(mean(abs(WinLossStats - WinLossMod(:,:,jj)))),2);
    
    PerGamesWrong(jj) = GameError(jj)/n;
    
    AvgError(jj) = mean(mean((abs(scores - modelgames{jj})),2));
    
    AvgComboError(jj) = AvgSpreadError(jj) + AvgError(jj);
    
end

for ee = 1:numAvg               %finding the best networks for CoM
    [val,place1] = min(AvgComboError);      %take minumum MSEs
    bestNetsCombo{ee} = netg{place1};  %save the best networks
    placeHold1(ee) = place1;
    AvgComboError(place1) = AvgComboError(place1) + 100;  %modify MSE so that it's not found again
end

places = placeHold1;

gametest = testgames;
gametest(13,:) = [];
gametest(25:26,:) = [];

scoretest = testgames;
scoretest(1:12,:) = [];
scoretest(2:13,:) = [];
scoretest(3,:) = [];

[x,y] = size(gametest);

WinLossTest = zeros(2,y);

for i = 1:y
    homescore = scoretest(1,i);
    visitscore = scoretest(2,i);
    if homescore > visitscore
        WinLossTest(1,i) = 1;
    else
        WinLossTest(2,i) = 1;
    end
end

testspread = scoretest(1,:) - scoretest(2,:);

for jj = 1:numAvg
    modelgamecombo{jj}=sim(bestNetsCombo{jj},gametest);     %evaluate the networks
end

for aa = 1:numAvg
    dubmodelgamecombo(:,:,aa) = modelgamecombo{aa};
end

combomodel = mean(dubmodelgamecombo,3);

for i = 1:y
    homescore = combomodel(1,i);
    visitscore = combomodel(2,i);
    if homescore > visitscore
        WinLossCombo(1,i) = 1;
    else
        WinLossCombo(2,i) = 1;
    end
end

combomodelspread = combomodel(1,:) - combomodel(2,:);

GameErrorCombo = size(find(mean(abs(WinLossTest - WinLossCombo))),2);
    
PerGamesWrongCombo = GameErrorCombo/y;

AvgErrorCombo = mean(mean((abs(scoretest - combomodel)),2));

AvgSpreadErrorCombo = mean(abs(combomodelspread - testspread));

ErrorCombo = [GameErrorCombo; PerGamesWrongCombo; AvgErrorCombo; AvgSpreadErrorCombo];

diff = abs(scoretest - combomodel);
%figure; hist(diff(:));


