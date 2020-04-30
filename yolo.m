%% DATA PROCESSING
clear all
clc
[Data]=dataprocessing();

%% PARAMETERS FOR THE NEURAL NETWORK AND THE TRAINING OF THE DETECTORS
% Adaptation of code from: https://www.mathworks.com/help/deeplearning/ug/create-simple-deep-learning-network-for-classification.html
% Adaptation of code from: https://www.mathworks.com/help/vision/ref/trainyolov2objectdetector.html
%Compute the convolutional neural network to input in the yolov2 detector
%training
layers = [
    imageInputLayer([120 120 3], 'Name', 'first0')
    
    convolution2dLayer([3 3],8,'Padding',1, 'Name', 'first1')
    batchNormalizationLayer('Name', 'first2')
    reluLayer('Name', 'first3')
    
    maxPooling2dLayer(2,'Stride',2,'Name', 'first4')
    
    convolution2dLayer([3 3],16,'Padding',1,'Name', 'first5')
    batchNormalizationLayer('Name', 'first6')
    reluLayer('Name', 'first7')
    
    maxPooling2dLayer(2,'Stride',2,'Name', 'first8')
    
    convolution2dLayer([3 3],32,'Padding',1,'Name', 'first9')
    batchNormalizationLayer('Name', 'first10')
    reluLayer('Name', 'first11')
    
    maxPooling2dLayer(2,'Stride',2,'Name', 'first12')
    
    convolution2dLayer([3 3],64,'Padding',1,'Name', 'first13')
    batchNormalizationLayer('Name', 'first14')
    reluLayer('Name', 'first15')];

%Define layers as a structured network
lgraph=layerGraph([layers]);

numClasses =1;
numAnchors = 7;
%Calculation of the anchor boxes necessary for yolov2
trainingDatastore = boxLabelDatastore(Data(:, 2));
[anchorBoxes, meanIoU] = estimateAnchorBoxes(trainingDatastore, numAnchors);
%Scaling of the anchor boxes considering the "accepted" image size
anchorBoxes=floor(anchorBoxes/(3));
%Aggregate the total information to build the yolov2 layers
lgraph = yolov2Layers([120 120 3],numClasses,anchorBoxes,lgraph,'first15');
%Variable which decides parameters of the detector training such as
%learning rate, number of epochs and the sgdm method
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'Verbose',true,'MiniBatchSize',16,'MaxEpochs',80,...
    'Shuffle','every-epoch','VerboseFrequency',50, ...
    'ExecutionEnvironment','auto');

%Picking the random sampling data to train the network
n = randsample(size(Data,1),220);
trainingData=table;
testset=table;
for i=1:size(n)
    trainingData(i, :) = {Data.Var1(n(i)), Data.Var2(n(i))};
end

i=1; j=0;
for i=1:308
    if sum(n==i)==0
      j=j+1;
      testset(j,:) = {Data.Var1(i), Data.Var2(i)};
      disp(i)
    end
end

%Train the network - YOLOv2 detector
[detector,info] = trainYOLOv2ObjectDetector(trainingData,lgraph,options);
%Train the ACF detector
acfDetector = trainACFObjectDetector(Data);

save detector detector
save acfDetector acfDetector
%% SHOW RESULT 
%Choosing an image, including its path
I=imread('dataset/img_10.png');
%Detecting the target, change "detector" to use a specific detector
[bboxes, scores] = detect(detector,I);
%Number of gates detected - n
n=size(bboxes,1);
for i=1:n
 img = insertObjectAnnotation(I,'rectangle',bboxes(i,:),scores(i));
end
figure
imshow(img)


%% CALCULATE THE ROC CURVES

[TPRvector, FPvector,IoU_vector]=ROCcurves(testset);

%% PLOT ROC CURVES
figure
hold on
%Plot the YOLOv2 ROC curves
for i=1:size(IoU_vector,2)
    plot(FPvector(i,:),TPRvector(i,:));
end
%Plot the ACF ROC curve
plot(FPvector(4,:),TPRvector(4,:),'--');
legend('IoU = 0.6 (YOLOv2)','IoU = 0.7 (YOLOv2)','IoU = 0.9 (YOLOv2)','IoU = 0.6 (ACF)', 'Interpreter', 'latex', 'FontSize',12)
ylabel ( 'True Positive Rate' , 'Interpreter', 'latex', 'FontSize',16 ) ; xlabel ( 'Total number of False Positives (normalized)', 'Interpreter', 'latex', 'FontSize',16 );


