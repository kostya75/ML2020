#oneVsall

########## testing#########

#df_numbers<-do.call(,data_numbers)
# df_numbers<-data.frame(data_numbers)
# 
# theta<-rep(0,401)
# hr_all<-gdlregMulti(y~.,data=df_numbers,theta=theta,lambda=0,method="BFGS")
# 
# 
# X2<-df_numbers[,-401]
# y1<-df_numbers[,401]
# hr_all_predict<-predictOneVsAll(hr_all[["all_theta"]],X2,hr_all[["y_class"]])
# 
# # all
# confusion_matrix<-prop.table(table(y1,hr_all_predict),1)
# 
# # accuracy all
# sum(hr_all_predict==y1)/length(y1)
# 
# 
# # training index
# train_in<-sample(5000,4000)
# 
# # training set
# X_train<-df_numbers[train_in,-401]
# y_train<-df_numbers[train_in,401]
# 
# # test set
# X_test<-df_numbers[-train_in,-401]
# y_test<-df_numbers[-train_in,401]
# 
# accuracy<-NULL
# for (i in 0:20){
# # train the model
# hr_train<-gdlregMulti(y~.,data=df_numbers,subset=train_in,theta=theta,lambda=i,method="BFGS")
# 
# # test
# hr_test_predict<-predictOneVsAll(hr_train[["all_theta"]],X_test,hr_train[["y_class"]])
# 
# # accuracy test
# temp_acc<-sum(hr_test_predict==y_test)/length(y_test)
# accuracy<-c(accuracy,temp_acc)
# }



########## testing#########



# sigmoid function
sigmoid<-function(z){
  g<-1/(1+exp(-z))
}


# reguralize temp

# CLOSURE
ComputeCostGradient<-function(type){
  
  function(X, y, theta, infl, lambda){
    # length of theta or design matrix
    n<-dim(X)[2]
    # number of observations
    m<-dim(X)[1]
    # vector to drop Xo from regularization component. check if Xo supplied to the model formula
    if(infl==1) 
      lambda_vector<-c(0,rep(1,n-1))
    else 
      lambda_vector<-c(rep(1,n))
    
    if(type=="J"){
      (-1/m)*sum(y*log(sigmoid(X%*%theta))+(1-y)*log(1-sigmoid(X%*%theta)))+lambda/(2*m)*lambda_vector%*%theta^2
    }
    else if(type=="grad"){
      as.numeric((1/m)*t(X)%*%(sigmoid(X%*%theta)-y)+lambda/m*lambda_vector*theta)
    }
    else stop("Invalid output request from CostGradient: acceptable values are: 'J' and 'grad'")
  }
}




###################################################
# gradient descent analytical

gdlregMulti<-function(formula,data,subset,theta, lambda=0, method ="BFGS"){
  #method BFGS works with a large number of features
  
  if(is.na(match(method,c("Nelder-Mead", "BFGS", "L-BFGS-B")))) 
    stop("Please select on of the tested methods: Nelder-Mead, BFGS, L-BFGS-B")
  
  mf <- match.call(expand.dots = F)
  m <- match(c("formula", "data","subset"), 
             names(mf), 0L)
  mf <- mf[c(1L, m)]
  #mf <- mf[m]
  mf$drop.unused.levels <- TRUE
  mf[[1L]] <- quote(stats::model.frame)
  mf <- eval(mf, parent.frame())
  mt <- attr(mf, "terms")
  
  ymulti <- model.response(mf, "numeric")
  y_class<-unique(ymulti)
  x <- model.matrix(mt, mf)
  # flag if intercept was selected. will set lambda vector[1] (regularization variable) to zero if intercept present in formula
  infl <- attr(mt,"intercept")
  #
  n<-ncol(x)
  if(n!=length(theta)) 
    stop("Model formula and initial theta have incompatible dimensions")
  # two closures are created by ComputeCostGradient function for J and grad
  
  all_theta<-NULL
  for (i in y_class){
    y<-as.numeric(ymulti %in% i)
     J<-ComputeCostGradient("J")
     grad<-ComputeCostGradient("grad") 
     res<-optim(theta,J,grad,X=x,y=y,infl=infl,lambda=lambda,method=method)$par
     #all_theta<-data.frame(rbind(all_theta,c(class=i,res)))
     all_theta<-rbind(all_theta,res)
     colnames(all_theta)<-colnames(x)
     rownames(all_theta)<-NULL
  }
    

  
  out<-list(all_theta=all_theta,y_class=y_class)

}


#########################
#predict
#this function requires an additional input that insures that labels are correctly assigned to each class. More robust in my opinion
predictOneVsAll<-function(all_theta, X, y_class){
  if("(Intercept)" %in% colnames(all_theta)){
    X<-data.frame(temp=1,X)
    names(X)[1] <- "(Intercept)"
  }
  X<-sigmoid(as.matrix(X)%*%t(all_theta))
  X<-apply(X,1,function(x) y_class[which.max(x)])
}



