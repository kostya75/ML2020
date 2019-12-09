df_prices<-read.csv("w2/ex1data2.txt",header = FALSE)
names(df_prices)<-c("footage","bedroom","price")




grades<-read.csv("w3/ex2data1.txt",header = FALSE)
names(grades)<-c("e1","e2","success")


install.packages('rmatio')


library(rmatio)

data_numbers<-read.mat("w4/ex3data1.mat")
