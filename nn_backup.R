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


nnCostFunction<-function(type){
  function(nn_params, input_layer_size, hidden_layer_size, num_labels, X, y, lambda){
 
    
#Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices for our 2 layer neural network    
    Theta1<-matrix(
      nn_params[1:(hidden_layer_size*(input_layer_size+1))],
      nrow=hidden_layer_size,
      ncol=(input_layer_size+1))
    
    Theta2<-matrix(
      nn_params[(1+hidden_layer_size*(input_layer_size+1)):length(nn_params)],
      nrow=num_labels,
      ncol=(hidden_layer_size+1))
    
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
    
    # COST FUNCTION
    reg_component<-(lambda/(2*m))*(sum(Theta1[,-1]^2)+sum(Theta2[,-1]^2))
    
    J<-(1/m)*sum(-y_matrix*log(a3)-(1-y_matrix)*log(1-a3))+reg_component
    
    # GRADIENTS
    # ANg - 2.2 For each output unit k in layer 3 (the output layer), set
    d3<-a3-y_matrix
    # ANg - 2.3 For the hidden layer l = 2, set
    d2<-d3%*%Theta2*sigmoidGradient(cbind(matrix(1,nrow=m,ncol=1),z2))
    # ANg - 2.4 Accumulate the gradient from this example using the following formula. Note that you should skip or remove do(2) (d2(0))
    d2<-d2[,-1]
    
    #constant adjustment matricies. this way no need for separate gradients for i=0 and i=1...k
    Theta1_adj<-ones_zeros(1,dim(Theta1))
    Theta1_adj[,1]=0
    
    Theta2_adj<-ones_zeros(1,dim(Theta2))
    Theta2_adj[,1]=0
    
    Theta1_grad=(1/m)*(t(d2)%*%a1+lambda*Theta1*Theta1_adj)
    Theta2_grad=(1/m)*(t(d3)%*%a2+lambda*Theta2*Theta2_adj)
    
    grad<-c(as.vector(Theta1_grad),as.vector(Theta2_grad))
    
    
    if(type=="J"){
      J
    }
    else if(type=="grad"){
      grad
    }
    else stop("Invalid output request from CostGradient: acceptable values are: 'J' and 'grad'")

  }
}

# initialize random

randInitializeWeights<-function(L_in,L_out){
  epsilon_init<-0.12
  W<-runif(L_out*(L_in+1))*2*epsilon_init-epsilon_init
  W<-matrix(W,ncol=(L_in+1),nrow=L_out)
}




nn<-function(X,y,input_layer_size, hidden_layer_size, num_labels,lambda=0,method="L-BFGS-B"){
  initial_Theta1<-randInitializeWeights(input_layer_size,hidden_layer_size)
  initial_Theta2<-randInitializeWeights(hidden_layer_size,num_labels)
  initial_nn_params<-c(as.vector(initial_Theta1),as.vector(initial_Theta2))
  
  J<-nnCostFunction("J")
  grad<-nnCostFunction("grad")
  
  res<-optim(initial_nn_params,J,grad,X,y,input_layer_size, hidden_layer_size, num_labels,lambda=0,method="L-BFGS-B")
  
  Theta1_hat<-matrix(
    res$par[1:(hidden_layer_size*(input_layer_size+1))],
    nrow=hidden_layer_size,
    ncol=(input_layer_size+1))
  
  Theta2_hat<-matrix(
    res$par[(1+hidden_layer_size*(input_layer_size+1)):length(nn_params)],
    nrow=num_labels,
    ncol=(hidden_layer_size+1))
  out<-list(Theta1_hat,Theta2_hat)
}


predict_nn<-function(Theta1, Theta2, X){
  m<-dim(X)[1]
  h1<-sigmoid(cbind(matrix(1,nrow=m,ncol=1),X)%*%t(Theta1))
  h2<-sigmoid(cbind(matrix(1,nrow=m,ncol=1),h1)%*%t(Theta2))
  p<-apply(h2,1,which.max)
}


################ testing local ###############

tt<-nn(X,y,input_layer_size=400, hidden_layer_size=5, num_labels=10,method="BFGS")

tt2<-predict_nn(tt[[1]], tt[[2]], X)
table(tt2)

# J<-nnCostFunction("J")
# grad<-nnCostFunction("grad")
# 
# initial_nn_params<-rnorm(10285)
# res<-optim(initial_nn_params,J,grad,X=X,y=y,input_layer_size=400, hidden_layer_size=25, num_labels=10,lambda=0,method="L-BFGS-B")
# 
# 
# Theta1_hat<-matrix(
#   res$par[1:(hidden_layer_size*(input_layer_size+1))],
#   nrow=hidden_layer_size,
#   ncol=(input_layer_size+1))
# 
# Theta2_hat<-matrix(
#   res$par[(1+hidden_layer_size*(input_layer_size+1)):length(nn_params)],
#   nrow=num_labels,
#   ncol=(hidden_layer_size+1))
# 
# 
# 
# tt<-predict_nn(Theta1_hat, Theta2_hat, X)
# 
# # tt<-matrix(
# # nn_params[1:(hidden_layer_size*(input_layer_size+1))],
# # nrow=hidden_layer_size,
# # ncol=(input_layer_size+1))
# # 
# # identical(Theta1,tt)
# # 
# # Theta1[1:5,1:5]
# # tt[1:5,1:5]
# # 
# # tt<-matrix(
# #   nn_params[(1+hidden_layer_size*(input_layer_size+1)):length(nn_params)],
# #   nrow=num_labels,
# #   ncol=(hidden_layer_size+1))
# # 
# # identical(Theta2,tt)
# 
# # Theta2[1:5,1:5]
# # tt[1:5,1:5]
