
#tt<-kmeans(X_cv,5)

library(rmatio)

kmeans_tt<-read.mat("w8/ex7data2.mat")

findClosestCentroids<-function(X, centroids){
  idx<-apply(X,1, function(x) {
    x_mat<-matrix(x,ncol=length(x))[rep(1,nrow(centroids)),] # convert numeric to matrix with ncol(X) and replicate nrow(centroid) times
    which.min(rowSums((x_mat-centroids)^2))
    } )
}



computeCentroids<-function(X, idx){
  #K number of clusters is redundant
  centroids<-apply(X, 2,function(x) tapply(x,idx,FUN=mean))
  #aggregate(X~idx,FUN="mean")
}


kMeansInitCentroids<-function(X, K){
#KMEANSINITCENTROIDS This function initializes K centroids that are to be 
#used in K-Means on the dataset X
#Centroids are set to randomly chosen examples from the dataset X

  randidx<-sample(nrow(X),K) # sample K out of length of X
  centroids<-X[randidx,]
}


###### R/Octave Version
runKmeans<-function(X,initial_centroids, max_iters){
  centroids<-initial_centroids
  for (i in 1:max_iters){
    idx<-findClosestCentroids(X,centroids)
    centroids<-computeCentroids(X, idx)
  }
  return(list(centers=centroids,clusters=idx))
}


###### Production Version

kmeans_ml<-function(X,K, max_iters=10){
  centroids<-kMeansInitCentroids(X,K)
  for (i in 1:max_iters){
    idx<-findClosestCentroids(X,centroids)
    centroids<-computeCentroids(X, idx)
  }
  return(list(centers=centroids,clusters=idx))
}



tt<-kmeans_ml(mtcars,3, max_iters = 20)
tt_km<-kmeans(mtcars,3)

tt_km$centers
tt$centers


