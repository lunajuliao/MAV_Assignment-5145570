function [TPRvector,FPvector,IoU_vector] = ROCcurves(testset)

load detector
load acfDetector
clc
%The different values to which each ROC curve is calculated
IoU_vector=[0.6,0.7,0.9];

for IoU=1:size(IoU_vector,2)
    Confidence_threshold=1;
    ind=1;
    %Decide the IoU value for this iteration
    IoUthreshold=IoU_vector(IoU);
while Confidence_threshold>=0
    %Reset of the false positives(FP), false negatives(FN) and true
    %positives(TP) values
    FN=0; TP=0; FP=0;
    %for every image
for i=1:size(testset,1)
    pic_name_2=testset.Var1(i);
    pic_name_2=cell2mat(pic_name_2);
    img=imread(pic_name_2);
    [bboxes, scores] = detect(detector,img);
    scores=transpose(scores);
    %consider there can be no detections
    if size(bboxes,1)==0 || size(scores,1)==0
        FN=FN+size(testset.Var2(i),1);
    else
    %Calculation of IoU values
    [Overlap,extradetected_i,notdetected_i]=IoUvalues(testset,bboxes,i);
    %include the non detection of a real gate as a false negative
    FN=FN+notdetected_i;
    %for the situations when the number of detected gates is the same as
    %the number of actual gates or when is bigger : the following evaluates
    %the detected gates
    for j=1:size(Overlap,2)
            if Overlap(j) > IoUthreshold && scores(j) > Confidence_threshold
                TP=TP+1; %increase true positive
            elseif Overlap(j) > IoUthreshold && scores(j) < Confidence_threshold
                FN=FN+1; %increase false negative
            elseif Overlap(j) < IoUthreshold && scores(j) > Confidence_threshold
                FP=FP+1; %increase false positive
            end
    end
   
    end

end
Confidence_threshold=Confidence_threshold-0.005; %Iterating the confidence threshold
TPR=TP/(TP+FN); %Calculation of the true positive rate
TPRvector(IoU,ind)=TPR; 
FPvector(IoU,ind)=FP;
ind=ind+1;
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    IoU_vector_2=[0.6];
    IoUthreshold= IoU_vector_2;
    Confidence_threshold=200;
    ind=1;
while Confidence_threshold > 0
    %Reset of the false positives(FP), false negatives(FN) and true
    %positives(TP) values
    FN=0; TP=0; FP=0;
    %for every image
for i=1:size(testset,1)
    pic_name_2=testset.Var1(i);
    pic_name_2=cell2mat(pic_name_2);
    img=imread(pic_name_2);
    [bboxes, scores] = detect(acfDetector,img);
    scores=transpose(scores);
    %consider there can be no detections
    if size(bboxes,1)==0 || size(scores,1)==0
        FN=FN+size(testset.Var2(i),1);
    else
    %Calculation of IoU values
    [Overlap,extradetected_i,notdetected_i]=IoUvalues(testset,bboxes,i);
    %include the non detection of a real gate as a false negative
    FN=FN+notdetected_i;
    %for the situations when the number of detected gates is the same as
    %the number of actual gates or when is bigger : the following evaluates
    %the detected gates
    for j=1:size(Overlap,2)
            if Overlap(j) > IoUthreshold && scores(j) > Confidence_threshold
                TP=TP+1; %increase true positive
            elseif Overlap(j) > IoUthreshold && scores(j) < Confidence_threshold
                FN=FN+1; %increase false negative
            elseif Overlap(j) < IoUthreshold && scores(j) > Confidence_threshold
                FP=FP+1; %increase false positive
            end
    end
   
    end

end
Confidence_threshold=Confidence_threshold-1; %Iterating the confidence threshold
TPR=TP/(TP+FN); %Calculation of the true positive rate
TPRvector(4,ind)=TPR; 
FPvector(4,ind)=FP;
ind=ind+1;
end


% Normalization considering the maximum number of total false positives - consequence of plotting the different ROC curves in one plot
for IoU=1:size(IoU_vector,2)+size(IoU_vector_2,2)
TPR_max=max(TPRvector(IoU,:));
FP_max=max(FPvector(IoU,:));
TPRvector(IoU,:)=TPRvector(IoU,:)/TPR_max;
FPvector(IoU,:)=FPvector(IoU,:)/FP_max;
end
end

