#https://stackoverflow.com/questions/7920590/what-is-the-r-equivalent-of-matlabs-fminunc-function

# sigmoid function
sigmoid<-function(z){
  g<-1/(1+exp(-z))
}



# reguralize

# cost function: return single number
ComputeCostLogisticReg<-function(X, y, theta, infl, lambda){
  # length of theta or design matrix
  n<-dim(X)[2]
  # number of observations
  m<-dim(X)[1]
  # vector to drop Xo from regularization component. check if Xo supplied to the model formula
  if(infl==1) 
    lambda_vector<-c(0,rep(1,n-1))
  else 
    lambda_vector<-c(rep(1,n))

  J<-(-1/m)*sum(y*log(sigmoid(X%*%theta))+(1-y)*log(1-sigmoid(X%*%theta)))+lambda/(2*m)*lambda_vector%*%theta^2
}



# gradient vector of length theta
gradLogisticReg<-function(X, y, theta, infl=0, lambda){
  n<-dim(X)[2]
  # number of observations
  m<-dim(X)[1]
  # vector to drop Xo from regularization component. check if Xo supplied to the model formula
  if(infl==1) 
    lambda_vector<-c(0,rep(1,n-1))
  else 
    lambda_vector<-c(rep(1,n))
  
  grad<-(1/m)*t(X)%*%(sigmoid(X%*%theta)-y)+lambda/m*lambda_vector*theta
  
  grad<-as.numeric(grad)
}




###################################################
# gradient descent analytical logistic regularized

gdlreg<-function(formula,data,subset,theta, lambda=0, method ="Nelder-Mead"){

  #cl<-match.call()
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
  
  y <- model.response(mf, "numeric")
  x <- model.matrix(mt, mf)
  # flag if intercept was selected. will set lambda (regularization variable) to zero if no intercept
  infl <- attr(mt,"intercept")
  #
  n<-ncol(x)
  if(n!=length(theta)) 
    stop("Model formula and initial theta have incompatible dimensions")
  
  #out<-list(x=x,y=y,theta=theta)
  res<-optim(theta,ComputeCostLogisticReg,gradLogisticReg,X=x,y=y,infl=infl,lambda=lambda,method=method)$par
  names(res)<-colnames(x)
  res
}

# 
# (ComputeCostLogisticReg(Xlog, ylog, theta, infl=0, lambda=0))
# (ComputeCostLogistic(Xlog, ylog, theta))
# 
# 
# 
# 
# (gradLogisticReg(Xlog, ylog, theta, infl=1, lambda=0))
# (gradLogistic(Xlog, ylog, theta))
# 
# optim(theta,ComputeCostLogisticReg,gradLogisticReg,X=Xlog,y=ylog,infl=0, lambda=0.005, method = "Nelder-Mead")
# optim(theta,ComputeCostLogistic,gradLogistic,X=Xlog,y=ylog,method = "Nelder-Mead")
# 
# 
# tt<-gdlreg(success~e1+e2-1,data=grades,theta=theta[-1],lambda=.5)
# tt
# 
# glm(success~e1+e2-1,data=grades,family="binomial")
