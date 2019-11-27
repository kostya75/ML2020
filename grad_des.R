
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
    theta<-theta-alpha/m*(t(X)%*%(X%*%theta-y))
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



################################# simple ################################

gradientDescentSimple<-function(df, m, c, L=0.0001, num_iters=1000){
  
  
  X<-df[,1]
  n<-length(X)
  Y<-df[,2]
  for(i in seq_len(num_iters)){
    Y_pred<-m*Y+c
    #D_m<-(-1/n)*sum(X*(Y-Y_pred))
    # D_m<-(1/n)*sum(X*(Y-Y_pred))
    # D_c<-(1/n)*sum(Y-Y_pred) 
    
    m<-m-(L/n)*sum(X*(Y_pred-Y))
    c<-c-(L/n)*sum(Y_pred-Y)
    print(m)
  }
  #print(Y)
  out<-list(m,c)
}

tt_simple<-gradientDescentSimple(gp, m=0, c=0,num_iters=100)

tt_simple[[1]]
tt_simple[[2]]

tt2<-gradientDescentMulti(X=tt[[1]], y=tt[[2]], theta=c(0,0), alpha=0.00015, num_iters=500000)
tt2[[1]]
tt2[[2]]


##################
tt3<-gd(y2~X21,data=df2,theta=c(1,0),alpha=0.000005, num_iters=500000)
tt3[[1]]
tt3[[2]]
