# # 1 
# sleep_for_a_minute <- function() { Sys.sleep(60) }
# 
# start_time <- Sys.time()
# sleep_for_a_minute()
# end_time <- Sys.time()
# 
# end_time - start_time
# 
# # 2
# system.time(sleep_for_a_minute())
# Time difference of 1.000327 mins

# Time Multiclass logistic regression

library(rmatio)
handwrit_data<-read.mat("w5/ex4data1.mat")
handwrit_weights<-read.mat("w5/ex4weights.mat")

df_handwrit<-as.data.frame(handwrit_data)

source("OneVsAll.R")

set.seed(1234)


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

timing_OvsA<-function(){
accuracy<-NULL
for (i in seq(1,5,by=0.2)){
  # train the model
  hr_train<-gdlregMulti(y~.,data=df_handwrit,subset=(train_in=="train"),theta=rep(0,401),lambda=i,method="BFGS")
  
  # test CV to determine lambda
  hr_cv_predict<-predictOneVsAll(hr_train,X_cv)
  
  # accuracy test
  temp_acc<-sum(hr_cv_predict==y_cv)/length(y_cv)
  accuracy<-c(accuracy,temp_acc)
}

optimal_l<-seq(1,5,by=0.2)[which.max(accuracy)]
cat("Optimal value of lambda:",optimal_l,"\n")
cat("\n")

plot(seq(1,5,by=0.2),accuracy)
lines(seq(1,5,by=0.2),accuracy)
abline(v=optimal_l,lty=2)
}

print(system.time(timing_OvsA()))
