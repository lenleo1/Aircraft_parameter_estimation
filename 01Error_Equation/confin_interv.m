function [sy,yl] = confin_interv(x,p,s2)
%
%  CONFIN  Computes 95 percent confidence intervals for linear regression model outputs.
%  Input:
%
%      x = matrix of column regressors.
%      p = estimated parameter vector.
%     s2 = fit error variance estimate.
%
%  Output:
%
%     sy = vector of standard errors for the estimated 
%          or predicted output.
%     yl = model output vector lower and upper limits.

%    Author:  lenleo
%    2020.11.20
%  Initialization.
[npts,~]=size(x);
xtx=real(x'*x);
xtxi=inv(xtx);
y=x*p;
%  Compute the estimated or predicted output variances.
smat=s2*x*xtxi;
s2y=zeros(npts,1);
for i=1:npts
  s2y(i)=smat(i,:)*x(i,:)';
end
s2y=s2y+s2*ones(npts,1);
sy=sqrt(s2y);
%  Compute the upper and lower bounds of the 95 percent confidence interval.  
yl=zeros(npts,2);
yl(:,1)=y-2*sy;
yl(:,2)=y+2*sy;
return
