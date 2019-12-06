
#wrapper around fomula and data to get 2 design matrixies: x and y with "no-intercept" control
# based on lm function



gd<-function(formula,data,subset,theta,alpha=0.00001, num_iters=10000, threshold=0.00000005, normalize=T){
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
  # flag if intercept was selected. will set lambda vector[1] (regularization variable) to zero if intercept present in formula
  infl <- attr(mt,"intercept")
  #
  n<-ncol(x)
  if(n!=length(theta)) stop("Model formula and initial theta have incompatible dimensions")
  #lm.fit (x, y)$coefficients
  scalingMatrix<-NULL
  if(normalize){
    x<-featureNormalize(x,infl=infl)$x
    scalingMatrix<-featureNormalize(x,infl=infl)$scalingMatrix
  }
  
  #out<-list(x=x,y=y,theta=theta,infl=infl,scalingMatrix=scalingMatrix)
  out<-gradientDescentMulti(X=x, y=y, theta=theta, alpha=alpha, num_iters=num_iters,threshold=threshold)
  model<-list(theta=out$theta, scalingMatrix=scalingMatrix, iteration=out$iteration)
}

# compute cost
# unlike computeCost, computeCost2 does not add column of 1 for the intercept as this is hanled by gd function in the same way as stat::lm does

computeCost<-function(X, y, theta){
  # X<-as.matrix(X)
  # y<-as.matrix(y)
  # theta<-as.matrix(theta)
  m<-dim(X)[1]
  # X<-cbind(rep(1,m),X)
  #J<-(1/(2*m))*sum((X%*%theta-y)^2)
  J<-(1/(2*m))*t(X%*%theta-y)%*%(X%*%theta-y)
}

gradientDescentMulti<-function(X, y, theta, alpha, num_iters,threshold){
  J_history<-vector(mode = "numeric", length = num_iters)
  m<-nrow(X)
  for(i in seq_len(num_iters)){
    theta<-theta-(t(X)%*%(X%*%theta-y))*(alpha/m)
    J_history[i]<-computeCost(X, y, theta)
    #Conversion<-(i>1 &&  abs(1-(J_history[i]/J_history[i-1]))<0.00000005)
    Conversion<-( i>1 &&  abs(1-(J_history[i]/J_history[i-1]))<threshold)
    #if(Conversion) break
    if(is.na(Conversion)==F){
      
      if(Conversion) break
    } else  {
      stop(sprintf("Failed to converge. Learning rate alpha = '%s' is too large.",
                   alpha), domain = NA)
    }
    
  }
  
  out<-list(theta=theta,iteration=i)
}


featureNormalize<-function(xm, infl){
  
  scalingMatrix<-apply(xm,2,function(x){
    cbind(mean(x),sd(x))
  })
  rownames(scalingMatrix)<-c("mu","sigma")
  
  # if model has constant, do not scale the constant
  if(infl==1){
    scalingMatrix[1,1]<-0
    scalingMatrix[2,1]<-1
  }
  
  # Alternative
  # X_norm<-
  #  matrix(
  #    mapply(function(x,m,s){(x-m)/s},x=as.vector(t(xm)),m=scalingMatrix[1,],s=scalingMatrix[2,]),
  #    nrow=dim(xm)[1],byrow=T)
  
  mus<-scalingMatrix[rep(1,nrow(xm)),]
  sds<-scalingMatrix[rep(2,nrow(xm)),]
  X_norm<-(xm-mus)/sds
  out<-list(x=X_norm,scalingMatrix=scalingMatrix)
}
