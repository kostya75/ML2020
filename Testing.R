#pre RPUBS file

#testing

#week 2





tt<-gd(price~bedroom+footage,data=df_prices,theta=c(0,0,0),alpha=0.01,threshold=0.00000000005,normalize=T)
tt

df_prices_scaled<-df_prices
df_prices_scaled[,c("footage","bedroom")]<-lapply(df_prices[,c("footage","bedroom")],scale)

lm(price~bedroom+footage,data=df_prices_scaled)
