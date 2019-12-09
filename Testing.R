#pre RPUBS file

#testing

#week 2





tt<-gd(price~bedroom+footage,data=df_prices,theta=c(0,0,0),alpha=0.01,threshold=0.00000000005,normalize=T)
tt

df_prices_scaled<-df_prices
df_prices_scaled[,c("footage","bedroom")]<-lapply(df_prices[,c("footage","bedroom")],scale)

lm(price~bedroom+footage,data=df_prices_scaled)


#week4
dfnumbers_small<-df_numbers[sample(5000,1000),]

y_class<-unique(dfnumbers_small$y)
for (i in y_class){
  y<-as.numeric(dfnumbers_small$y %in% i)
}


dfnumbers_small$y<-dfnumbers_small$y==5
theta1=rep(0,401)

tt<-gdlreg2(y~.,data=dfnumbers_small,theta=theta1,lambda=0,method="BFGS")
tt
