library(ggplot2)

t<-seq(from=0,to=0.98,by=0.04)

s1<-sin(8*pi*t)*10
c2<-cos(8*pi*t)*10

df1<-data.frame(do.call("cbind",list(x=c2,y=s1)))

ggplot(data=df1)+geom_path(aes(x,y),size=2,color="blue")



#2
t1<-seq(-100,100,by=5)
t2<-t1

df2<-data.frame(expand.grid(t1,t2))
names(df2)<-c("t1","t2")


dist(df2[1:2,], method = "euclidean")

df2$distYN<-
  apply(df2,1,function(x) {
    dist_temp<-sqrt((x[1])^2+(x[2])^2)
    dist_temp<105 & dist_temp>95
    })

ggplot(df2)+geom_point(aes(t1,t2),color="red")+geom_point(data=subset(df2,distYN),aes(t1,t2),color="black",size=3)

