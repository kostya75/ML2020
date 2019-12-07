df_prices<-read.csv("ex1data2.txt",header = FALSE)
names(df_prices)<-c("footage","bedroom","price")




grades<-read.csv("ex2data1.txt",header = FALSE)
names(grades)<-c("e1","e2","success")


install.packages('rmatio')


library(rmatio)

data_numbers<-read.mat("C:/Users/k_min/Documents/ML_ANG/machine-learning-ex3/ex3/ex3data1.mat")
