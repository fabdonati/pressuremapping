addpath(genpath( cd ) );
clc
tic
werp = WerpPressureEstimation_NEW( cd, ...
    'HT002',...
    'sys_seg.vtk','sys_seg.vtk','sys_seg_ref.vtk',...
    'Velocity_rs.mat','HLHS', 'AdvectiveTest');
toc