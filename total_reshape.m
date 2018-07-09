%% total_reshape: Reshapes nn_params into Theta1,Theta2,Theta3
function [Theta1,Theta2,Theta3] = total_reshape(nn_params,input_layer_size,hidden_layer_size_1,hidden_layer_size_2,num_labels)
	temp = hidden_layer_size_1 * (input_layer_size + 1);
	Theta1 = reshape(nn_params(1 : temp), hidden_layer_size_1, (input_layer_size + 1));
	
	temp2 = hidden_layer_size_2 * (hidden_layer_size_1 + 1);
	Theta2 = reshape(nn_params(temp + 1: temp + temp2 ), hidden_layer_size_2, (hidden_layer_size_1 + 1));
	
	temp3 = temp + temp2;
	Theta3 = reshape(nn_params(1 + temp3 : end), num_labels, (hidden_layer_size_2 + 1));
end