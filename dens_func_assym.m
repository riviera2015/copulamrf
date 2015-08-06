function c = dens_func_assym(u, v, A, B, T, C1, C2);

% This returnsdensity function for assymetric copula c(u,v; phi). 
% phi = {A,B,T}

A1=1-A;
B1=1-B;

if C1=='Independent'
    P1=A*B*(u^(A-1))*(v^(B-1));
elseif C1=='Clayton'
    P1=(A*B*(u^(A-1))*(v^(B-1)))*(((T+1)*((u^A)^(-T-1))*((v^B)^(-T-1)))/((-1+((u^A)^(-T))+((v^B)^(-T)))^(2+(1/T))));
elseif C1=='Frank'
    a=(exp(-T)-1)+(exp(-T*(u^A))-1)*(exp(-T*(v^B))-1);
    P1=(A*B*(u^(A-1))*(v^(B-1)))*(T*exp(-T*(u^A+v^B))*(1-exp(-T))/(a^2));
end



if C2=='Independent'
    P2=(u^A1)*(v^B1);
elseif C2=='Clayton'
    P2=(u^(-A1*T)+v^(-B1*T)-1)^(-1/T);
elseif C2=='Frank'
    P2=(-1/T)*(1+(exp(-T*(u^A1))-1)*(exp(-T*(v^B1))-1)/(exp(-T)-1)); 
end


if C1=='Independent'
    P3=B*(u^(A))*(v^(B-1));
elseif C1=='Clayton'
    P3=(B*v^(B-1))*(((v^B)^(-T-1))/(-1+u^(-A*T)+v^(-B*T))^((T+1)/T));
elseif C1=='Frank'
    a=(exp(-T)-1)+(exp(-T*(u^A))-1)*(exp(-T*(v^B))-1);
    P3=(B*v^(B-1))*((exp(-T*(u^A))-1)*exp(-T*(v^B))/a);
end


    
if C2=='Independent'
    P4=A1*(u^(A1-1))*(v^(B1));
elseif C2=='Clayton'
    P4=(A1*u^(A1-1))*(((u^A1)^(-T-1))/(-1+u^(-A1*T)+v^(-B1*T))^((T+1)/T));
elseif C2=='Frank'
    a=(exp(-T)-1)+(exp(-T*(u^A1))-1)*(exp(-T*(v^B1))-1);
    P4=(A1*u^(A1-1))*((exp(-T*(v^B1))-1)*exp(-T*(u^A1))/a);
end



if C1=='Independent'
    P5=A*(u^(A-1))*(v^(B));
elseif C1=='Clayton'
    P5=(A*u^(A-1))*(((u^A)^(-T-1))/(-1+u^(-A*T)+v^(-B*T))^((T+1)/T));
elseif C1=='Frank'
    a=(exp(-T)-1)+(exp(-T*(u^A))-1)*(exp(-T*(v^B))-1);
    P5=(A*u^(A-1))*((exp(-T*(v^B))-1)*exp(-T*(u^A))/a);
end


    
if C2=='Independent'
    P6=B1*(u^(A1))*(v^(B1-1));
elseif C2=='Clayton'
    P6=(B1*v^(B1-1))*(((v^B1)^(-T-1))/(-1+u^(-A1*T)+v^(-B1*T))^((T+1)/T));
elseif C2=='Frank'
    a=(exp(-T)-1)+(exp(-T*(u^A1))-1)*(exp(-T*(v^B1))-1);
    P6=(B1*v^(B1-1))*((exp(-T*(u^A1))-1)*exp(-T*(v^B1))/a)
end



if C1=='Independent'
    P7=(u^A)*(v^B);
elseif C1=='Clayton'
    P7=(u^(-A*T)+v^(-B*T)-1)^(-1/T);
elseif C1=='Frank'
    P7=(-1/T)*(1+(exp(-T*(u^A))-1)*(exp(-T*(v^B))-1)/(exp(-T)-1)); 
end



if C2=='Independent'
    P8=A1*B1*(u^(A1-1))*(v^(B1-1));
elseif C2=='Clayton'
    P8=(A1*B1*(u^(A1-1))*(v^(B1-1)))*(((T+1)*((u^A1)^(-T-1))*((v^B1)^(-T-1)))/((-1+((u^A1)^(-T))+((v^B1)^(-T)))^(2+(1/T))));
elseif C2=='Frank'
    a=(exp(-T)-1)+(exp(-T*(u^A1))-1)*(exp(-T*(v^B1))-1);
    P8=(A1*B1*(u^(A1-1))*(v^(B1-1)))*(T*exp(-T*(u^A1+v^B1))*(1-exp(-T))/(a^2));
end


c=P1*P2+P3*P4+P5*P6+P7*P8;
    