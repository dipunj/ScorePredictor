%% ================== About the Program ===================================
% Team Name :: The Layman Brothers
% Input     :: All 30 features, training sets.
% Output    :: Prediction of scores in three Subjects G1, G2 & G3 and their
%              actual values
% Method    :: Feature-Scaled MultiVariate Linear Regression using Gradient-Descent

%% ================== Initialising the program ====================================
 clear; close all;clc;
 format long;
 fprintf('Please wait...Training Under Process...\n');

 

%% ================== Importing Data Into the workspace ===========================
% The data is already preprocessed
 target_G = import_target('training.csv',2,549);
% Entries in ith row are the ith training set and every column represents a feature(and its values for the ith training set)
 feature_X = ImportFeat('training.csv',2,549);

 
 
%% ================== Dimensions of the Modified Feature matrix ============================
 dim = size(feature_X);
% Size of the training set
 m = dim(:,1);
% The number of features in modified (incremented feature vector)
 n = dim(:,2);

 
%% ========================= Feature Scaling for Age ==========================================
ctr = 1;
for i=[4,8:13,25:31]
    expo(feature_X,i,ctr+1);
    Scaling(feature_X,feature_X,i,m);
    ctr = ctr + 1;
end

%% ========================= Gradient Descent ================================================
theta_G = zeros(n,3);
% for better reprogramability lambda has been made available
% put lambda = [0,0,0] for non regularised model
lambda = [-10,-10,20];
alpha = 0.001;


for i=1:3
    while(1)
        hypo = feature_X*theta_G(:,i);
        temp = (1-(alpha*lambda(i)/m))*theta_G(:,i) - (alpha/m)*(feature_X'*(hypo - target_G(:,i)));
        
        if ((cost(temp,target_G(:,i),feature_X,lambda(i)) - cost(theta_G(:,i),target_G(:,i),feature_X,lambda(i)))^2 < 0.0000000000001)
            break
        end
        theta_G(:,i) = temp;
    end
end




%% ============= Importing Test Data For Testing the Trained Model ================================
 %t_G = import_target('test.csv',1,100);
 t_feat = ImportFeat('test.csv',1,100);
 size_t_feat = size(t_feat);
 
%% ================= Scaling the Age Column in new input ===========================================
ctr = 1;
for i=[4,8:13,25:31]
    expo(t_feat,i,ctr+1);
    Scaling(t_feat,feature_X, i ,m);
    ctr = ctr + 1;
end
 
%% ========================= Predicting the Scores =============================================
 prdct_G = [t_feat*theta_G(:,1),t_feat*theta_G(:,2),t_feat*theta_G(:,3)];
 
%% ================ Exporting answers to 'output.csv' ======================================
 myans = [prdct_G(:,1),prdct_G(:,2),prdct_G(:,3)];
 csvwrite('output.csv',myans);
 csvwrite('classifier.csv',theta_G);
 
 for i=1:3
        figure(i)
            plot(prdct_G(:,i), '-rs','MarkerFaceColor','r');
            hold on;
            xlabel('Data Set No.')
            if i==1
                ylabel('Score in G1')
                    else if i == 2
                        ylabel('Score in G2')
                            else if i  == 3
                                 ylabel('Score in G3')
                                end
                        end
            end
 end
  
 %% ================ Mean Absolute error - command window respectively for G1 G2 G3 ========
% for i=1:3 
%   Mean_Abs_Error(:,i) = sum(abs(prdct_G(:,i) - t_G(:,i)))/(size_t_feat(1,1));
% end
% fprintf('\n The mean absolute error for G1,G2,G3 respectively are\n')
% Mean_Abs_Error
%% ================ Plot for the known but unused test cases ===============================
% PlotFig(prdct_G,t_G);

fprintf('\tTRAINING FINISHED\nPlease Check output.csv and classifier.csv \n in pwd for output and parameter list respectively for \n\t 1st column = G1\n\t 2nd Column = G2\n\t 3rd Column = G3\n');