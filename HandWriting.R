

m=dim(data_numbers$X)[1]

rand_indices<-sample(m,100)
sel<-data_numbers$X[rand_indices[1:100],]


dim(sel[1,])

library(ggplot2)


number_df<-NULL
for (s in 1:100){
  temp_matrix<-matrix(sel[s,],nrow=20,byrow=T)
  for(i in 1:20){
    for(j in 1:20){
      temp<-data.frame(index=s,x1=i,x2=j,value=temp_matrix[i,21-j])
      number_df<-rbind(number_df,temp)
      #print(temp)
    }
  }
  print(s)
}


ch1<-ggplot(data=number_df,aes(x=x1,y=x2))+geom_raster(aes(fill=value))+facet_wrap(~index, ncol=10)+
  scale_fill_continuous(type = "viridis")+
  labs(x="",y=NULL,title="Hand-written numbers: sample")+
  theme(
  strip.background = element_blank(),
  strip.text.x = element_blank(),
  legend.position = "none",
  #axis.title=element_blank(),
  axis.text = element_blank(),
  axis.ticks = element_blank()
)
ch1
