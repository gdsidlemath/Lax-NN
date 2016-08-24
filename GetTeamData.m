load NoNanStats

gameindex = zeros(22,70);
homeindex = zeros(22,70);
TeamName = {};

for team = 1:70


    URL = strcat('http://tempofreelax.herokuapp.com/teams/',num2str(team),'/2014');
    [str,status] = urlread(URL);

    A = strread(str, '%s');

    for j = 1:5

    x(j) = size(A,1);
    for i = 1:x
        if strcmp(A{i},'<tr>') ==1
            A(i) = [];
        elseif strcmp(A{i},'</tr>') ==1
            A(i) = [];
        end

        temp = strfind(A{i},'<td>');

        if temp ~= 0
            A{i}(temp:temp+3) = [];
        end

        temp2 = strfind(A{i},'</td>');

        if temp2 ~= 0
            A{i}(temp2:temp2+4) = [];
        end

        x = size(A,1);
        if i == x
            break
        end
    end

    end

    kk = size(A,1);
    
    ind = 1;

    for j = 1:kk
        
        if strcmp(A{j},'<title>') ==1
            TeamName{team} = A{j+1};
        end

        temp2 = strfind(A{j},'href="/games/');

        if temp2 ~=0

            gameindex(ind,team) = str2double(A{j}(14:17));
            
            homecheck = strcmp(A{j-2},'Home');
            
            if homecheck ==1
                homeindex(ind,team) = 1;
            end

            ind = ind + 1;
        end
        
    end
    
    clear URL str A ind
    
end

gamenum = 1796:1:2328;
badindex = gamenum(badgames);

flagindex = [];
ind = 1;
for i = 1:70
for j = 1:22
num = gameindex(j,i);
flag = find(badindex == num);
if isempty(flag) ~= 1
flagindex(ind,:) = [i j];
ind = ind + 1;
end
end
end

for m = 1:size(flagindex,1);
gameindex(flagindex(m,2),flagindex(m,1)) = -1;
homeindex(flagindex(m,2),flagindex(m,1)) = -1;
end

save NoNanStats RStats Teams badgames WinLoss Winners Losers gameindex homeindex TeamName

