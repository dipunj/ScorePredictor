clear; close all;clc;format long;

fprintf('Program paused. Press enter to continue.\n');
pause;

X = ImportFeat('training.csv',2,549);   % ImportFeat() preprocesses the data and imports
Y = import_target('training.csv',2,549);

testSet_X = ImportFeat('test.csv',1,100);
testSet_Y = import_target('test.csv',1,100);

Theta1_G1 = csvread('Theta1_G1.csv');
hidden_layer_size_1 = size(Theta1_G1)(1,2);
Theta2_G1 = csvread('Theta2_G1.csv');
hidden_layer_size_2 = size(Theta2_G1)(1,2);
Theta3_G1 = csvread('Theta3_G1.csv');
num_labels = size(Theta3_G1)(1,2);

Theta1_G2 = csvread('Theta1_G2.csv');
hidden_layer_size_1 = size(Theta1_G2)(1,2);
Theta2_G2 = csvread('Theta2_G2.csv');
hidden_layer_size_2 = size(Theta2_G2)(1,2);
Theta3_G2 = csvread('Theta3_G2.csv');

Theta1_G3 = csvread('Theta1_G3.csv');
hidden_layer_size_1 = size(Theta1_G3)(1,2);
Theta2_G3 = csvread('Theta2_G3.csv');
hidden_layer_size_2 = size(Theta2_G3)(1,2);
Theta3_G3 = csvread('Theta3_G3.csv');

train = 1;
if train == 1
	options = optimset('MaxIter', 100);
	lambda = 5;
	
	op1 = disp('Want to train for G1');
	op2 = disp('Want to train for G2');
	op3 = disp('Want to train for G3');
	if op1 == 1
		initial_Theta1_G1 = randInitializeWeights(input_layer_size, hidden_layer_size_1);
		initial_Theta2_G1 = randInitializeWeights(hidden_layer_size_1, hidden_layer_size_2);
		initial_Theta3_G1 = randInitializeWeights(hidden_layer_size_2, num_labels);
		initial_nn_params = [initial_Theta1_G1(:) ; initial_Theta2_G1(:); initial_Theta3_G1(:)];
		
		% Create "short hand" for the cost function to be minimized
		costFunction = @(p) nnCostFunction(p, ...
			input_layer_size, ...
			hidden_layer_size_1, ...
			hidden_layer_size_2, ...
			num_labels,...
			X, Y(:,1), lambda);
		
		% costFunction is a function that takes in only one argument (the
		% neural network parameters)
		[nn_params_G1, cost] = fminunc(costFunction, initial_nn_params, options);
		[Theta1_G1, Theta2_G1, Theta3_G1] = total_reshape(nn_params_G1,hidden_layer_size_1,hidden_layer_size_2,num_labels)
	end
	if op2 == 1
		initial_Theta1_G2 = randInitializeWeights(input_layer_size, hidden_layer_size_1);
		initial_Theta2_G2 = randInitializeWeights(hidden_layer_size_1, hidden_layer_size_2);
		initial_Theta3_G2 = randInitializeWeights(hidden_layer_size_2, num_labels);
		initial_nn_params = [initial_Theta1_G2(:) ; initial_Theta2_G2(:); initial_Theta3_G2(:)];
		
		% Create "short hand" for the cost function to be minimized
		costFunction = @(p) nnCostFunction(p, ...
			input_layer_size, ...
			hidden_layer_size_1, ...
			hidden_layer_size_2, ...
			num_labels,...
			X, Y(:,2), lambda);
		
		% costFunction is a function that takes in only one argument (the
		% neural network parameters)
		[nn_params_G2, cost] = fminunc(costFunction, initial_nn_params, options);
		[Theta1_G2, Theta2_G2, Theta3_G2] = total_reshape(nn_params_G2,hidden_layer_size_1,hidden_layer_size_2,num_labels);
	end
	if op3 == 1
		initial_Theta1_G3 = randInitializeWeights(input_layer_size, hidden_layer_size_1);
		initial_Theta2_G3 = randInitializeWeights(hidden_layer_size_1, hidden_layer_size_2);
		initial_Theta3_G3 = randInitializeWeights(hidden_layer_size_2, num_labels);
		initial_nn_params = [initial_Theta1_G3(:) ; initial_Theta2_G3(:); initial_Theta3_G3(:)];
		
		% Create "short hand" for the cost function to be minimized
		costFunction = @(p) nnCostFunction(p, ...
			input_layer_size, ...
			hidden_layer_size_1, ...
			hidden_layer_size_2, ...
			num_labels,...
			X, Y(:,3), lambda);
		
		% costFunction is a function that takes in only one argument (the
		% neural network parameters)
		[nn_params_G3, cost] = fminunc(costFunction, initial_nn_params, options);
		[Theta1_G3, Theta2_G3, Theta3_G3] = total_reshape(nn_params_G3,hidden_layer_size_1,hidden_layer_size_2,num_labels)
	end
end

prdct_G1 = predict(Theta1_G1,Theta2_G1,Theta3_G1,X);
prdct_G2 = predict(Theta1_G2,Theta2_G2,Theta3_G2,X);
prdct_G3 = predict(Theta1_G3,Theta2_G3,Theta3_G3,X);
prdct = [prdct_G1, prdct_G2, prdct_G3];



csvwrite('Theta1_G1.csv',Theta1_G1);
csvwrite('Theta2_G1.csv',Theta2_G1);
csvwrite('Theta3_G1.csv',Theta3_G1);

csvwrite('Theta1_G2.csv',Theta1_G2);
csvwrite('Theta2_G2.csv',Theta2_G2);
csvwrite('Theta3_G2.csv',Theta3_G2);

csvwrite('Theta1_G3.csv',Theta1_G3);
csvwrite('Theta2_G3.csv',Theta2_G3);
csvwrite('Theta3_G3.csv',Theta3_G3);

csvwrite('output.csv',prdct);

for i=1:3
	figure(i)
	plot(prdct(:,i), '-rs','MarkerFaceColor','r');
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


% % ================ Mean Absolute error - command window respectively for G1 G2 G3 ========
% for i=1:3 
%   Mean_Abs_Error(:,i) = sum(abs(prdct_G(:,i) - t_G(:,i)))/(size_t_feat(1,1));
% end
% fprintf('\n The mean absolute error for G1,G2,G3 respectively are\n')
% Mean_Abs_Error
% % ================ Plot for the known but unused test cases ==============================
% PlotFig(prdct_G,t_G);

fprintf('\tTRAINING FINISHED\nPlease Check output.csv and classifier.csv \n in pwd for output and parameter list respectively for \n\t 1st column = G1\n\t 2nd Column = G2\n\t 3rd Column = G3\n');