set.seed(123)

n=5000
X21<-sample(20:30,n,replace = T)+rf(n,10,2)
X22<-sample(200:30,n,replace = T)*(1)+rchisq(n,2)
#X2_const<-rep(1,n)
e2<-rnorm(n,0,50)
const2<-5000
b21<-12.35
b22<-(-30.12)
#b2_const<-3


#######


#######


y2<-const2+b21*X21+b22*X22+e2
df2<-data.frame(X21,X22,y2)

df2[]<-lapply(df2,scale)


coefficients(lm(y2~X21+X22,data=df2))


tt<-gd(y2~X21+X22,data=df2,theta=c(1,20,3))

tt2<-gradientDescentMulti(X=tt[[1]], y=tt[[2]], theta=tt[[3]], alpha=0.000012, num_iters=5000000)
tt2[[1]]
tt2[[2]]

### credit data
summary(lm(Rating~Income+Limit+Cards+Education+Balance,data=Credit))
C2<-Filter(is.numeric,Credit)%>%
  lapply(scale)%>%
  as.data.frame()

summary(lm(Rating~Income+Limit+Cards+Education+Balance,data=C2))
coefficients(lm(Rating~Income+Limit+Cards+Education+Balance,data=C2))

tt<-gd(Rating~Income+Limit+Cards+Education+Balance,data=C2,theta=c(1,20,3,1,2,3))

tt2<-gradientDescentMulti(X=tt[[1]], y=tt[[2]], theta=tt[[3]], alpha=0.00012, num_iters=5000000)
tt2[[1]]
tt2[[2]]

################### test gitpython
https://towardsdatascience.com/linear-regression-using-gradient-descent-97a6c8700931
gp<-read.delim("gitPython.txt",header = F)

tt<-gd(V2~V1,data=gp,theta=c(0,0))

tt2<-gradientDescentMulti(X=tt[[1]], y=tt[[2]], theta=tt[[3]], alpha=0.0002, num_iters=1000)
tt2[[1]]
tt2[[2]]

tt3<-gd(V2~V1,data=gp,theta=c(0,0),alpha=0.002,num_iters = 1000)
tt3[[1]]
tt3[[2]]

lm(V2~V1,data=gp)
