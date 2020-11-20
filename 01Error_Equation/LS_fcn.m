function [y,p,crb,s2] = LS_fcn(x,z,p0,crb0)
%
%  Least squares linear regression.  
%
%  Input:
%
%      x = matrix of column regressors.
%      z = measured output vector.
%     p0 = prior parameter vector (optional).
%   crb0 = prior parameter covariance matrix (optional).
%
%  Output:
%      y = model output vector.
%      p = vector of parameter estimates.
%    crb = estimated parameter covariance matrix.
%     s2 = model fit error variance estimate. 

%    Author:  lenleo
%    2020.11.20

[npts,np]=size(x);
%  OLS
xtx=real(x'*x);
xtxi=inv(xtx);
% p=xtx\real(x'*z);
p=xtxi*real(x'*z);
y=x*p;

%  Real s2 used to remove round-off error.
s2=real((z-y)'*(z-y))/(npts-np);
%crb=s2*inv(xtx);
crb=s2*xtxi;
%
%  Modifications for a priori information.
if nargin==4
%  Check crb0.
  [m,n]=size(crb0);
  if m~=np || n~=np
    fprintf('\n Input matrix crb0 has wrong dimensions \n\n')
    return
  end
% Check for non-singular crb0.
  if (1/cond(crb0))>0
%
    M0=(crb0);
  else
    M0=zeros(np,np);
  end
%  Combined information matrix.
  xtxi=inv(xtx/s2 + M0);
%  For the a priori information, x'*z = (x'*x)*p.
%
  p=xtxi*(real(x'*z)/s2 + M0*p0);
  y=x*p;
%  Cramer-Rao bound matrix
  crb=xtxi;
end
return
