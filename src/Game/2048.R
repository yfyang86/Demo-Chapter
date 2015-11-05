# 2048
# Author: Yifan Yang <Yfyang.86@gmail.com>
# License: GPL
n = 5
stormatrix2 <- matrix (0, n,n)
  
colockRotateMat <- function(x) t(x)[,ncol(x):1]
anticolockRotateMat <- function(x) apply(x,1,rev)
upsidedownMat <- function(x) x[nrow(x):1,]
del0vec <- function(x) {y=rep(0,length(x));n = sum(x!=0);if(n>0){y[1:n]=x[x!=0]}else{y=x};y}
del0Matbycol <- function(x) apply(x,2,del0vec)
  
press.up <- function(stormatrix2){
#stormatrix = stormatrix2
    n = dim(stormatrix2)[1]
    stormatrix2=del0Matbycol(stormatrix2)
    for ( i in 1:(n-1)){
        r1 = stormatrix2[i,]
        r2 = stormatrix2[i+1,]
        merge.ind = which((r1-r2)==0)
        if(length(merge.ind)>0){
         stormatrix2[i,merge.ind] = stormatrix2[i,merge.ind] *2
         if (i < (n-2)){
            stormatrix2[(i+1):(n-1),merge.ind] = stormatrix2[(i+2):n,merge.ind]
            }else{
             stormatrix2[i+1,merge.ind] = stormatrix2[n,merge.ind]
            }
            stormatrix2[n,merge.ind] = 0
         }
        }
        cat("Score = ",sum(stormatrix2),"\n")
        if ( sum(stormatrix2>0) == (n*n)) stop("Finish")
        return(stormatrix2);
}
  
  
press.left <- function(stormatrix2) anticolockRotateMat(press.up(colockRotateMat(stormatrix2)))
press.right <- function(stormatrix2) colockRotateMat(press.up(anticolockRotateMat(stormatrix2)))
press.down <- function(stormatrix2) upsidedownMat(press.up(upsidedownMat(stormatrix2)))
      
  
colorpat = colors()[c(3:5,37:40,90:94,32:36)]
#Pick up colors from R rgb document.
  
Draw2048 <-function(stormatrix2,...){
    n=dim(stormatrix2)[1]
    plot(c(0, n+1), c(0, n+1), axes=F,frame.plot=F, xaxt='n', yaxt='n',type="n",
     main = "2048'",xlab='',ylab='');
    for (i in 1:n){
      for (j in 1:n){
         y = n - i
         x = j - 1 
         rect(.5+x,.5+y,1.5+x,1.5+y,col=colorpat[1+floor(log(stormatrix2[i,j])/log(2))])
         text(x+1,y+1,stormatrix2[i,j])
        }
    }
}
  
stormatrix2 <- sample(2^c(1:3),n*n,replace=T);
dim(stormatrix2) = c(n,n)
Draw2048(stormatrix2)
  
  
for (i in 1:100){
cat("Input w↑a←s↓→d<CR↲>: ")
uu = readline()
if( uu%in%c('s','a','w','d','n')){
if (uu=="s") { stormatrix2 =  press.down(stormatrix2); Draw2048(stormatrix2)}
if (uu=="a") { stormatrix2 =  press.left(stormatrix2); Draw2048(stormatrix2)}
if (uu=="w") { stormatrix2 =  press.up(stormatrix2); Draw2048(stormatrix2)}
if (uu=="d") { stormatrix2 =  press.right(stormatrix2); Draw2048(stormatrix2)}
if (uu=='n') break;
LLindex = which(stormatrix2==0)
if (length(LLindex) >0) stormatrix2[sample(LLindex,1)]=sample(2^c(1:3),1);
}else{
cat("Key in w/a/s/d/n\n");
}
}
