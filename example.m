clc;
clear;
load('EXAMPLE1.mat')
[ssmV,Eval,Evec,MEAN,PCcum,Modes]=SSMBuilder.SSMbuilder(Xfemur,Yfemur,Zfemur);
SSMBuilder.plotshapemode(1,ssmV,MEAN,Fdata);


 %load scale 2 test femur
%  scale2Tri = stlread("testFemur_2.stl");
%  V = scale2Tri.Points;
%  F = scale2Tri.ConnectivityList;
 [RMSerror,ReallignedV,transform,SSMfit,EstimatedModes]=SSMBuilder.SSMfitter(MEAN,Fdata,ssmV,V,F,2);

%  realignedTri = triangulation(F,ReallignedV);
%  ssmFitTri = triangulation(Fdata,SSMfit);
%  stlwrite(realignedTri,"realigned_2.stl");
%  stlwrite(ssmFitTri,"ssmFit_2.stl");
