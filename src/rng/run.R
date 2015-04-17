dyn.load("callSample.so");
N=1e5
prob <- abs(dnorm( 1:50/50 ) )
prob <- prob/sum(prob)

f1 <- function(x,samplesize,seed=1234){
  seed= floor(seed)
  samplesize = as.integer(samplesize)
  n=length(x)
  x= as.double(x);
  re = .C("ReplacedSample",prob,n,samplesize,seed)
}

f1(prob,N)

save.image("prob.RData")



