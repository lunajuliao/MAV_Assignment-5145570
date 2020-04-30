function [Overlapmax,extradetected,notdetected] = IoUvalues(data,b2,i)

box1=data.Var2(i);
box1=cell2mat(box1);
box2=b2;
n2=size(box2,1);
n1=size(box1,1);
%Calculation of all the IoU for each actual gate for each prediction
for j=1:n1
    for k=1:n2
        first=box1(j,:);
        second=box2(k,:);
        Overlap(j,k)= bboxOverlapRatio(first,second,'Union');
    end    
end
%Define if there were gates which were not detected or if detected more
%gates than the gates that existed
extradetected= size(Overlap,2)-size(Overlap,1);
notdetected=size(Overlap,1)-size(Overlap,2);
extradetected=max(0,extradetected);
notdetected=max(0,notdetected);

%Choose the max IoU values for each prediction
for j=1:n2
    Overlapmax(j)=max(Overlap(:,j));
end
end

