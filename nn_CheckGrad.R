X<-nn_data[["X"]]
y<-nn_data[["y"]]

#function [J grad] = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, num_labels, X, y, lambda)

Theta1<-nn_weights[[1]]
Theta2<-nn_weights[[2]]

nn_params = c(as.vector(Theta1),as.vector(Theta2))


Theta1<-matrix(
  nn_params[1:(hidden_layer_size*(input_layer_size+1))],
  nrow=hidden_layer_size,
  ncol=(input_layer_size+1))

Theta2<-matrix(
  nn_params[(1+hidden_layer_size*(input_layer_size+1)):(length(nn_params)-(hidden_layer_size+1)*num_labels)],
  nrow=hidden_layer_size,
  ncol=(hidden_layer_size+1))


Theta3<-matrix(
  nn_params[(1+length(nn_params)-(hidden_layer_size+1)*num_labels):length(nn_params)],
  nrow=num_labels,
  ncol=(hidden_layer_size+1))



> 401*20+21*20+21*10
[1] 8650

hidden_layer_size<-20
input_layer_size<-400
num_labels<-10
num_layers<-2

nn_params<-rnorm(8650)

########################################### gradiend checking #######################################



checkNNGradients<-function(costFunc,input_layer_size, hidden_layer_size, num_layers=2,num_labels, X, y, lambda=0){
  grad<-costFunc("grad")
  J<-costFunc("J")
  
  
  if(num_layers==2) {nn_params<-rnorm((input_layer_size+1)*hidden_layer_size+(hidden_layer_size+1)*hidden_layer_size+(hidden_layer_size+1)*num_labels)
  } else {
    nn_params<-rnorm((input_layer_size+1)*hidden_layer_size+(hidden_layer_size+1)*num_labels)}
  
  #
  g_analytical<-grad(nn_params=nn_params, input_layer_size=input_layer_size, hidden_layer_size=hidden_layer_size, num_labels=num_labels, X=X, y=y, lambda=lambda)
  l<-length(g_analytical)
  
  e<-1e-4
  g_numeric<-vector(mode="numeric",length=10)
  
  for (i in 1:10){
    e_vector<-rep(0,l)
    e_vector[i]<-e
    nn_param_plus<-nn_params+e_vector
    nn_param_minus<-nn_params-e_vector
    JP<-J(nn_param_plus, input_layer_size=input_layer_size, hidden_layer_size=hidden_layer_size, num_labels=num_labels, X=X, y=y, lambda=lambda)
    JM<-J(nn_param_minus, input_layer_size=input_layer_size, hidden_layer_size=hidden_layer_size, num_labels=num_labels, X=X, y=y, lambda=lambda)
    g_numeric[i]<-(JP-JM)/(2*e)
    
  }
  rbind(Numeric=g_numeric,Analytical=g_analytical[1:10])
}

########################################### Testing ######################################################
tt3<-checkNNGradients(costFunc=nnCostFunction3, input_layer_size=400, hidden_layer_size=20, num_layers=2,num_labels=10, X, y, lambda=1)
tt3

tt<-checkNNGradients(costFunc=nnCostFunction, input_layer_size=400, hidden_layer_size=20, num_layers=1,num_labels=10, X, y, lambda=1)
tt


