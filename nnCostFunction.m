function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size_1, ...
                                   hidden_layer_size_2, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size_1, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
[Theta1, Theta2, Theta3] = total_reshape(nn_params,input_layer_size, hidden_layer_size_1,hidden_layer_size_2,num_labels);
% Setup some useful variables
m = size(X, 1);
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
Theta3_grad = zeros(size(Theta3));




X = [ones(m,1) X];       % Adding the bias unit
a2 = sigmoid(Theta1*X'); % forward propagation

a2 = [ones(1,m); a2];    % Adding the bias unit
a3 = sigmoid(Theta2*a2); % forward propagation

a3 = [ones(1,m); a3];    % Adding the bias unit
a4 = sigmoid(Theta3*a3); % forward propagation

% creating a binary form of the output variable to accomodate the one vs. all paradigm
my_y = zeros(m,num_labels);
for c = 1:num_labels
	my_y(:,c) = (y == c);
end

sum_term = sum(sum(my_y'.*log(a4) + (1 - my_y)'.* log(1-a4)));

% regularisation term, not taking any theta which maps the bias unit
% i.e the 1st columns of theta matrices

regul_term = (lambda/(2*m)) * ( sum(sum(Theta1(:,2:end).^2))+sum(sum(Theta2(:,2:end).^2))+sum(sum(Theta3(:,2:end).^2))); 

J = regul_term - (sum_term/m);

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

for i = 1:m
	a1 = X(i,:)';

	a2 = sigmoid(Theta1*a1);
	a2 = [1; a2];
	
	a3 = sigmoid(Theta2*a2);
	a3 = [1;a3];

	a4 = sigmoid(Theta3*a3);
	del_4 = a4 - my_y(i,:)';

	D_a3 = a3 - a3.*a3;
	del_3 = (Theta3'*del_4);
	del_3 = del_3.*D_a3;
	del_3 = del_3(2:end,:);

	D_a2 = a2 - a2.*a2;
	del_2 = (Theta2'*del_3);
	del_2 = del_2.*D_a2;
	del_2 = del_2(2:end,:);


	Theta1_grad = Theta1_grad .+ del_2*a1';
	Theta2_grad = Theta2_grad .+ del_3*a2';
	Theta3_grad = Theta3_grad .+ del_4*a3';

end

Theta1_grad = Theta1_grad/m + lambda*Theta1/m;
Theta1_grad(:,1) = Theta1_grad(:,1) - lambda*Theta1(:,1)/m;

Theta2_grad = Theta2_grad/m + lambda*Theta2/m;
Theta2_grad(:,1) = Theta2_grad(:,1) - lambda*Theta2(:,1)/m;

Theta3_grad = Theta3_grad/m + lambda*Theta3/m;
Theta3_grad(:,1) = Theta3_grad(:,1) - lambda*Theta3(:,1)/m;

% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:); Theta3_grad(:)];


end
