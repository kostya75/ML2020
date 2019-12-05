#pre RPUBS file

#testing

#week 2

tt<-gd(price~footage+bedroom-1,data=df_prices,theta=c(100,-5000),alpha=0.00000004, num_iters=1000000)
tt

lm(price~footage+bedroom-1,data=df_prices)
