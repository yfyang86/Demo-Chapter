(C<-runif(10,0.2,0.3))
(A<-runif(10,0,3))
(B<-rnorm(10,0,1))
(ans<-c(0,1,1,0,1))
x.total<-c()
Pro <- 1         # init Pro
lock.count=1     # a thread lock, should change the value befor use

post<-Vectorize(function(x,...){

  if(r==1) {Pro <<- 1}
  
  Prob <- C[j]+(1-C[j])/(1+exp(-1.7*A[j]*(x-B[j])))
  if (lock.count==1) {
    if (ans[r] == 1) {
      Pro <<- Pro*Prob
      } else{
        Pro <<- Pro*(1-Prob)
      }
    lock.count <<- lock.count+1;   # lock Pro value
  }else{
    if (ans[r] == 1) {
      Pro <- Pro*Prob
    } else{
      Pro <- Pro*(1-Prob)
    }
   
  }
  
   
  return ((Pro*dnorm(x,0,1)));
},vectorize.args ="x")


infor<-Vectorize(function(x,...){
  if(n==1) {pdf1<-dnorm(x,0,1)}  else { pdf1<- post(x=x,r=r)}
  P <- C[j]+(1-C[j])/(1+exp(-1.7*A[j]*(x-B[j])))
  Q <- 1-P
  infoo<-((1.7^2*A[j]^2)*((P-C[j])/(1-C[j]))^2*Q/P)*pdf1
  infoo
},vectorize.args ="x"
)



for (n in 1:5){
  
  info<-c()
  for (j in 1:10) {  
  if (n==2) Pro=1 # r=n-1 ==1 ARE YOU SURE? in your code, you said r==1 then Pro=1, but that means n==2!!!
    info[j]<-integrate(infor, lower = -4, upper = 4,A=A,B=B,C=C,n=n,r=n-1)$val
    lock.count <<- 1 # unlock
  }
  r = n
  x.est<-optimize(post,c(-18,18),maximum=T)$maximum
  lock.count <<- 1 # unlock
  x.total<-c(x.total,x.est)
}

