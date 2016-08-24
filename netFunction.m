function out=netFunction(networks,x)


outTemp={};
for ii=1:length(networks)
    outTemp{ii}=sim(networks{ii},x);
end
outTemp = cell2mat(outTemp);
out=mean(outTemp,2);

    