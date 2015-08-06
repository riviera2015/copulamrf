function [ecop]=FindCopulaPal3(Y,NN);

MM(:,1)=ksdensity(Y(:,1),Y(:,1),'function', 'cdf')';
MM(:,2)=ksdensity(Y(:,2),Y(:,2),'function', 'cdf')';

y1=linspace(1/NN,1,NN);
M(:,1)=hist(MM(:,1),y1);
M(:,1)=cumsum(M(:,1)/sum(M(:,1)));
M(:,2)=hist(MM(:,2),y1);
M(:,2)=cumsum(M(:,2)/sum(M(:,2)));


y1=linspace(1/NN,1,NN);
y = [y1' y1'];
m=size(y,1);
N=size(M,1);

% for i=1:m
%     for j=1:m
%         ecop1(i,j) = sum( (M(:,1)<=y(i,1)).*(M(:,2)<=y(j,2)) )/N;
%     end
% end

Mat1=M(:,1)*ones(1,m);
Mat2=M(:,2)*ones(1,m);
C=ones(N,1)*y1;

MM1=Mat1<=C;
MM2=Mat2<=C;
[A B]=meshgrid([1:m]);
A=A(:)';
B=B(:)';

MM=MM1(:,A).*MM2(:,B);
ecop=sum(MM,1)/N;
ecop=reshape(ecop,m,m)';
