function nrrd = scinrrd_im2nrrd(im, res, offset, rotmatrix)
% SCINRRD_IM2NRRD  Create SCI NRRD struct from Matlab data.
%
% This function creates a struct with the correct format that the Gerardus
% Toolbox uses for NRRD variables. This is the same format you obtain when
% loading a .mat file using scimat_load(), and can be saved to a .mat file
% using scimat_save().
%
% NRRD = scinrrd_im2nrrd(IM, RES, OFFSET)
%
%   IM is a Matlab array with the image or segmentation. IM can be of class
%   logical, (u)int8, (u)int16, (u)int32, (u)int64, single or double. IM
%   cannot have more than 3 dimensions.
%
%   RES is a 3-vector with the voxel size. By default, RES = [1 1 1]. Note
%   that:
%
%     RES(1) --> rows     (y axis)
%     RES(2) --> columns  (x axis)
%     RES(3) --> slices   (z axis)
%
%   OFFSET is a 3-vector with the coordinates of the *centre* of the first
%   voxel in the image. The same correspondence with rows, columns and
%   slices as for RES applies.
%
%   ROTMATRIX is a 3x3-matrix with the information of the orientation of
%   the image. It is understood in X,Y,Z coordinates!

% Author: Ramon Casero <rcasero@gmail.com>
% Copyright © 2011-2014 University of Oxford
% Version: 0.1.3
% $Rev: 1450 $
% $Date: 2014-05-08 11:56:21 +0100 (Thu, 08 May 2014) $
% 
% University of Oxford means the Chancellor, Masters and Scholars of
% the University of Oxford, having an administrative office at
% Wellington Square, Oxford OX1 2JD, UK. 
%
% This file is part of Gerardus.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. The offer of this
% program under the terms of the License is subject to the License
% being interpreted in accordance with English Law and subject to any
% action against the University of Oxford being under the jurisdiction
% of the English Courts.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% check arguments
narginchk(1, 4);
nargoutchk(0, 1);

% defaults
if (nargin < 2 || isempty(res))
    res = [1 1 1];
end
if (nargin < 3 || isempty(offset))
    offset = [0 0 0];
end
if nargin < 4 || isempty(rotmatrix)
    rotmatrix = eye(3);
end

% create NRRD struct

% data volume
nrrd.data = im;
nrrd.rotmat = rotmatrix;

% loop some of the fields
for I = 1:3
    
    % data volume size
    nrrd.axis(I).size = size(im, I);
    
    % image resolution
    nrrd.axis(I).spacing = res(I);
    
    % left edge of first voxel
    nrrd.axis(I).min = offset(I) - res(I) / 2;
    
    % left edge of last voxel
    nrrd.axis(I).max = offset(I) + (size(im, I) - 1) * res(I);
    
    % unused
    nrrd.axis(I).center = 1;
    nrrd.axis(I).unit = 'no unit';
    
end

% other
nrrd.axis(1).label = 'axis 2';
nrrd.axis(2).label = 'axis 1';
nrrd.axis(3).label = 'axis 3';

% we need nrrd.axis to be a column vector
nrrd.axis = nrrd.axis';
