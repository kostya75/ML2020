#https://stackoverflow.com/questions/7920590/what-is-the-r-equivalent-of-matlabs-fminunc-function

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

gdlreg2<-function(formula,data,subset,theta, lambda=0, method ="Nelder-Mead"){

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
  # flag if intercept was selected. will set lambda vector[1] (regularization variable) to zero if intercept present in formula
  infl <- attr(mt,"intercept")
  #
  n<-ncol(x)
  if(n!=length(theta)) 
    stop("Model formula and initial theta have incompatible dimensions")
  # two closures are created by ComputeCostGradient function for J and grad
  J<-ComputeCostGradient("J")
  grad<-ComputeCostGradient("grad")
  
  # optimize based on advanced algorithm. same as Octave's fminunc
  res<-optim(theta,J,grad,X=x,y=y,infl=infl,lambda=lambda,method=method)$par
  names(res)<-colnames(x)
  res
}


#test
# tt<-gdlreg2(success~e1+e2,data=grades,theta=theta,lambda=0)
# tt
# 
# glm(success~e1+e2,data=grades,family="binomial")



