function total = Deriv(networks,games,spread)

[m,n] = size(games);

for jj = 1:n
    deriv(:,jj)=fdDeriv(networks,games(:,jj),1e-7);
    normDeriv(:,jj)=abs(deriv(:,jj).*games(:,jj)./spread(jj));
    %display(jj)
end

total = sum(normDeriv,2);