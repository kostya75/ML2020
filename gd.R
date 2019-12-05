
#wrapper around fomula and data to get 2 design matrixies: x and y with "no-intercept" control
# based on lm function

#gradient descent function
# gd<-function(formula,data,subset,theta){
#   cl<-match.call()
# 
#   mf <- match.call(expand.dots = F)
# 
#   m <- match(c("formula", "data","subset"), 
#              names(mf), 0L)
#   mf <- mf[c(1L, m)]
#   #mf <- mf[m]
#   mf$drop.unused.levels <- TRUE
#   mf[[1L]] <- quote(stats::model.frame)
#   mf <- eval(mf, parent.frame())
#   mt <- attr(mf, "terms")
#   
#   y <- model.response(mf, "numeric")
#   x <- model.matrix(mt, mf)
#   #
#   n<-ncol(x)
#   if(n!=length(theta)) stop("Model formula and initial theta have incompatible dimensions")
#   #lm.fit (x, y)$coefficients
#   out<-list(x=x,y=y,theta=theta)
#   
# }

gd<-function(formula,data,subset,theta,alpha=0.00001, num_iters=10000){
  cl<-match.call()
  
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
  if(n!=length(theta)) stop("Model formula and initial theta have incompatible dimensions")
  #lm.fit (x, y)$coefficients
  #out<-list(x=x,y=y,theta=theta)
  gradientDescentMulti(X=x, y=y, theta=theta, alpha=alpha, num_iters=num_iters)
}

# compute cost
# unlike computeCost, computeCost2 does not add column of 1 for the intercept as this is hanled by gd function in the same way as stat::lm does

computeCost2<-function(X, y, theta){
  # X<-as.matrix(X)
  # y<-as.matrix(y)
  # theta<-as.matrix(theta)
  m<-dim(X)[1]
  # X<-cbind(rep(1,m),X)
  J<-(1/(2*m))*sum((X%*%theta-y)^2)
}

gradientDescentMulti<-function(X, y, theta, alpha, num_iters){
  J_history<-vector(mode = "numeric", length = num_iters)
  m<-nrow(X)
  for(i in seq_len(num_iters)){
    theta<-theta-(t(X)%*%(X%*%theta-y))*(alpha/m)
    J_history[i]<-computeCost2(X, y, theta)
    #Conversion<-(i>1 &&  abs(1-(J_history[i]/J_history[i-1]))<0.00000005)
    Conversion<-( i>1 &&  abs(1-(J_history[i]/J_history[i-1]))<0.00000005)
    #if(Conversion) break
    if(is.na(Conversion)==F){
      
      if(Conversion) break
    } else  {
      stop(sprintf("Failed to converge. Learning rate alpha = '%s' is too large.",
                   alpha), domain = NA)
    }
    
  }
  
  out<-list(theta,i)
}


gradientDescentMulti<-function(X, y, theta, alpha, num_iters){
  J_history<-vector(mode = "numeric", length = num_iters)
  m<-nrow(X)
  for(i in seq_len(num_iters)){
    theta<-theta-(t(X)%*%(X%*%theta-y))*(alpha/m)
    J_history[i]<-computeCost2(X, y, theta)
    #Conversion<-(i>1 &&  abs(1-(J_history[i]/J_history[i-1]))<0.00000005)
    # Conversion<-( i>1 &&  abs(1-(J_history[i]/J_history[i-1]))<0.00000005)
    # #if(Conversion) break
    # if(is.na(Conversion)==F){
    #   
    #   if(Conversion) break
    # } else  {
    #   stop(sprintf("Failed to converge. Learning rate alpha = '%s' is too large.",
    #                alpha), domain = NA)
    # }
    
  }
  
  out<-list(theta,i)
}


