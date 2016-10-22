function write_image_vtk2(name,im,hd,form,bl,type)
% Updated version by P.Lamata
% Changes (02-06-10)
% - Choice between big or little endian format
% Changes (04-11-09):
% - Possibility of writing spacing and origin.
% - Removal of the permutation XY



% Boolean variable to return to original version (not loaded in ITKSnap)
originalversion=0;
% Datatype to write:
% TODO: FIND THE RIGHT DATATYPE TO BE WRITTEN WITH type = 'unsigned_short';


DefaultBigOrLittleEndian = 'l';
if isunix()
    DefaultBigOrLittleEndian = 'b';
end

if nargin<5
    bl=DefaultBigOrLittleEndian;
end
if nargin<6
    type = 'float';
end
%im = permute(im,[2 1 3]);
M = size(im);
if length(M) < 3
    M = [M 1];
end
dform = 0;
if nargin < 3
    spacing=[1 1 1];
    origin =[0 0 0];
else
    spacing=hd.spacing;
    origin =hd.origin;
end
fprintf(' Writting VTK image %s (dimensions = %i,%i,%i), (origin = %1.1f,%1.1f,%1.1f), (spacing = %1.1f,%1.1f,%1.1f)\n',name,size(im),origin,spacing);
if nargin > 3
    if strcmp(form,'ascii')
        dform = 1;
    else
        dform = 0;
    end
end
fid = fopen(name,'wb',bl);

if fid==-1
    fprintf('WARNING! not possible to open writable file %s\n',name);
else
    fprintf(fid,'# vtk DataFile Version 3.0\n');
    fprintf(fid,'VTK File Generated by Sheffield Image Regsitration Toolkit (ShIRT Rev 9.1 by P.Lamata, write_image_vtk2)\n');
    if dform == 0
        fprintf(fid,'BINARY\n');
    else
        fprintf(fid,'ASCII\n');
    end
    %fprintf(fid,'DATASET RECTILINEAR_GRID\n');	
    fprintf(fid,'DATASET STRUCTURED_POINTS\n');	
    fprintf(fid,'DIMENSIONS %d %d %d\n', M(1), M(2), M(3));
    fprintf(fid,'SPACING %d %d %d\n', spacing);
    fprintf(fid,'ORIGIN %d %d %d\n', origin);
    if (originalversion)
        fprintf(fid,'X_COORDINATES %d float\n', M(1));
        if dform == 0
            fwrite(fid,[1:M(1)],'float');
        else
            fprintf(fid, '%f ', [1:M(1)]);
        end
        if dform == 1
            fprintf(fid,'\n');
        end
        fprintf(fid,'Y_COORDINATES %d float\n', M(2));
        if dform == 0
            fwrite(fid,[1:M(2)],'float');
        else
            fprintf(fid, '%f ', [1:M(2)]);
        end
        if dform == 1
            fprintf(fid,'\n');
        end
        fprintf(fid,'Z_COORDINATES %d float\n', M(3));
        if dform == 0
            fwrite(fid,[1:M(3)],'float');
        else
            fprintf(fid, '%f ', [1:M(3)]);
        end
        if dform == 1
            fprintf(fid,'\n');
        end
        fprintf(fid,'CELL_DATA %d\n', (M(1)-1)*(M(2)-1)*(M(3)-1));
    end
    fprintf(fid,'POINT_DATA %d\n',prod(M));
    fprintf(fid,['SCALARS scalars ' type ' 1\n']);
    fprintf(fid,'LOOKUP_TABLE default\n');
    if dform == 0
        % Documentation in http://www.vtk.org/wp-content/uploads/2015/04/file-formats.pdf
        switch type
            % 8 bits options:
            case 'unsigned_byte'
                fwrite(fid,uint8(im(:)),'uint8',bl);            
            % 16 bits options:
            case 'unsigned_short'
                fwrite(fid,uint16(im(:)),'uint16',bl);
            case 'short'
                fwrite(fid,int16(im(:)),'int16',bl);
            % 32 bits options:
            case 'unsigned_int'
                fwrite(fid,uint32(im(:)),'uint32',bl);
            case 'float'
                fwrite(fid,single(im(:)),'float',bl);
            % 64 bits options:
            case 'double'
                fwrite(fid,double(im(:)),'double',bl);
            otherwise
                fprintf(1,'ERROR while writting VTK, datatype selected in binary not recognised!!\n');            
        end
    else
        switch type
            case 'float'
                fprintf(fid, '%f ', im(:));
            case 'unsigned_short'
                fprintf(fid, '%i ', im(:));
            otherwise
                fprintf(1,'ERROR while writting VTK, datatype selected for ASCII not recognised!!\n');
        end
    end
    if dform == 1
        fprintf(fid,'\n');
    end
    fclose(fid);
    % VTK File Generated by Insight Segmentation and Registration Toolkit (ITK)
    % BINARY
    % DATASET STRUCTURED_POINTS
    % DIMENSIONS 115 118 198
    % SPACING 9.7460939999999996e-001 9.7460939999999996e-001 5.0000000000000000e-001
    % ORIGIN 0.0000000000000000e+000 0.0000000000000000e+000 0.0000000000000000e+000
    % POINT_DATA 2686860
    % SCALARS scalars unsigned_short 1
    % LOOKUP_TABLE default
end