more off; clear; close all;clc;format long; 
testSet_X = ImportFeat('test.csv',1,100);
fprintf('Welcome. Press enter to continue.\n');
pause;

% testSet_Y = import_target('test.csv',1,100);

my_train = input('Want to train? 1/0 :');
if my_train ~= 1
	{
	Theta1_G1 = csvread('Theta1_G1.csv');
	Theta2_G1 = csvread('Theta2_G1.csv');
	Theta3_G1 = csvread('Theta3_G1.csv');
	}
	
	{
	Theta1_G2 = csvread('Theta1_G2.csv');
	Theta2_G2 = csvread('Theta2_G2.csv');
	Theta3_G2 = csvread('Theta3_G2.csv');
	}

	{
	Theta1_G3 = csvread('Theta1_G3.csv');
	Theta2_G3 = csvread('Theta2_G3.csv');
	Theta3_G3 = csvread('Theta3_G3.csv');
	}

	input_layer_size = size(X)(1,1);
	hidden_layer_size_1 = size(Theta1_G3)(1,2)
	hidden_layer_size_2 = size(Theta2_G3)(1,2)
	num_labels = size(Theta3_G1)(1,2);

elseif my_train == 1

	fprintf('Importing Training Set...\n');
	X = ImportFeat('training.csv',2,550);   % ImportFeat() preprocesses the data and imports
	X = X(:,2:end);
	Y = csvread('training.csv',1,30);
	fprintf('Imported Successfully...\n');
	
	% testSet_X = ImportFeat('test.csv',1,100);

	input_layer_size = size(X)(1,2);
	hidden_layer_size_1 = input('hidden_layer_size_1 ? = ');
	hidden_layer_size_2 = input('hidden_layer_size_2 ? = ');
	num_labels = 20;

	op1 = input('Want to train for G1 ?  -  ');
	op2 = input('Want to train for G2 ?  -  ');
	op3 = input('Want to train for G3 ?  -  ');
	
	options = optimset('Display','iter', 'MaxIter', 10);
	% options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','MaxIter',50);
	lambda = 5;
	
	fprintf('Initializing weights to random values...\n');
	initial_Theta1 = randInitializeWeights(input_layer_size,hidden_layer_size_1);
	initial_Theta2 = randInitializeWeights(hidden_layer_size_1,hidden_layer_size_2);
	initial_Theta3 = randInitializeWeights(hidden_layer_size_2,num_labels);
	initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:); initial_Theta3(:)];
	
	if op1 == 1

		% Create "short hand" for the cost function to be minimized
		costFunction = @(p) nnCostFunction(p, input_layer_size, hidden_layer_size_1, ...
			hidden_layer_size_2,...
			num_labels,...
			X, Y(:,1), lambda);

		fprintf('Now...Training Thetas for G1...\n');
		[nn_params_G1, my_cost] = fminunc(costFunction, initial_nn_params, options)
		fprintf('Training done for G1...\n');
		[Theta1_G1, Theta2_G1, Theta3_G1] = total_reshape(nn_params_G1, input_layer_size, hidden_layer_size_1,hidden_layer_size_2,num_labels);
		csvwrite('Theta1_G1.csv',Theta1_G1);
		csvwrite('Theta2_G1.csv',Theta2_G1);
		csvwrite('Theta3_G1.csv',Theta3_G1);
		
		prdct_G1 = predict(Theta1_G1,Theta2_G1,Theta3_G1,X)
	end

	if op2 == 1

		% Create "short hand" for the cost function to be minimized
		costFunction = @(p) nnCostFunction(p, ...
			input_layer_size, ...
			hidden_layer_size_1, ...
			hidden_layer_size_2, ...
			num_labels,...
			X, Y(:,2), lambda);
		
		fprintf('Training Theta for G2...');
		[nn_params_G2, my_cost] = fminunc(costFunction, initial_nn_params, options);
		fprintf('Training done for G2...');
		[Theta1_G2, Theta2_G2, Theta3_G2] = total_reshape(nn_params_G2,input_layer_size,hidden_layer_size_1,hidden_layer_size_2,num_labels);
		
		csvwrite('Theta1_G2.csv',Theta1_G2);
		csvwrite('Theta2_G2.csv',Theta2_G2);
		csvwrite('Theta3_G2.csv',Theta3_G2);
		
		prdct_G2 = predict(Theta1_G2,Theta2_G2,Theta3_G2,X);
	end
	if op3 == 1

		costFunction = @(p) nnCostFunction(p, ...
			input_layer_size, ...
			hidden_layer_size_1, ...
			hidden_layer_size_2, ...
			num_labels,...
			X, Y(:,3), lambda);
		
		fprintf('Training Theta for G2...');
		[nn_params_G3, my_cost] = fminunc(costFunction, initial_nn_params, options);
		fprintf('Training done for G3...');
		[Theta1_G3, Theta2_G3, Theta3_G3] = total_reshape(nn_params_G3,input_layer_size,hidden_layer_size_1,hidden_layer_size_2,num_labels);
		
		csvwrite('Theta1_G3.csv',Theta1_G3);
		csvwrite('Theta2_G3.csv',Theta2_G3);
		csvwrite('Theta3_G3.csv',Theta3_G3);
		
		prdct_G3 = predict(Theta1_G3,Theta2_G3,Theta3_G3,testSet_X);
	end
end

prdct = [prdct_G1, prdct_G2, prdct_G3];




csvwrite('output.csv',prdct);

% for i=1:3
% 	figure(i)
% 	plot(prdct(:,i), '-rs','MarkerFaceColor','r');
% 	hold on;
% 	xlabel('Data Set No.')
% 	if i==1
% 		ylabel('Score in G1')
% 	else if i == 2
% 		ylabel('Score in G2')
% 	else if i  == 3
% 		ylabel('Score in G3')
% 	end
% end

% end
% end