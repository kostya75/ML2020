
tt<-kmeans(X_cv,5)

library(rmatio)

kmeans_tt<-read.mat("w8/ex7data2.mat")

findClosestCentroids<-function(X, centroids){
  idx<-apply(X,1, function(x) {which.min(rowSums((x-centroids)^2))} )
}

idx<-findClosestCentroids(X,initial_centroids)

# initial_centroids = matrix(c(3,3,6,2,8,5),ncol=2, byrow = F)
# 
# K<-3
# 
# sum((X[1,]-initial_centroids)^2)
# 
# (findClosestCentroids(X[1:3,],initial_centroids))
# 
# which.min(rowSums((X[1,]-initial_centroids)^2))
# 
# X[1,]-initial_centroids

computeCentroids<-function(X, idx){
  #K number of clusters is redundant
  centroids<-apply(X, 2,function(x) tapply(x,idx,FUN=mean))
}
#aggregate(X~idx,FUN="mean")

(computeCentroids(X,idx))
