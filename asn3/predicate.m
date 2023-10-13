function flag = predicate(region)
%PREDICATE Helper function for splitmerge.
%   This function sets flag to TRUE (logical 1)  if the predicate in the
%   body of the function is satisfied. Otherwise it sets flag to FALSE
%   (logical 0).


% Compute standard deviation of the ENTIRE REGION (should be a scalar).
% Enter code:
standarddeviation=std(region)
% Compute mean of the ENTIRE REGION (should be a scalar).
% Enter code:
average=mean(mean(region))
% Set flag to 1 if standard deviation is greater than zero AND
% mean is greater than zero AND
% mean is less than 125.
% Enter code:
if(standarddeviation>0&&average>0&&average<125)flag=1;
else flag=0;
end