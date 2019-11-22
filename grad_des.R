
df_prices

X1<-as.matrix(df_prices[c("footage","bedroom")])
y1<-as.matrix(df_prices["price"])

# compute cost

computeCost<-function(X, y, theta){
  X<-as.matrix(X)
  y<-as.matrix(y)
  #have validation for numeric vector
  theta<-as.matrix(theta)
  
  m<-dim(X)[1]
  X<-cbind(rep(1,m),X)
  J<-1/(2*m)*sum((X%*%theta-y)^2)
  
  
}

m1<-lm(y1~X1)
theta<-matrix(m1$coefficients,byrow = F)



J<-computeCost(X1,y1,theta)

print(J)
x mxn
theta nx1
y mx1

# compute cost
# unlike computeCost, computeCost2 does not add column of 1 for the intercept as this is hanled by gd function in the same way as stat::lm does

computeCost2<-function(X, y, theta){
  X<-as.matrix(X)
  y<-as.matrix(y)
  theta<-as.matrix(theta)
  # m<-dim(X)[1]
  # X<-cbind(rep(1,m),X)
  J<-1/(2*m)*sum((X%*%theta-y)^2)
}

gradientDescentMulti<-function(X, y, theta, alpha, num_iters){
  J_history<-vector(mode = "numeric", length = num_iters)
  m<-nrow(X)
  for(i in seq_len(num_iters)){
    theta<-theta-alpha/m*(t(X)*(X%*%theta-y))
    J_history[i]<-computeCost2(X, y, theta)
  }
  J_history
}
  
 tt<-gradientDescentMulti (X1,y1,theta[1:2,1],.05,20)
   
 t(X1) * (X1 %*% theta[1:2,1] - y1)
 dim(t(X1))
 dim(theta)
 
[theta, J_history]