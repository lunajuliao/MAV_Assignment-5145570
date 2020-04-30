The code contains different functions which are also in here such as the dataprocessing, dimension, IoUvalues and ROCcurves.
These functions are called in the file yolo.m, the main file, which runs completing all the data processing, training, detection and ROCcurves tasks.
However, together in this folder there are already two trained detectors, which can be loaded avoiding the waiting for the training:
1 - yolov2 detector : detector
2 - ACF detector : acfdetector

In order to access the dataset, please fill with your own image path.
