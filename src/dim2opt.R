# two dimensional density
library(MASS)
N = 1000000

x <- rnorm(2*N)
y <- x+rnorm(2*N)/2

mat <- matrix(c(x, y), ncol=2)
colnames(mat) = c('x', 'y')


f1 <- kde2d(mat[,1], mat[,2], n = 50)
image(f1, zlim = c(0, 0.07), xlim = c(-5,5), col  = rainbow(256))
points(mat[,1], mat[,2], pch='.')

library(ggplot2)
library(dplyr)
library(data.table)

mat2 <- data.table(mat)


m <- ggplot(mat2, aes(x = x, y = y)) +
  geom_point() +
  xlim(-5,5) +
  ylim(-5,5)
m + geom_density_2d()

m + stat_density_2d(aes(fill = ..level.. ), geom = "polygon")

mat2[,x] %>% quantile( probs=(1:10)/10)


cov_mat <- function(x,y){
  mat = matrix(0, ncol=2,nrow=2)
  mat[1,1]=mean(x*x) - mean(x)^2
  mat[2,2]=mean(y*y) - mean(y)^2
  mat[1,2]=mean(x*y) - mean(x)*mean(y)
  mat[2,1]=mat[1,2]
  return(mat);
}

corr_mat <- function(x,y){
  mat = matrix(0, ncol=2,nrow=2)
  mat[1,1]=mean(x*x) - mean(x)^2
  mat[2,2]=mean(y*y) - mean(y)^2
  mat[1,2]=mean(x*y) - mean(x)*mean(y)
  mat[1,2]=mat[1,2]/sqrt(mat[1,1]*mat[2,2])
  mat[2,1]=mat[1,2]
  mat[2,2]=1
  mat[1,1]=mat[2,2]
  return(mat);
}


matroot <- function(x,y){
  mat = matrix(0, ncol=2,nrow=2)
  mat[1,1]=mean(x*x) - mean(x)^2
  mat[2,2]=mean(y*y) - mean(y)^2
  mat[1,2]=mean(x*y) - mean(x)*mean(y)
  mat[2,1]=mat[1,2]
  u = eigen(mat)
  return(u$vectors %*% diag(sqrt(u$values)) %*% t(u$vectors));
}

inv_matroot <- function(x,y){
  mat = matrix(0, ncol=2,nrow=2)
  mat[1,1]=mean(x*x) - mean(x)^2
  mat[2,2]=mean(y*y) - mean(y)^2
  mat[1,2]=mean(x*y) - mean(x)*mean(y)
  mat[2,1]=mat[1,2]
  u = eigen(mat)
  return(u$vectors %*% diag(1/sqrt(u$values)) %*% t(u$vectors));
}

library(Matrix)

library(matlib)

mat3 = mat %*% rnorm(N)

corr = mean(mat2[,x] * mat2[,y]) - mean(mat2[,x]) * mean(mat2[,y])

cov_mat(mat2[,x] , mat2[,y])

quantile(mat2[,x])
quantile(mat2[,y])

E2= inv_matroot(mat[,1], mat[,2])

parar = matrix(1,ncol=2,nrow=1)%*%(matrix(matroot(mat2[,x], mat2[,y]),ncol=2) %>% inv)

fr <- function(x,u){
  u[1]*qnorm(0.75/pnorm(q = x)) + u[2] *x
}



ss <- function(x){
  c(qnorm(0.75/pnorm(q = x)),x)
}

y = optim(par=1, fn=fr,  method = "BFGS", u = parar)
xx = matroot(mat[,1], mat[,2]) %*% ss(y$par)
mean((mat[,1]<=xx[1])&(mat[,2]<=xx[2]))

mat = mat[order(mat[,2]),]


fr2 <- function(x,mat){
  y = mat[,1]<x
  p = mean(y)
  n = nrow(mat)
  m = ceiling(n*0.75/p)
  if (n<m) m=n
  u = m:n
  for (s in m:n) u[s+1-m] = abs(0.75 - mean(y & (mat[,2]<mat[s,2])))
  p+(m+which.min(u))/n
}

ffrr <- function(x,mat){
  y = mat[,1]<x
  p = mean(y)
  n = nrow(mat)
  m = ceiling(n*0.75/p)
  if (n<m) m=n
  u = m:n
  for (s in m:n) u[s+1-m] = abs(0.75 - mean(y * (mat[,2]<mat[s,2])))
  c(x, mat[(m+which.min(u)), 2])
}

y = optim(par=quantile(mat[,1],probs = .8), fn=fr2,  method = "BFGS", mat = mat)

xx=ffrr(y$par, mat=mat)

mean((mat[,1]<=xx[1])&(mat[,2]<=xx[2]))





ff <- function(s1=0.8,s2=0.8,mat=mat){
  mean((mat[,1]<=quantile(mat[,1],probs = s1))&(mat[,2]<= quantile(mat[,2],probs = s2)))
}

fff <- function(mat,step = 1
,ep = 0.05
,learning_rate=0.9
,oo = rep(0.775,2)
,rr = 0.75 ){
  for (step in 1:100){
  ##   a
  ##b  o   d
  ##   c
  lr = ep*learning_rate^step
  po = ff(oo[1],oo[2],mat)
  pa = ff(oo[1],oo[2]+lr,mat)
  pb = ff(oo[1]-lr,oo[2],mat)
  pc = ff(oo[1],oo[2]-lr,mat)
  pd = ff(oo[1]+lr,oo[2],mat)
  
  L = c(pa, pb, pc, pd)
  s = L- rr

  inx = which.min(abs(s))
  
  if (L[inx] - po > 0){
    if (inx == 1 ) oo[2] = oo[2]+lr*0.618
    if (inx == 2 ) oo[1] = oo[1]-lr*0.618
    if (inx == 3 ) oo[2] = oo[2]-lr*0.618
    if (inx == 4 ) oo[1] = oo[1]+lr*0.618
  }else{
    if (inx == 1 ) oo[2] = oo[2]+lr
    if (inx == 2 ) oo[1] = oo[1]-lr
    if (inx == 3 ) oo[2] = oo[2]-lr
    if (inx == 4 ) oo[1] = oo[1]+lr
  }
cat("Step:", step, "estimate:",po,"\t cirle:",L,'\n')
if (abs(po-rr)<1e-3) break;
  }
  return(po);
}


tic = Sys.time()
fff(mat=mat)
toc = Sys.time()
cat("Sample size:", nrow(mat), '\n')
toc-tic
