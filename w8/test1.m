
%centroids
%X
centroids=[1,2;3,4;5,6]
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);

for i=1:size(X,1);
  all_p=sum((X(i,:)-centroids).^2,2);
  [v,p]=min(all_p,[],1);
  idx(i,1)=p;
end;


% centroids = computeCentroids(X, idx, K)

for i=1:size(X,2);
  temp=accumarray(idx,X(:,i),[],FUNC=@mean)
  centroids(:,i) = temp;
endfor
