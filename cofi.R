library(rmatio)


movieParams<-read.mat("w9/ex8_movieParams.mat")
movies<-read.mat("w9/ex8_movies.mat")

# movieList<-readLines("w9/movie_ids.txt")
# 
# sub("^[0-9]*\\s","\\1",movieList)

movieList<-data.frame(index=regmatches(movieList,regexpr("^[0-9]*",movieList)),MovieName=sub("^[0-9]*\\s","\\1",movieList))
##############

Y<-movies[["Y"]]
R<-movies[["R"]]
X<-movieParams[["X"]]
Theta<-movieParams[["Theta"]]

params<-c(as.vector(X),as.vector(Theta))




num_users<-dim(Theta)[1]
num_features<-dim(Theta)[2]
num_movies<-dim(X)[1]

# X_unroll<-matrix(
#   params[1:(num_movies*num_features)],
#   nrow=num_movies,
#   ncol=num_features
# )
# 
# Theta_unroll<-matrix(
#   params[(num_movies*num_features+1):length(params)],
#   nrow=num_users,
#   ncol=num_features
# )













##############
cofi<-function(type){
  function(params, Y, R, num_users, num_movies, num_features, lambda){
    
    X<-matrix(
      params[1:(num_movies*num_features)],
      nrow=num_movies,
      ncol=num_features
    )
    
    Theta<-matrix(
      params[(num_movies*num_features+1):length(params)],
      nrow=num_users,
      ncol=num_features
    )
    
    
    # COST FUNCTION
    J_reg<-(lambda/2)*sum(Theta^2)+(lambda/2)*sum(X^2)
    
    J<-(1/2)*sum(R*(X%*%t(Theta)-Y)^2)+J_reg
    
    # GRADIENTS
    
    Theta_grad=t(R*(X%*%t(Theta)-Y))%*%X+lambda*Theta
    
    X_grad=(R*(X%*%t(Theta)-Y))%*%Theta+lambda*X
   
    
    grad<-c(as.vector(X_grad),as.vector(Theta_grad))
    
    
    if(type=="J"){
      J
    }
    else if(type=="grad"){
      grad
    }
    else stop("Invalid output request from CostGradient: acceptable values are: 'J' and 'grad'")
    
  }
}

############################################## gradient checking ##########################################

checkCOGradients<-function(costFunc,Y, R, num_users, num_movies, num_features, lambda=0){
  grad<-costFunc("grad")
  J<-costFunc("J")
  
  

   params<-rnorm((num_users+num_movies)*num_features)
  
  #
  g_analytical<-grad(params=params,Y=Y, R=R, num_users=num_users, num_movies=num_movies, num_features=num_features,lambda=lambda)
  l<-length(g_analytical)
  
  e<-1e-4
  g_numeric<-vector(mode="numeric",length=l)
  
  for (i in 1:l){
    e_vector<-rep(0,l)
    e_vector[i]<-e
    param_plus<-params+e_vector
    param_minus<-params-e_vector
    JP<-J(param_plus,Y=Y, R=R, num_users=num_users, num_movies=num_movies, num_features=num_features,lambda=lambda)
    JM<-J(param_minus,Y=Y, R=R, num_users=num_users, num_movies=num_movies, num_features=num_features,lambda=lambda)
    g_numeric[i]<-(JP-JM)/(2*e)
    
  }
  cbind(Numeric=g_numeric,Analytical=g_analytical[1:l])
}

####################################################### Normalize Ratings ###################################################
#NORMALIZERATINGS Preprocess data by subtracting mean rating for every 
#movie (every row)
#   [Ynorm, Ymean] = NORMALIZERATINGS(Y, R) normalized Y so that each movie
#   has a rating of 0 on average, and returns the mean rating in Ymean.

normalizeRatings<-function(Y, R){
  m<-dim(Y)[1] # movies
  n<-dim(Y)[2] # users
  Ymean<-vector(mode="numeric",length=m)
  Ynorm<-matrix(0,nrow=m,ncol=n)
  for (i in 1:m){
    idx<-which(R[i,]==1)
    Ymean[i]<-mean(Y[i,idx])
    Ynorm[i,idx]<-Y[i,idx]-Ymean[i]
  }
  list(Ynorm=Ynorm,Ymean=Ymean)
}

#normalizeRatings(Y, R)



####################################################### testing  database ###################################################
num_users = 4; 
num_movies = 5; 
num_features = 3;
X = X[1:num_movies, 1:num_features];
Theta = Theta[1:num_users, 1:num_features];
Y = Y[1:num_movies, 1:num_users];
R = R[1:num_movies, 1:num_users];

J<-cofi("J")
J(c(as.vector(X),as.vector(Theta)), Y, R, num_users, num_movies, num_features, lambda=1.5)

checkCOGradients(cofi,Y, R, num_users, num_movies, num_features, lambda=0)

# enter some rating for myself

#movieList[grepl("Indian",movieList$MovieName),]

my_ratings<-vector(mode="numeric",length=1682)


my_ratings[1]<-4
my_ratings[98]<-2
my_ratings[7]<-3
my_ratings[12]<-5
my_ratings[54]<-4
my_ratings[64]<-5
my_ratings[66]<-3
my_ratings[69]<-5
my_ratings[183]<-4
my_ratings[226]<-5
my_ratings[355]<-5

cat('\n\nNew user ratings:\n')
for (i in seq_along(my_ratings)){
  if(my_ratings[i]>0){
    cat(sprintf("Rated %d for %s \n",my_ratings[i],movieList$MovieName[i]))

  }
}

######################### Learning movie rating

movies<-read.mat("w9/ex8_movies.mat")

Y<-movies[["Y"]]
R<-movies[["R"]]

# add my rating

Y<-cbind(as.matrix(my_ratings),Y)
R<-cbind(as.matrix(my_ratings!=0),R)

# Normalize (mean) ratings

Y_norm_list<-normalizeRatings(Y, R)
Ynorm<-Y_norm_list[["Ynorm"]]
Ymean<-Y_norm_list[["Ymean"]]

num_users<-dim(Y)[2]
num_movies<-dim(Y)[1]
num_features<-10 # arbitrary value

# Set initial values for Theta and X
X<-matrix(rnorm(num_movies*num_features),num_movies,num_features)
Theta<-matrix(rnorm(num_users*num_features),num_users,num_features)

# initial parameters

initial_parameters<-c(as.vector(X),as.vector(Theta))
lambda<-10

# run

J<-cofi("J")
grad<-cofi("grad")

res<-optim(initial_parameters,J,grad,Y=Ynorm,R=R,num_users=num_users, num_movies=num_movies, num_features=num_features,lambda=lambda,method="CG")
res<-res$par

# unroll to matricies

X<-matrix(
  res[1:(num_movies*num_features)],
  nrow=num_movies,
  ncol=num_features
)

Theta<-matrix(
  res[(num_movies*num_features+1):length(res)],
  nrow=num_users,
  ncol=num_features
)

# predictions
p<-X%*%t(Theta)
my_predictions <- p[,1] + Ymean

movieList[order(my_predictions,decreasing = T),][1:10,]
my_predictions[order(my_predictions,decreasing = T)][1:12]

#movieList[order(my_ratings,decreasing = T),][1:4,]


