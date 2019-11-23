
# compute cost
# unlike computeCost, computeCost2 does not add column of 1 for the intercept as this is hanled by gd function in the same way as stat::lm does

computeCost2<-function(X, y, theta){
  # X<-as.matrix(X)
  # y<-as.matrix(y)
  # theta<-as.matrix(theta)
  m<-dim(X)[1]
  # X<-cbind(rep(1,m),X)
  J<-(1/(2*m))*sum((X%*%theta-y)^2)
}

gradientDescentMulti<-function(X, y, theta, alpha, num_iters){
  J_history<-vector(mode = "numeric", length = num_iters)
  m<-nrow(X)
  for(i in seq_len(num_iters)){
    theta<-theta-alpha/m*(t(X)%*%(X%*%theta-y))
    J_history[i]<-computeCost2(X, y, theta)
  }
  J_history
}
  



tt<-lapply(tt,as.matrix)
lapply(tt,dim)
x1<-tt[["x"]]
y1<-tt[["y"]]
theta1<-tt[["theta"]]

J<-gradientDescentMulti(x1,y1,theta1,alpha=.05,10)
cc<-computeCost2(x1, y1, theta1)


theta1-t(x1)%*%(x1%*%theta1-y1)


num_iters=100
J_history<-vector(mode = "numeric", length = num_iters)
X=x1
y=y1
theta=theta1
alpha=0.5
m<-nrow(X)
for(i in seq_len(num_iters)){
  theta<-theta-alpha/m*(t(X)%*%(X%*%theta-y))
  J_history[i]<-computeCost2(X, y, theta)
}
J_history
