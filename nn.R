# sigmoidGradient.m - Compute the gradient of the sigmoid function
# randInitializeWeights.m - Randomly initialize weights
# nnCostFunction.m - Neural network cost function


#Setup the parameters you will use for this exercise
input_layer_size<-400   # 20x20 Input Images of Digits
hidden_layer_size<-25   # 25 hidden units
num_labels<-10          # 10 labels, from 1 to 10 
nn_params<-NULL         # a vector of unrolled thetas
lambda<-0


X<-nn_data[["X"]]
y<-nn_data[["y"]]

#function [J grad] = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, num_labels, X, y, lambda)

Theta1<-nn_weights[[1]]
Theta2<-nn_weights[[2]]

nn_params = c(as.vector(Theta1),as.vector(Theta2))


nnCostFunction<-function(nn_params, input_layer_size, hidden_layer_size, num_labels, X, y, lambda){
 
    m<-dim(X)[1]
    y_matrix<-matrix(0,nrow=m,ncol=num_labels)
    
    
    for(i in seq_len(m)){
      y_matrix[i,y[i]]<-1
    }
    
    a1<-cbind(matrix(1,nrow=m,ncol=1),X) # add ones 5000x401
    z2<-a1%*%t(Theta1)                            #5000x25
    a2<-cbind(matrix(1,nrow=m,ncol=1),sigmoid(z2)) #5000x26
    z3<-a2%*%t(Theta2)                            #5000x10
    a3<-sigmoid(z3)                               #5000x10 no bias for last layer
    
    # Cost function
    reg_component<-(lambda/(2*m))*(sum(Theta1[,-1]^2)+sum(Theta2[,-1]^2))
    
    J<-(1/m)*sum(-y_matrix*log(a3)-(1-y_matrix)*log(1-a3))+reg_component
    
    # gradients
    
    #d3<-a3-y_matrix
  
}

#regularization component


J<-nnCostFunction(nn_params, input_layer_size, hidden_layer_size, num_labels, X, y, lambda=1)
J







