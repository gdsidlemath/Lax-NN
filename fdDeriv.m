function fd=fdDeriv(networks,x,h)

fd=zeros(length(x),1);
for ii=1:length(x)
    v=zeros(size(x));
    v(ii)=h;
    %fplus = f(x+v);
    %fminus = f(x-v);
    fplus=netFunction(networks,x+v);
    fminus=netFunction(networks,x-v);
    fd(ii)=(fplus-fminus)./(2*h);
end