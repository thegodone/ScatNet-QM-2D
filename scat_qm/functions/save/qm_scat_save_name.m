% QM_SCAT_SAVE_NAME
% Create a file name for saving scattering features.
%
% Usage:
%   filename = QM_SCAT_SAVE_NAME(data_opt, scat_opt, filt_opt)
%
% Inputs:
%   1.) data_opt (struct): Data options
%   2.) scat_opt (struct): Scattering options
%   3.) filt_opt (struct): Filter options
%
% Outputs:
%   1.) filename (string): The file name for saving.
%
% See also:
%   QM_COMPUTE_SCAT_2D
%
% This file is part of ScatNet_QM_2D.
%
% Author: Matthew Hirn
% Email: mhirn@msu.edu
%
% Copyright 2016 Matthew J. Hirn
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

function filename = qm_scat_save_name(data_opt, scat_opt, filt_opt)

filename = strcat(data_opt.data_set, '_scat_M=',num2str(scat_opt.M),...
    '_N=', num2str(data_opt.N(1)), 'x', num2str(data_opt.N(2)), '_J=', ...
    num2str(filt_opt.J), '_Q=', num2str(filt_opt.n_wavelet_per_octave), ...
    '_L=', num2str(filt_opt.L), '_slant=', num2str(filt_opt.slant_psi));
if scat_opt.O2_invariant
    filename = strcat(filename, '_O2_invariant');
end
filename = strcat(filename, '.mat');

end