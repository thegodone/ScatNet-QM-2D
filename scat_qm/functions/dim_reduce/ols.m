% OLS
% Orthogonal least squares
%
% Usage:
%   atom_ind = OLS(f,Phi,M,option_repeat)
%
% Summary:
%   Computes the best M atoms for representing f in Phi via orthogonal
%   least squares (OLS). 
%
% Inputs:
%   1.) f (numeric): A dx1 vector that is the signal.
%   2.) Phi (numeric): A dxP matrix that is the dictionary, consisting of P
%       dictionary elements in R^d.
%   3.) M (integer): The maximum number of OLS steps, or dictionary elements, to
%       use.
%   4.) option_repeat (boolean): If true, repeats the calculation to avoid
%       round off errors and improve precision.
%
% Outputs:
%   1.) atom_ind (numeric): The indices of the atoms selected from Phi.
%
% See also:
%   QM_KFOLD_REGRESSION, QM_OLS_KFOLD_REGRESSION 
%
% This file is part of ScatNet_QM_2D.
%
% Author: Matthew Hirn
% Email: mhirn@msu.edu
% Slightly optimized by Edouard Oyallon
%
% Copyright 2016 Matthew J. Hirn and Edouard Oyallon
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function atom_ind = ols(f,Phi,M,option_repeat)

% --- Pre-processing ---

% Dimensions and number of iterations
[d,P] = size(Phi);
if nargin < 3 || M > min(d,P)
    M = min(d,P);
end

% OPTIMIZATION For round-off errors and precision...
if(nargin<4)
    option_repeat=1;
end

% OPTIMIZATION Normalize phi
Phi=bsxfun(@times,Phi,1./sqrt(sum(Phi.^2,1)));

% Initialize
Rf = zeros(d,M+1);
Rf(:,1) = f;
atom_ind = [];
z = [];
PhiLambda = Phi;
m = 1;

%% OLS loop

% --- Step 1 ---

% Display
fprintf('OLS m-term number:  ');
fprintf('%d',m);

% Find first dictionary atom
ip = Rf(:,m)'*PhiLambda;
[~,ind] = max(abs(ip));
ind=ind(1);% DEBUG Take only the first element of the max!!!!
atom_ind = cat(2,atom_ind,ind);

% OPTIMIZATION No QR, basis is already orthonormalized
Q(:,m)=Phi(:,ind);

% OPTIMIZATION Set to 0 instead to remove
PhiLambda(:,ind) = 0;
% OPTIMIZATION Avoid one transpose
Q2=Q(:,m)';
for r=1:option_repeat
for j=1:size(PhiLambda,2)
    PhiLambda(:,j) = PhiLambda(:,j) - (Q2*PhiLambda(:,j))*Q(:,m);
end

% OPTIMIZATION Normalization
PhiLambda=bsxfun(@times,PhiLambda,1./sqrt(sum(PhiLambda.^2,1)));
end

% Update the residual
z = cat(2,z,Rf(:,m)'*Q(:,m));
Rf(:,m+1) = Rf(:,m) - z(m)*Q(:,m);

% Update m
m = m+1;

% --- Steps 2 and higher ---

while norm(Rf(:,m)) > eps('double') && m <= M
    
    % Display
    for i=0:log10(m-1)
        fprintf('\b');
    end
    fprintf('%d',m);
    
    % Find next dictionary atom
    ip = Rf(:,m)'*PhiLambda;
    [~,ind] = max(abs(ip));
    ind=ind(1); % DEBUG Take only one max
    atom_ind = cat(2,atom_ind,ind);
    
    % OPTIMIZATION : Take the orthornomal basis
    Q(:,m)=PhiLambda(:,ind);
    PhiLambda(:,ind) = 0;
    
    % OPTIMIZATION Avoid one computation
    Q2=Q(:,m)';
    for r=1:option_repeat
        for j=1:size(PhiLambda,2)
            PhiLambda(:,j) = PhiLambda(:,j) - (Q2*PhiLambda(:,j))*Q(:,m);
        end
        % OPTIMIZATION Normalization
        PhiLambda=bsxfun(@times,PhiLambda,1./sqrt(sum(PhiLambda.^2,1)));
    end
    
    % Update the residual
    z = cat(2,z,Rf(:,m)'*Q(:,m));
    Rf(:,m+1) = Rf(:,m) - z(m)*Q(:,m);
    
    % Update m
    m = m+1;
end

fprintf('\n');

end
