# randInitializeWeights.m - Randomly initialize weights
# nnCostFunction.m - Neural network cost function
source("CommonML.R")  # sigmoid 
                      # sigmoidGradient functions
                      # ones_zeros: create matrix of 1 or 0 based on a size of another matrix

#Setup the parameters you will use for this exercise
# input_layer_size<-400   # 20x20 Input Images of Digits
# hidden_layer_size<-25   # 25 hidden units
# num_labels<-10          # 10 labels, from 1 to 10 
# nn_params<-NULL         # a vector of unrolled thetas
# lambda<-0
# 
# 
# X<-nn_data[["X"]]
# y<-nn_data[["y"]]

################################# Cost Function ##############################################
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
    
    Theta1_grad<-(1/m)*(t(d2)%*%a1+lambda*Theta1*Theta1_adj)
    Theta2_grad<-(1/m)*(t(d3)%*%a2+lambda*Theta2*Theta2_adj)
    
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
################################# Random weights ##############################################

randInitializeWeights<-function(L_in,L_out){ # Layer in and Layer out supplied
  epsilon_init<-0.12
  W<-runif(L_out*(L_in+1))*2*epsilon_init-epsilon_init
  W<-matrix(W,ncol=(L_in+1),nrow=L_out)
}

################################# Main NN wrapper #############################################

nn<-function(X,y,hidden_layer_size, num_labels,lambda=0,method="BFGS"){
  input_layer_size<-dim(X)[2]
  # initialize values
  initial_Theta1<-randInitializeWeights(input_layer_size,hidden_layer_size)
  initial_Theta2<-randInitializeWeights(hidden_layer_size,num_labels)
  #unroll Thetas
  nn_params<-c(as.vector(initial_Theta1),as.vector(initial_Theta2))
  # Create closers
  J<-nnCostFunction("J")
  grad<-nnCostFunction("grad")
  # RUN Optimization
  res<-optim(nn_params,J,grad,X,y,input_layer_size=input_layer_size, hidden_layer_size=hidden_layer_size, num_labels=num_labels,lambda=lambda, method=method)
  # Reshape back to matrix
  Theta1_hat<-matrix(
    res$par[1:(hidden_layer_size*(input_layer_size+1))],
    nrow=hidden_layer_size,
    ncol=(input_layer_size+1))
  
  Theta2_hat<-matrix(
    res$par[(1+hidden_layer_size*(input_layer_size+1)):length(nn_params)],
    nrow=num_labels,
    ncol=(hidden_layer_size+1))
  # Result
  out<-list(Theta1_hat=Theta1_hat,Theta2_hat=Theta2_hat)
}

################################# Predict_NN ##################################################

predict_nn<-function(nn_model, X){ # nn_model is the list of Thetas produced by nn function
  m<-dim(X)[1]
  num_layers<-length(nn_model)
  h1<-sigmoid(cbind(matrix(1,nrow=m,ncol=1),X)%*%t(nn_model[[1]]))
  h2<-sigmoid(cbind(matrix(1,nrow=m,ncol=1),h1)%*%t(nn_model[[2]]))
  p<-apply(h2,1,which.max)
}





#### test temp #############


tt<-nn(X,y, hidden_layer_size=25, num_labels=10,lambda=1,method="BFGS")


table(predict_nn(tt, X))
table(predict_nn(tt, X)==y)
