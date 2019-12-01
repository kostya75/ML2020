function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%l_matrix=eye(length(theta));
%l_matrix(1,1)=0;


#J = (-1/m)*sum(y.*log(sigmoid(X*theta))+(1-y).*log(1-sigmoid(X*theta)))+(1/2*m)*lambda*sum(l_matrix*(theta.^2));
#reg_part=
%J=(-1/m)*sum(y.*log(sigmoid(X*theta))+(1-y).*log(1-sigmoid(X*theta)));



%grad=(1/m)*(X'*(sigmoid(X*theta)-y)+lambda*l_matrix*theta);

l_vector=ones(length(theta),1);
l_vector(1)=0;

J=-(1/m)*sum(y'*log(sigmoid(X*theta))+(1-y')*log(1-sigmoid(X*theta)))+(lambda/(2*m))*l_vector'*(theta.^2);



grad=(1/m)*X'*(sigmoid(X*theta)-y)+(lambda/m)*l_vector.*theta;

% =============================================================

end
