Stats = zeros(24,533);

errorgames = zeros(1,533);

Teams = {};

for i = 1:533
    
    gamenum = 1795 + i;

    URL = strcat('http://tempofreelax.herokuapp.com/games/',num2str(gamenum));
    [str,status] = urlread(URL);
    
    if status == 0
        errorgames(i) = 1;
        i = i+1;
    else

    A = strread(str, '%s', 'delimiter', '<\td><td');
    A2 = A(~cellfun('isempty',A));

    htemp = strfind(A2,'Home');
    hind = find(~cellfun(@isempty,htemp));
    home = A2(hind);

    atemp = strfind(A2,'Away');
    aind = find(~cellfun(@isempty,atemp));
    away = A2(aind);

    gind = find(strcmp(A2,'Goals'));

    hgoal = str2double(A2(gind + 4));
    agoal = str2double(A2(gind + 6));

    effind = find(strcmp(A2,'Off Eff'));

    heff = .01*str2double(A2(effind + 4));
    aeff = .01*str2double(A2(effind + 6));

    faceind = find(strcmp(A2,'Faceoff %'));

    hface = .01*str2double(A2(faceind + 4));
    aface = .01*str2double(A2(faceind + 6));

    clearind = find(strcmp(A2,'Clearing %'));

    hclear = .01*str2double(A2(clearind + 4));
    aclear = .01*str2double(A2(clearind + 6));

    possind = find(strcmp(A2,'Poss %'));

    hposs = .01*str2double(A2(possind + 4));
    aposs = .01*str2double(A2(possind + 6));

    shotsind = find(strcmp(A2,'Sho'));

    hshots = str2double(A2(shotsind + 5));
    ashots = str2double(A2(shotsind + 7));

    shperind = find(strcmp(A2,'Shoo'));

    hshper = .01*str2double(A2(shperind(2) + 5));
    ashper = .01*str2double(A2(shperind(2) + 7));

    eshind = find(strcmp(A2,'eShoo'));

    heshot = .01*str2double(A2(eshind + 5));
    aeshot = .01*str2double(A2(eshind + 7));

    asind = find(strcmp(A2,'Assis'));

    hassist = str2double(A2(asind + 5));
    aassist = str2double(A2(asind + 7));

    turnind = find(strcmp(A2,'Turnovers/Pos'));

    hturn = str2double(A2(turnind + 4));
    aturn = str2double(A2(turnind + 6));

    EMOind = find(strcmp(A2,'EMO %'));

    hEMO = .01*str2double(A2(EMOind(1) + 4));
    aEMO = .01*str2double(A2(EMOind(2) + 6));

    EMORind = find(strcmp(A2,'EMO Reliance %'));

    hEMOR = .01*str2double(A2(EMORind(1) + 4));
    aEMOR = .01*str2double(A2(EMORind(2) + 6));

    Stats(:,i) = [hposs; heff; hface; hclear; hshots; hshper; heshot; hassist; hturn; hEMO; hEMOR; hgoal;...
         aposs; aeff; aface; aclear; ashots; ashper; aeshot; aassist; aturn; aEMO; aEMOR; agoal];

    Teams{i} = {home; away; gamenum};

    clear hposs heff hface hclear hshots hshper heshot hassist hturn hEMO hEMOR hgoal...
         aposs aeff aface aclear ashots ashper aeshot aassist aturn aEMO aEMOR agoal
     
    end
     
end
