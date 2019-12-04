#https://stackoverflow.com/questions/7920590/what-is-the-r-equivalent-of-matlabs-fminunc-function

# sigmoid function
sigmoid<-function(z){
  g<-1/(1+exp(-z))
}



# cost function: return single number
ComputeCostLogistic<-function(X, y, theta){
  m<-dim(X)[1]
  J<-(-1/m)*sum(y*log(sigmoid(X%*%theta))+(1-y)*log(1-sigmoid(X%*%theta)))
}

# gradient vector of length theta
gradLogistic<-function(X, y, theta){
  grad<-(1/m)*t(X)%*%(sigmoid(X%*%theta)-y)
  grad<-as.numeric(grad)
}



res <- optim(theta,ComputeCostLogistic,gradLogistic,X=Xlog,y=ylog,method = "Nelder-Mead")



###################################################
# gradient descent analytical

gdl<-function(formula,data,subset,theta,alpha=0.00001, num_iters=10000, method ="Nelder-Mead"){
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
  #
  n<-ncol(x)
  if(n!=length(theta)) 
    stop("Model formula and initial theta have incompatible dimensions")

  #out<-list(x=x,y=y,theta=theta)

  res<-optim(theta,ComputeCostLogistic,gradLogistic,X=x,y=y,method=method)$par
  names(res)<-colnames(x)
  res
}

tt<-gdl(success~e1+e2,data=grades,theta=theta)
tt




