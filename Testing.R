#pre RPUBS file

#testing

###################### week2 ####################


library(ggplot2)

ggplot(data=df_prices)+geom_point((aes(x=footage,y=price)),shape=4,color="red",size=3)+
  scale_y_continuous(labels = scales::dollar)+
  scale_x_continuous(labels = scales::comma)+
  labs(x="Square footage", y="Price in $",title="House Prices vs. Square Footage")+
  theme_bw()


#cost
df_foodTruck<-read.csv("w2/ex1data1.txt",header = FALSE)
names(df_foodTruck)<-c("X","y")

ggplot(data=df_foodTruck)+geom_point((aes(x=X,y=y)),shape=4,color="red",size=3)+
  scale_y_continuous(labels = scales::dollar)+
  scale_x_continuous(labels = scales::comma)+
  labs(x="Population of City in 10,000s", y="Price in $10,000s")+
  theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))

X<-as.matrix(cbind(rep(1,nrow(df_foodTruck)),df_foodTruck[,c("X")]))
y<-as.matrix(df_foodTruck["y"])

j=computeCost(X, y, theta=c(0,0))

sprintf("Computed value of cost function = %s. Expected cost value (approx) 32.07",
       round(j,digits=2))

tt<-gradientDescentMulti(X,y,theta=c(0,0),alpha=.02,num_iters = 10000,threshold=5e-11)
tt

lm(y~X,data=df_foodTruck)

# Feature normalization
normalize<-featureNormalize(
  xm=as.matrix(df_prices[c("footage","bedroom")]),
  infl=0
  )

head(normalize$x)

normalize$scalingMatrix
# tt<-gd(price~bedroom+footage,data=df_prices,theta=c(0,0,0),alpha=0.01,threshold=0.00000000005,normalize=T)
# tt
# 
# df_prices_scaled<-df_prices
# df_prices_scaled[,c("footage","bedroom")]<-lapply(df_prices[,c("footage","bedroom")],scale)

#lm(price~bedroom+footage,data=df_prices_scaled)


###################### week4 ####################
dfnumbers_small<-df_numbers[sample(5000,1000),]

y_class<-unique(dfnumbers_small$y)
for (i in y_class){
  y<-as.numeric(dfnumbers_small$y %in% i)
}


dfnumbers_small$y<-dfnumbers_small$y==5
theta1=rep(0,401)

tt<-gdlreg2(y~.,data=dfnumbers_small,theta=theta1,lambda=0,method="BFGS")
tt
