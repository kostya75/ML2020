#pre RPUBS file

#testing

###################### week2 ####################


library(ggplot2)

ggplot(data=df_prices)+geom_point((aes(x=footage,y=price)),shape=4,color="red",size=3)+
  scale_y_continuous(labels = scales::dollar)+
  scale_x_continuous(labels = scales::comma)+
  labs(x="Square footage", y="Price in $",title="House Prices vs. Square Footage")+
  theme_bw()


#cost
df_foodTruck<-read.csv("w2/ex1data1.txt",header = FALSE)
names(df_foodTruck)<-c("X","y")

ggplot(data=df_foodTruck)+geom_point((aes(x=X,y=y)),shape=4,color="red",size=3)+
  scale_y_continuous(labels = scales::dollar)+
  scale_x_continuous(labels = scales::comma)+
  labs(x="Population of City in 10,000s", y="Price in $10,000s")+
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))

X<-as.matrix(cbind(rep(1,nrow(df_foodTruck)),df_foodTruck[,c("X")]))
y<-as.matrix(df_foodTruck["y"])

j=computeCost(X, y, theta=c(0,0))

sprintf("Computed value of cost function = %s. Expected cost value (approx) 32.07",
       round(j,digits=2))

tt<-gradientDescentMulti(X,y,theta=c(0,0),alpha=.02,num_iters = 10000,threshold=5e-11)
tt

lm(y~X,data=df_foodTruck)

# Feature normalization
normalize<-featureNormalize(
  xm=as.matrix(df_prices[c("footage","bedroom")]),
  infl=0
  )

head(normalize$x)

normalize$scalingMatrix
tt<-gd(price~bedroom+footage,data=df_prices,theta=c(0,0,0),alpha=0.01,threshold=0.00000000005,normalize=T)
tt
#
df_prices_scaled<-df_prices
df_prices_scaled[,c("footage","bedroom")]<-lapply(df_prices[,c("footage","bedroom")],scale)

lm(price~bedroom+footage,data=df_prices_scaled)

###################### week3 ####################
library(ggplot2)
grades<-read.csv("w3/ex2data1.txt",header = FALSE)
names(grades)<-c("e1","e2","success")

#chart 1

chw3_1<-
  ggplot(data=grades)+geom_point(aes(x=e1,y=e2,shape=factor(success),color=factor(success)))+
  scale_shape_manual(values=c(1,3),labels=c("Not admitted","Admitted"))+
  scale_color_manual(values=c("red","black"),labels=c("Not admitted","Admitted"))+
  scale_y_continuous(breaks=seq(0,100,by=10))+
  scale_x_continuous(breaks=seq(0,100,by=10))+
  labs(x="Exam 1 score", y="Exam 2 score", color=NULL,shape=NULL)+
  theme(
    axis.line=element_line(color="black"),
    panel.background = element_blank(),
    panel.grid.major = element_line(color="grey90"),
    legend.position = c(.85,.9),
    legend.background = element_rect(color="black"),
    legend.key = element_blank()

  )
  
# Testing
gdlreg2(success~e1+e2,data=grades,theta=c(0,0,0),lambda=0,method="BFGS")

round(
glm(success~e1+e2,data=grades, family="binomial")$coef,
4)

###################### week4 ex3 ####################
# dfnumbers_small<-df_numbers[sample(5000,1000),]
# 
# y_class<-unique(dfnumbers_small$y)
# for (i in y_class){
#   y<-as.numeric(dfnumbers_small$y %in% i)
# }
# 
# 
# dfnumbers_small$y<-dfnumbers_small$y==5
# theta1=rep(0,401)
# 
# tt<-gdlreg2(y~.,data=dfnumbers_small,theta=theta1,lambda=0,method="BFGS")
# tt

handwrit_data
handwrit_weights

df_handwrit<-as.data.frame(handwrit_data)
#tt<-gdlregMulti(y~.,data=df_handwrit,theta=rep(0,401), lambda=1, method ="BFGS")

# training index
train_in<-factor(sample(c("train","cv","test"),5000,replace=T, prob=c(.7,.2,.1)))
#train_in<-cut(runif(5000),c(0,.7,.9,1),labels=c("train","cv","test"))

# training set
X_train<-df_handwrit[train_in=="train",-401]
y_train<-df_handwrit[train_in=="train",401]

# cross-validation set
X_cv<-df_handwrit[train_in=="cv",-401]
y_cv<-df_handwrit[train_in=="cv",401]

# test set
X_test<-df_handwrit[train_in=="test",-401]
y_test<-df_handwrit[train_in=="test",401]

accuracy<-NULL
for (i in 0:20){
# train the model
hr_train<-gdlregMulti(y~.,data=df_handwrit,subset=(train_in=="train"),theta=rep(0,401),lambda=i,method="BFGS")

# test CV to determine lambda
hr_cv_predict<-predictOneVsAll(hr_train,X_cv)

# accuracy test
temp_acc<-sum(hr_cv_predict==y_cv)/length(y_cv)
accuracy<-c(accuracy,temp_acc)
}

optimal_l<-(0:20)[which.max(accuracy)]
cat("Optimal value of lambda:",optimal_l)

df_accuracy<-data.frame(lambda=0:20,Accuracy=accuracy)
ggplot(data=df_accuracy)+geom_point(aes(lambda,Accuracy))+geom_line(aes(lambda,Accuracy))+
  geom_vline(aes(xintercept=optimal_l))+
  geom_point(aes(x=optimal_l,y=accuracy[which.max(accuracy)]),color="red",size=3)+
  scale_x_continuous(labels=0:20,breaks=0:20)+labs(title="Accuracy Vs. lambda")+
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))


hr_train_optimal_l<-gdlregMulti(y~.,data=df_handwrit,subset=(train_in=="train"),theta=rep(0,401),lambda=optimal_l,method="BFGS")
hr_test_predict<-predictOneVsAll(hr_train,X_test)
test_accuracy<-sum(hr_test_predict==y_test)/length(y_test)
cat("Model Accuracy:",test_accuracy)

table(predicted=hr_test_predict,actual=y_test)
