
library(rmatio)



handwrit_data<-read.mat("w5/ex4data1.mat")
handwrit_weights<-read.mat("w5/ex4weights.mat")

X<-handwrit_data[["X"]]
y<-handwrit_data[["y"]]



tt<-nn3(X,y, hidden_layer_size=25, num_labels=10,lambda=1,method="L-BFGS-B")


table(predict_nn3(tt, X))
table(predict_nn3(tt, X)==y)
