clc;
clear all;
close all;
warning off;
addpath('subcodes');

%% INITIALIZATION

SearchAgents_no=30;
N=10;  
Function_name='F1'; 
Fun_name='F10';
Max_iter=200; 
Total_run=10;  
NumberofBrownBears=30; 
D=30; 
Min=ones(1,D)*(-100); 
Max=ones(1,D)*(100); 
%% LOAD INPUT DATASET

myFolder = 'F:\Nisha\Nisha\2024\Rooks projcts\project5(kidney2)\kidney2code\US image kidney dataset\maincode';
filePattern = fullfile(myFolder, '*.png');
jpegFiles = dir(filePattern);
for k = 1:length(jpegFiles)
  baseFileName = jpegFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  imageArray = imread(fullFileName);
  imshow(imageArray);                        
  drawnow;                             
end
[I,path]=uigetfile('*.png','select a input image');
str=strcat(path,I);
s=imread(str);
figure;
imshow(s);                                                                                                                                                                                                                                                                                                     
title('Input Image');
image = im2double(s(:,:,1));
H1 = fspecial('gaussian',21,15);
H2 = fspecial('gaussian',21,20);
dog = H1 - H2;
dogFilterImage1 = conv2(image,dog,'same');
figure;
imshow(dogFilterImage1,[]);
title('Preprocessed Image');

%% SEGMENTATION
s = imbinarize(rgb2gray(s));
mask = zeros(size(s));
mask(25:end-25,25:end-25) = 1;
bw = activecontour(s,mask,200);
figure;
subplot(1,2,1);
imshow(mask);
title('Initial contour','200 iterations');
subplot(1,2,2);
imshow(bw)
title('Segmented Image');
sgtitle('Segmentation');
biggestBlob=bw;
[f1,f2,f3,f4,f5,f6,f7,f8,f9,f10]=agglomerative(bw);
F_f=[f1,f2,f3,f4,f5,f6,f7,f8,f9,f10];
F_Feature=Needleman(biggestBlob,F_f);    
 
  %% CLASSIFICATION & OPTIMIZATION
  
trainFcn = 'trainlm';  
Inpnn=[F_Feature];
%Train the networks
for i=1:100                                        %vary number of hidden layer neurons from 1 to 100
    hiddenLayerSize = i;                           %number of hidden layer neurons
    net = fitnet(hiddenLayerSize,trainFcn);        %create a fitting network
    net.divideParam.trainRatio = 70/100;           %use 70% of data for training 
    net.divideParam.valRatio = 15/100;             %15% for validation
    net.divideParam.testRatio = 15/100;            %15% for testing
end

[lb,ub,dim,fobj]=Get_Functions_detail(Fun_name);
[Best_score,Best_pos,GWO_cg_curve]=GWO(SearchAgents_no,Max_iter,lb,ub,dim,fobj);
display(['The best solution obtained by GWO is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by GWO is : ', num2str(Best_score)]);

[lb,ub,dim,fobj]=Get_Functions_details(Function_name);
[bestfit,BestPositions,fmax,Gir_Cg_curve]=Gir(N,Max_iter,lb,ub,dim,fobj);
display(['The best solution obtained by GOA is : ', num2str(BestPositions)]);
display(['The best optimal value of the objective funciton found by GOA is : ', num2str(bestfit)]);

[Best_score,Best_pos,cg_curve]=ALO(SearchAgents_no,Max_iter,lb,ub,dim,fobj);
display(['The best solution obtained by ALO is : ', num2str(Best_pos)]);
display(['The best optimal value of the objective funciton found by ALO is : ', num2str(Best_score)]);

for ii=1:Total_run
[Best_sol(ii),Best_X(ii,:),Convergence(ii,:)]=BOA(NumberofBrownBears,D,Max_iter,Min,Max);
end

Std_dev=std(Best_sol);
Mean_score=min(Best_sol);
[gBest_sol, idx]=min(Best_sol);
gBest_X=Best_X(idx,:);
gConvergence=Convergence(idx,:); 
clear idx;

figure;
semilogy(Gir_Cg_curve,'-r','linewidth',2);
hold on
semilogy(GWO_cg_curve,'-g','linewidth',2);
ylim([1 100]);
hold on
semilogy(gConvergence(1,2:end),'k','LineWidth',2);
hold on
semilogy(cg_curve,'-b','linewidth',2);
title('Objective space')
xlabel('iteration');
ylabel('Best Solution');
axis tight
grid on
box on
legend('GOA','GWO','BBO','ALO')
multiclass(biggestBlob);

%% PERFORMANCE ANALYSIS
Tarnn = ones(size(Inpnn,1),1);
[Acc,sensitivity,specificity,f1score]= Res50Classification(Inpnn,Tarnn);
disp('%%% ===== CNN(Resnet 50)Classifier PERFORMANCE=====%%%')
disp([' Accuracy = ' num2str(Acc)])
disp([' Precision = ' num2str(sensitivity)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])

[Acc,sensitivity,specificity,f1score]= CNNclassification(Inpnn,Tarnn);
disp('%%% ===== CNN Classifier PERFORMANCE=====%%%')
disp([' Accuracy = ' num2str(Acc)])
disp([' Precision = ' num2str(sensitivity)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])
[precision,specificity,Acc,f1score] = DeepLearning(Inpnn,Tarnn);

disp('========= Performance Analysis of DNN ========')
disp([' Accuracy = ' num2str(Acc)])
disp([' Precision = ' num2str(precision)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])

[precision,specificity,Acc,f1score]= ANN(Inpnn,Tarnn);
disp('========= Performance Analysis of ANN ========')
disp([' Accuracy = ' num2str(Acc)])
disp([' Precision = ' num2str(precision)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])

[Acc,precision,specificity,f1score] = NNClass(Inpnn,Tarnn);
disp('========= Performance Analysis of kNN ========')
disp([' Accuracy = ' num2str(Acc)])
disp([' Precision = ' num2str(precision)])
disp([' Specificity = ' num2str(specificity)])
disp([' F1 score = ' num2str(f1score)])