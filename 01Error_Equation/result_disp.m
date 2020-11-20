function modelstr = result_disp(p,serr,xnames,pnames)
%
%  MODEL_DISP  Displays parameter estimation results.  
%  Input:
%    
%       p = parameter vector for ordinary polynomial function expansion.
%    serr = vector of estimated parameter standard errors.
%      ip = vector of integer indices (optional).
%  xnames = names of the independent variables (optional).
%  pnames = names of the parameters (optional).
%
%
%  Output:
%
%      modelstr = string containing the analytic model expression.  
%    Author:  lenleo
%    2020.11.20
%
ip = [];
nterms=length(p);
%
%  If pnames is input, make sure 
%  the elements are in a character 
%  array of the correct size.
%
if nargin > 4 && ~isempty(pnames)
  if ~iscell(pnames)
    pnames=cellstr(pnames);
  end
end
fprintf('\n\n')
%
%  Generate and output the model string, only if ip is input.
%
if nargin < 3 || isempty(ip)
%
%  Print out the headings.
%
  fprintf(' Parameter    Estimate     Std Error   %% Error  95 %% Confidence Interval\n')
  fprintf(' ---------    --------     ---------   -------  ------------------------\n')
%
%  Find percent errors.  Use the absolute error
%  if the parameter estimate is zero.  
%
  perr=zeros(nterms,1);
  for j=1:nterms
    if p(j)~=0
      perr(j)=100*serr(j)./abs(p(j));
    else
      perr(j)=serr(j);
    end
  end
%
%  Print out the parameter estimate information
%  in tabular format.  Use parameter labels, if provided.
%
  for k=1:nterms
    if nargin < 5 || isempty(pnames)
      if k < 10
        fprintf('  p( %1i ) ',k)
      else
        fprintf('  p( %2i )',k)
      end
    else
      fprintf(['  ',char(pnames{k})]),
      nc=length(char(pnames{k}))+2;
%
%  Fill in blanks up to 9 characters, 
%  to keep the numbers lined up. 
%
      for j=1:9-nc
        fprintf(' '),
      end
    end
    if p(k) >= 0.0
      fprintf(' ')
    end
    fprintf(['   %10.3e   %10.3e    %5.1f    [ %8.3f , %8.3f ]\n'], ...
             p(k),serr(k),perr(k),p(k)-2*serr(k),p(k)+2*serr(k))
  end
else
%
%  Generate the model string.
%
  modelstr=[' y = '];
%
%  Loop over the model terms.
%
  for k=1:nterms
    indx=ip(k);
    modelstr=[modelstr,'p(',num2str(k),')'];
%
%  The independent variable index is j.
%  Number of independent variables is nvar.
%
    j=0;
    nvar=0;
    while indx > 0
      j=j+1;
      ji=round(rem(indx,10));
      if ji~=0
        modelstr=[modelstr,'*x',num2str(j)];
        if ji > 1
          modelstr=[modelstr,'^',num2str(ji)];
        end
      end
      indx=floor(indx/10);
    end
    if j > nvar
      nvar=j;
    end
    if k < nterms
      modelstr=[modelstr,' + '];
    end
  end
%
%  Output the model string.
%
  disp(modelstr)
  fprintf('\n\n')
%
%  Print out the headings.
%
  fprintf(' Parameter    Estimate     Std Error   %% Error  95 %% Confidence Interval   Index\n')
  fprintf(' ---------    --------     ---------   -------  ------------------------   -----\n')
%
%  Find percent errors.  Use the absolute error
%  if the parameter estimate is zero.  
%
  perr=zeros(nterms,1);
  for j=1:nterms
    if p(j)~=0
      perr(j)=100*serr(j)./abs(p(j));
    else
      perr(j)=serr(j);
    end
  end
%
%  Print out the parameter estimate information
%  in tabular format.  Use parameter labels, if provided.
%
  for k=1:nterms
    if nargin<5 || isempty(pnames)
      if k < 10
        fprintf('  p( %1i ) ',k)
      else
        fprintf('  p( %2i )',k)
      end
    else
      fprintf(['  ',char(pnames{k})]),
      nc=length(char(pnames{k}))+2;
%
%  Fill in blanks up to 9 characters, 
%  to keep the numbers lined up. 
%
      for j=1:9-nc
        fprintf(' '),
      end
    end
    if p(k) >= 0.0
      fprintf(' ')
    end
    fprintf(['   %10.3e   %10.3e    %5.1f    [ %8.3f , %8.3f ]',...
             '     %',num2str(nvar),'i\n'], ...
             p(k),serr(k),perr(k),p(k)-2*serr(k),p(k)+2*serr(k),ip(k))
  end
%
%  Print out the independent variable names.
%
  fprintf('\n\n')
  if nargin > 3
    nvar=size(xnames,1);
    for k=1:nvar
      if iscell(xnames)
        disp([' x',num2str(k),' = ',char(xnames{k})]);
      else
        disp([' x',num2str(k),' = ',xnames(k,:)]);
      end
    end
  end
end
fprintf('\n')
return
