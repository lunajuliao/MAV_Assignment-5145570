function [trainingData] = dataprocessing()

%Read the data from the provided file "corners.csv" with the positions of
%the frame
data=readtable('corners.csv');
data{:,1} = erase(data{:, 1}, 'img_');
data{:,1} = erase(data{:, 1}, '.png');
%Initialize some variables needed for the computations
target=[];
input=[];
aux=[];
a=1;
d=1;
imageName=[];
gate=[];
trainingData=table;

%cicle to go thorugh every line of the csv file
while a<=690
    %Since the csv file data is not ordered, it is necessary to get the
    %image number
    b=data.Var1(a);
    pic_name=['dataset/' 'img_' b '.png'];
    pic_name=join(pic_name,'');
    pic_name=cell2mat(pic_name);
    %Obtain the dimensions in groundTruth format
    [w,h,x,y]=dimension(data,a,pic_name);
    %save the first gate information for an image
    t=[x;y;w;h];
    if size(data,1)>= a+1 && strcmp(data.Var1(a),data.Var1(a+1))
        a=a+1;
        [w,h,x,y]=dimension(data,a,pic_name);
        %save the second gate information for an image
        t1=[x;y;w;h];
        
        if size(data,1)>= a+1 && strcmp(data.Var1(a),data.Var1(a+1))
            a=a+1;
            [w,h,x,y]=dimension(data,a,pic_name);
            %save the third gate information for an image
            t2=[x;y;w;h];
            aux=[t;t1;t2];
            if strcmp(data.Var1(a),data.Var1(a+1))
            a=a+1;
            [w,h,x,y]=dimension(data,a,pic_name);
            %save the fourth gate information for an image
            t3=[x;y;w;h];
            aux=[t;t1;t2;t3];
            a=a+1;
 
        else
            aux=[t;t1;t2];
            a=a+1;
            
        end
 
        else
            aux=[t;t1];
            a=a+1;
            
        end
    else
        aux=t;
        a=a+1;
        
    end
    %reshape the aux variable since its size is variables considering that
    %each image can have a different nummber of gates
    aux = {reshape(aux, [4 length(aux)/4])'};
    %Creating the training data table with all the information in
    %grounTruth format with the correspondent 
    trainingData(d, :) = {pic_name, aux};
    d=d+1;
end
end

