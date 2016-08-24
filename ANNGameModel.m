
function [goalmodel, gamemodel, spreadmodel, ErrorGoals, ErrorGames, ErrorSpread, places, bestNetsGoals, bestNetsGames, bestNetsSpread] = ANNGameModel(games,testgames,numNet,numAvg,node1)

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
    
    AvgSpreadError(jj) = mean(abs(spreaderror));
    
    GameError(jj) = size(find(mean(abs(WinLossStats - WinLossMod(:,:,jj)))),2);
    
    PerGamesWrong(jj) = GameError(jj)/n;
    
    AvgError(jj) = mean(mean((abs(scores - modelgames{jj})),2));
    
end

for ee = 1:numAvg               %finding the best networks for CoM
    [val,place1] = min(AvgError);      %take minumum MSEs
    bestNetsGoals{ee} = netg{place1};  %save the best networks
    placeHold1(ee) = place1;
    AvgError(place1) = AvgError(place1) + 100;  %modify MSE so that it's not found again
end

for ee = 1:numAvg               %finding the best networks for CoM
    [val,place2] = min(PerGamesWrong);      %take minumum MSEs
    bestNetsGames{ee} = netg{place2};  %save the best networks
    placeHold2(ee) = place2;
    PerGamesWrong(place2) = PerGamesWrong(place2) + 100;  %modify MSE so that it's not found again
end  

for ee = 1:numAvg               %finding the best networks for CoM
    [val,place3] = min(AvgSpreadError);      %take minumum MSEs
    bestNetsSpread{ee} = netg{place3};  %save the best networks
    placeHold3(ee) = place3;
    PerGamesWrong(place3) = PerGamesWrong(place3) + 100;  %modify MSE so that it's not found again
end  

places = [placeHold1; placeHold2; placeHold3];

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
    modelgamegoals{jj}=sim(bestNetsGoals{jj},gametest);     %evaluate the networks
    modelgamegames{jj}=sim(bestNetsGames{jj},gametest);
    modelgamespread{jj}=sim(bestNetsSpread{jj},gametest);
end

for aa = 1:numAvg
    dubmodelgamegoals(:,:,aa) = modelgamegoals{aa};
    dubmodelgamegames(:,:,aa) = modelgamegames{aa};
    dubmodelgamespread(:,:,aa) = modelgamespread{aa};
end

goalmodel = mean(dubmodelgamegoals,3);
gamemodel = mean(dubmodelgamegames,3);
spreadmodel = mean(dubmodelgamespread,3);

for i = 1:y
    homescore = goalmodel(1,i);
    visitscore = goalmodel(2,i);
    if homescore > visitscore
        WinLossGoal(1,i) = 1;
    else
        WinLossGoal(2,i) = 1;
    end
end

goalmodelspread = goalmodel(1,:) - goalmodel(2,:);

for i = 1:y
    homescore = gamemodel(1,i);
    visitscore = gamemodel(2,i);
    if homescore > visitscore
        WinLossGame(1,i) = 1;
    else
        WinLossGame(2,i) = 1;
    end
end

gamemodelspread = gamemodel(1,:) - gamemodel(2,:);

for i = 1:y
    homescore = spreadmodel(1,i);
    visitscore = spreadmodel(2,i);
    if homescore > visitscore
        WinLossSpread(1,i) = 1;
    else
        WinLossSpread(2,i) = 1;
    end
end

spreadmodelspread = spreadmodel(1,:) - spreadmodel(2,:);

GameErrorGoal = size(find(mean(abs(WinLossTest - WinLossGoal))),2);
    
PerGamesWrongGoal = GameErrorGoal/y;

AvgErrorGoal = mean(mean((abs(scoretest - goalmodel)),2));

AvgSpreadErrorGoal = mean(abs(goalmodelspread - testspread));

ErrorGoals = [GameErrorGoal; PerGamesWrongGoal; AvgErrorGoal; AvgSpreadErrorGoal];

diff = abs(scoretest - goalmodel);
%figure; hist(diff(:));


GameErrorGame = size(find(mean(abs(WinLossTest - WinLossGame))),2);
    
PerGamesWrongGame = GameErrorGame/y;

AvgErrorGame = mean(mean((abs(scoretest - gamemodel)),2));

AvgSpreadErrorGame = mean(abs(gamemodelspread - testspread));

ErrorGames = [GameErrorGame; PerGamesWrongGame; AvgErrorGame; AvgSpreadErrorGame];

diff2 = abs(scoretest - gamemodel);

%figure; hist(diff2(:));


GameErrorSpread = size(find(mean(abs(WinLossTest - WinLossGame))),2);
    
PerGamesWrongSpread = GameErrorSpread/y;

AvgErrorSpread = mean(mean((abs(scoretest - spreadmodel)),2));

AvgSpreadErrorSpread = mean(abs(spreadmodelspread - testspread));

ErrorSpread = [GameErrorSpread; PerGamesWrongSpread; AvgErrorSpread; AvgSpreadErrorSpread];

diff3 = abs(scoretest - spreadmodel);

%figure; hist(diff3(:));