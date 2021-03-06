% Code is a very slight variation of the edgeBoxesDemo.m created by Piotr
% Dollar. All copyrights are given to him. 
% Updated by: Mohamed El Banani
% Date: December 1, 2016
%
% A function to generate the bounding boxes from a folder containing a set 
% of images. The output bounding boxes are written into a text file where
% each line contains a proposal of [x_tl, y_tl, w, h, conf]. The parameters
% for the function are
%     * folderPath    The path to the folder containing the images
%     * imageType     Image format 
%     * outputPath    Output folder path for the text files
    
function [] = datasetBoxes(folderPath, imageType, outputPath)

%% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .65;     % step size of sliding window search
opts.beta  = .75;     % nms threshold for object proposals
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 300;  % max number of boxes to detect

%% detect Edge Box bounding box proposals (see edgeBoxes.m)
images = dir(fullfile(folderPath, ['*.', imageType]));
formatSize = size(imageType, 2);
outputPath = [outputPath, '/bboxes'];
mkdir(outputPath);

tic;

for i = 1:size(images,1)
    disp(['Image ', num2str(i), ' of ', num2str(size(images,1))]);
    I = imread([images(i).folder, '/', images(i).name]);
    bbs=edgeBoxes(I,model,opts);
    csvwrite([outputPath, '/', images(i).name(1:end-formatSize), 'csv'], bbs);
end

time = toc;
numImages = size(images,1);
avgTime = time/numImages;
disp('-------------------------------------------------');
disp('Overall Statistics');
disp('------------------');
disp(['Dataset Size:                ', num2str(numImages)]);
disp(['Image Size:                  ', num2str(size(I, 1)), 'x', num2str(size(I, 2))]);
disp(['#Boxes/Image:                ', num2str(opts.maxBoxes)]);
disp(['Minimum Conf Score:          ', num2str(opts.minScore)]);
disp(['Total Detection Time:        ', num2str(time)]);
disp(['Average Detection Time:      ', num2str(avgTime)]);
disp('-------------------------------------------------');


end



% %% show evaluation results (using pre-defined or interactive boxes)
% gt=bbs;
% if(0), gt='Please select an object box.'; disp(gt); figure(1); imshow(I);
%   title(gt); [~,gt]=imRectRot('rotate',0); gt=gt.getPos(); end
% gt(:,5)=0; [gtRes,dtRes]=bbGt('evalRes',gt,double(bbs),.7);
% figure(1); bbGt('showRes',I,gtRes,dtRes(dtRes(:,6)==1,:));
% title('green=matched gt  red=missed gt  dashed-green=matched detect');
% 
% %% run and evaluate on entire dataset (see boxesData.m and boxesEval.m)
% if(~exist('boxes/VOCdevkit/','dir')), return; end
% split='val'; data=boxesData('split',split);
% nm='EdgeBoxes70'; opts.name=['boxes/' nm '-' split '.mat'];
% edgeBoxes(data.imgs,model,opts); opts.name=[];
% boxesEval('data',data,'names',nm,'thrs',.7,'show',2);
% boxesEval('data',data,'names',nm,'thrs',.5:.05:1,'cnts',1000,'show',3);
