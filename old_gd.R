#for logit use y<-rbinom(100,1,0.5)


set.seed(20)

sz<-1000
x1<-rnorm(sz)
e<-rnorm(sz,0,50)
threshold<-.000001

x2<-rnorm(sz)

y<-200+2*x1-18*x2+e
summary(y)
plot(x1,y)
plot(x2,y)
plot(x1,x2)

#theta 1x3 vector
theta<-as.matrix(vector("numeric",3))
#X matrix of x's
X<-cbind(matrix(1:1,sz,1),x1,x2)

#J 1xNum_iter vector of cost fuction
J<-vector("numeric",0)
#a learning rate
a<-0.03

# X<-X1
# y<-y1
# theta<-theta1

#t(X)%*%(X%*%theta-y)
m<-nrow(X)

for (i in 1:10000){ 
  
  theta<-theta-a/m*t(X)%*%(X%*%theta-y)
  J<-rbind(J,-1/m*sum(X%*%theta-y))
  counter<-i
  ifelse(i>2,ifelse(J[i-1]-J[i]<0.00001,break,NA),NA)
}






plot(1:counter,J)

neq<-solve(t(X)%*%X)%*%t(X)%*%y

theta
neq

mydata<-data.frame(cbind(y,x1,x2))
fit<-lm(y~x1+x2,mydata)
