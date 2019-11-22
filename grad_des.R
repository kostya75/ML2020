
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
