df_prices<-read.csv("w2/ex1data2.txt",header = FALSE)
names(df_prices)<-c("footage","bedroom","price")




grades<-read.csv("w3/ex2data1.txt",header = FALSE)
names(grades)<-c("e1","e2","success")


install.packages('rmatio')


library(rmatio)

#week 4
#lm data
data_numbers<-read.mat("w4/ex3data1.mat")

#week5
#nn data
nn_data<-read.mat("w5/ex4data1.mat")
nn_weights<-read.mat("w5/ex4weights.mat")
