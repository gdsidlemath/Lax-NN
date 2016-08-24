
function [predictionspread,actualspread] = SpreadPrediction(networks,games);%,tw,ow);

load NoNaNStats

load TotalStats

%games is vector of game #'s

totalindex = RStats(27,:); 

gamenum = games(54,:);

Stats = games;%GoodStats(:,games);

actualspread = games(53,:);

nn = length(gamenum);

%prediction = zeros(2,nn);

for i = 1:nn
    
    temp = find(gameindex(:) == gamenum(i));
    
    temp1 = temp(1); temp2 = temp(2);
    
    x1 = temp1/22; x2 = temp2/22;
    
    team1 = ceil(x1); 
    game1 = uint8(22*(x1 - floor(x1)));
    
    team2 = ceil(x2); 
    game2 = uint8(22*(x2 - floor(x2)));
    
    if game1 == 1 || game2 == 1
        continue
    end
    
    team1vec = gameindex(1:(game1-1),team1);
    home1vec = homeindex(1:(game1-1),team1);
    team1vec(find(team1vec == -1)) = [];
    home1vec(find(home1vec == -1)) = [];
    
    team1stats = zeros(13,length(team1vec));
    team1opp = zeros(13,length(team1vec));
    
    for ii = 1:length(team1vec)
        game = find(totalindex == team1vec(ii));
        
        if home1vec(ii) == 1
            team1stats(:,ii) = RStats(1:13,game);
            team1opp(:,ii) = RStats(14:26,game);
        else
            team1stats(:,ii) = RStats(14:26,game);
            team1opp(:,ii) = RStats(1:13,game);
        end
    end
    
    team2vec = gameindex(1:(game2-1),team2);
    home2vec = homeindex(1:(game2-1),team2);
    team2vec(find(team2vec == -1)) = [];
    home2vec(find(home2vec == -1)) = [];
    
    team2stats = zeros(13,length(team2vec));
    team2opp = zeros(13,length(team2vec));
    
    for kk = 1:length(team2vec)
        game = find(totalindex == team2vec(kk));
        if home2vec(kk) == 1
            team2stats(:,kk) = RStats(1:13,game);
            team2opp(:,kk) = RStats(14:26,game);
        else
            team2stats(:,kk) = RStats(14:26,game);
            team2opp(:,kk) = RStats(1:13,game);
        end
    end
    
    team1avg = mean(team1stats,2);
    opp1avg = mean(team1opp,2);
    team2avg = mean(team2stats,2);
    opp2avg = mean(team2opp,2);
    
    input = zeros(52,1);
    
    check = homeindex(game1,team1); 
    
    if check == 1
        input(1:13) = team1avg;
        input(14:26) = opp1avg;
        input(27:39) = team2avg;
        input(40:52) = opp2avg;
    else
        input(1:13) = team2avg;
        input(14:26) = opp2avg;
        input(27:39) = team1avg;
        input(40:52) = opp1avg;
    end
    
    for m = 1:size(networks,2)
        model{m} = sim(networks{m},input);
        pretemp(m) = model{m};
    end
    
    predictionspread(:,i) = mean(pretemp);
    
%     homepredict = prediction(1,i);
%     visitpredict = prediction(2,i);
%     if homepredict > visitpredict
%         WinLossPredict(1,i) = 1;
%     else
%         WinLossPredict(2,i) = 1;
%     end
    
    %predictspread = homepredict - visitpredict;
    
end


        