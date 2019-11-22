
#wrapper around fomula and data to get 2 design matrixies: x and y with "no-intercept" control
# based on lm function

#gradient descent function
gd<-function(formula,data,subset,theta){
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
  
  #lm.fit (x, y)$coefficients
  out<-list(x=x,y=y,theta=theta)
}

###################### WORKS ########################

# tt_f<-function(formula,data,subset,theta){
#   cl<-match.call()
#   
#   mf <- match.call(expand.dots = F)
#   
#   m <- match(c("formula", "data","subset"), 
#               names(mf), 0L)
#   mf <- mf[c(1L, m)]
#   
#   # 
#   mf$drop.unused.levels <- TRUE
#   mf[[1L]] <- quote(stats::model.frame)
#   mf <- eval(mf, parent.frame())
#   mt <- attr(mf, "terms")
#   # 
#   y <- model.response(mf, "numeric")
#   x <- model.matrix(mt, mf)
#   theta
#   # 
#   # 
#   tt<-list(x,y,theta)
#   #lm.fit (x, y)$coefficients
# }

# tt<-tt_f(price~bedroom+footage-1,data=df_prices,subset=10:47,theta=c(1,2))
# tt

###################### WORKS ########################

#returns specified by full name
#tt_f(formula = price ~ footage + bedroom, data = df_price)

# mf : at that point
# tt_f(formula = price ~ footage + bedroom - 1, data = df_prices, 
#      drop.unused.levels = TRUE)
# 
# string again
# > tt[[1]]<-quote(stats::model.frame)
# > tt
# tt<-stats::model.frame(formula = price ~ footage + bedroom, data = df_prices, 
#                    drop.unused.levels = TRUE)
# Data added
# eval(tt, parent.frame())

tt<-gd(price~bedroom+footage-1,data=df_prices,subset=10:47,theta=c(1,2))

#lm(price~bedroom+footage-1,data=df_prices,subset=10:47)
