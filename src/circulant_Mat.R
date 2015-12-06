a = 0.1 * (1:4)
shifter <- function(x, n = 1) {
  if (n == 0) x else c(tail(x, -n), head(x, n))
}

A =a

for (i in 1:3) A<-rbind(A,shifter(a,i))

matpower <- function(A,n){
# iterative way.
if (n==0) return(diag(rep(1, dim(A)[1])));
if (n==1) return(A);
B=A%*%matpower(A,n-1);
 B;
}

B = diag(rep(1,4))-A
matpower(A,100)

eigen(B) -> u
g = u$vectors[,abs(u$values)<1e-15]
g/sum(g)

eigen(A) -> AA
AA1 = AA$vectors
AA2 = diag(AA$values)
# Jordan Matrix Decomposition, eigen value differs, i.e
# algebraic multiplicity = dim(A)
# Jordan Form is simply:
AA1%*%AA2%*%t(AA1)
# check the eigen value
###> diag(AA2)
###[1]  1.0000000  0.2828427 -0.2000000 -0.2828427
# Then A^n -> AA1 AA2^n t(AA1)
# notice AA2 is a diagnal matrix, then
# AA2^n -> diag(c(1, 0, 0, 0))
# i.e. we only need to compute the eigen vector A
# corresponding to eigen value = 1, i.e. (I-A)x=0

 
