function [Rho_Gauss Rho_t Nu_t Rho_Clayton Rho_Frank Rho_Gumbel] = FindOtherCopula(Y,N)

U=[];

if size(Y,2)>=2
    mc1=ksdensity(Y(:,1),Y(:,1),'function', 'cdf')';
    mc1(find(mc1<0.00001))=0.00001;
    mc1(find(mc1>0.99999))=0.99999;
    U=[U mc1'];
    
    mc2=ksdensity(Y(:,2),Y(:,2),'function', 'cdf')';
    mc2(find(mc2<0.00001))=0.00001;
    mc2(find(mc2>0.99999))=0.99999;
    U=[U mc2'];
end

if size(Y,2)>=3
    mc3=ksdensity(Y(:,3),Y(:,3),'function', 'cdf')';
    mc3(find(mc3<0.00001))=0.00001;
    mc3(find(mc3>0.99999))=0.99999;
    U=[U mc3'];
end

if size(Y,2)>=4
    mc4=ksdensity(Y(:,4),Y(:,4),'function', 'cdf')';
    mc4(find(mc4<0.00001))=0.00001;
    mc4(find(mc4>0.99999))=0.99999;
    U=[U mc4'];
end

%%Gaussian
Rho_Gauss=copulafit('Gaussian',U);
% Rho=Rho(1,2);
% Y = copulacdf('Gaussian',[V1(:) V2(:)],Rho);
% GaussianCopula=reshape(Y,length(y),length(y));


%%Student t
%[Rho_t,Nu_t] = copulafit('t',U);
% Y = copulacdf('t',[V1(:) V2(:)],Rho,Nu);
% tCopula=reshape(Y,length(y),length(y));

%Clayton
%Rho_Clayton=copulafit('Clayton',U);
% Y = copulacdf('Clayton',[V1(:) V2(:)],Rho);
% ClaytonCopula=reshape(Y,length(y),length(y));

%%Frank
%Rho_Frank = copulafit('Frank',U);
% Y = copulacdf('Frank',[V1(:) V2(:)], Rho);
% FrankCopula=reshape(Y,length(y),length(y));

%%Gumbel
%Rho_Gumbel = copulafit('Gumbel',U);
% Y = copulacdf('Gumbel',[V1(:) V2(:)], Rho);
% GumbelCopula=reshape(Y,length(y),length(y));

