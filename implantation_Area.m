% This function computes the implantation area of the placenta on the
% uterus. It does so by reading in the placental and uterus voxel
% coordinates from their respective text files, then checks whether the
% distance between the uterus and placental voxel coordinates is either
% below or equal to the maximum distance possible. If so, the voxel
% coordinates are stored within an array and the surface area of the
% implanted area is then computed. Ideally, the surface area of the
% implantation should approximately be the difference between the uterus
% and placental surface areas.
%           
%               Output: 
%                       implantationArea: Surface Area of the implantation
%                       placentaArea: Surface Area of the placenta
%                       uterusArea: Surface Area of the uterus
% 
% Written by Archana Dhyani
% University of Wisconsin-Madison

% Placenta mask
tic
fileID = fopen('placenta.txt','r');
C = textscan(fileID, '%f, %f, %f, %f');
fclose(fileID);
 rl = C{1};
 fh = C{2};
 ap = C{3};
Placenta_shp = [rl,fh,ap];
Placenta_shape = alphaShape(Placenta_shp);
 
% Uterus mask
fileID = fopen('uterus.txt','r');
C = textscan(fileID, '%f, %f, %f, %f');
fclose(fileID);
 rl = C{1};
 fh = C{2};
 ap = C{3};
Uterus_shp = [rl,fh,ap];
Uterus_shape = alphaShape(Uterus_shp);

imp_x=0;
imp_y=0;
imp_z=0;
pmid=0;
umid=0;

i=1;
dMax = 4;


placenta_triangles = [FV2_placenta.vertices(FV2_placenta.faces(:,1),:),FV2_placenta.vertices(FV2_placenta.faces(:,2),:),FV2_placenta.vertices(FV2_placenta.faces(:,3),:)];
uterus_triangles = [FV2_uterus.vertices(FV2_uterus.faces(:,1),:), FV2_uterus.vertices(FV2_uterus.faces(:,2),:), FV2_uterus.vertices(FV2_uterus.faces(:,3),:)];
index = [];
for b=1:size(placenta_triangles,1)
        
        pmid(1,1) = (placenta_triangles(b,1)+placenta_triangles(b,4)+placenta_triangles(b,7))/3;
        pmid(1,2) = (placenta_triangles(b,2)+placenta_triangles(b,5)+placenta_triangles(b,8))/3;
        pmid(1,3) = (placenta_triangles(b,3)+placenta_triangles(b,6)+placenta_triangles(b,9))/3;
    
    for c=1:size(uterus_triangles,1)      
        
        umid(1,1) = (uterus_triangles(c,1)+uterus_triangles(c,4)+uterus_triangles(c,7))/3;
        umid(1,2) = (uterus_triangles(c,2)+uterus_triangles(c,5)+uterus_triangles(c,8))/3;
        umid(1,3) = (uterus_triangles(c,3)+uterus_triangles(c,6)+uterus_triangles(c,9))/3;
        
        distance = sqrt(((pmid(1,1)-umid(1,1))^2)+((pmid(1,2)-umid(1,2))^2)+((pmid(1,3)-umid(1,3))^2));
              
        if (distance<=dMax)
             index = [index;b];
             break;   
        end  
    end
        
end


FV_imp.faces = FV_placenta.faces(index,:);
FV_imp.vertices = FV_placenta.vertices(FV_imp.faces,:);
imp_shp = [FV_imp.vertices];
imp_shape = alphaShape(imp_shp);
implantationArea = surfaceArea(imp_shape)
placentaArea = surfaceArea(Placenta_shape);
uterusArea = surfaceArea(Uterus_shape);
toc



    