

tt<-lm(price~footage+bedroom,data=df_prices)

tt$coefficients

X1<-cbind(rep.int(1,times=47),as.matrix(df_prices[,c("footage","bedroom")]))
y1<-as.matrix(df_prices[,"price"])

theta1<-matrix(c(50000, 100, 5000),byrow=T)

J1<-computeCost2(X1, y1, theta1)


t1J1<-gradientDescentMulti(X, y, theta, alpha=0.6, num_iters=1000)

t1J1[[1]]
plot(t1J1[[2]])
plot(X%*%t1J1[[1]],y)

neq<-solve(t(X)%*%X)%*%t(X)%*%y


lm(mpg~cyl+disp,data=mtcars)

mX<-cbind(rep.int(1,times=32),as.matrix(mtcars[,c("cyl","disp")]))
my<-as.matrix(mtcars[,"mpg"])
mtheta<-matrix(c(0, 0, 0),byrow=T)
mt1J1<-gradientDescentMulti(mX, my, mtheta, alpha=.03, num_iters=10000)
mt1J1[[1]]
plot(mt1J1[[2]])


mJ1<-computeCost2(mX, my, mtheta)


df_a<-airquality[complete.cases(airquality),]



