exampleData = load("EXAMPLE1.mat");
for i = 1:7
    vertices = [Xfemur(:,i),Yfemur(:,i),Zfemur(:,i)];
    surfaceMesh1 = triangulation(exampleData.Fdata,vertices);
    stlwrite(surfaceMesh1,"femur"+num2str(i)+".stl");
end

newSurfaceMesh = triangulation(exampleData.F,exampleData.V);
stlwrite(newSurfaceMesh,"testFemur.stl");

%结论：
%Xfemur,Yfemur,Zfemur分别是7个训练数据的vertices x,y,z坐标；他们的对应关系已经建立好；Fdata为他们共用的面片关系
%F和V为一个新测试数据的faces和vertices

