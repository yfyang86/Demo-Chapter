sam <- function(digs, n){
Ndigs = floor(digs * 2^32) # 32 bit only
 
#decimal to bin, string
str= paste(sapply(strsplit(paste(rev(intToBits(Ndigs))),""),`[[`,2),collapse="")
strar = as.numeric(strsplit(str,'')[[1]])
 
# a simple ">" for binary numbers
binarygt <- function (x,y){
x-y -> u
which(u<0) -> u1
which(u>0) -> u2
if (length(u2)==0) return(F);
if (length(u1)==0) return(T);
u1 = u1[1]
u2 = u2[1]
if ( u1 > u2) return(T);
return(F);
}
uu = matrix(sample(0:1, 32*n,T),nrow=32)
1-apply(uu,2,binarygt,y=strar)
}
 
# test
 
re = sam(digs = pi - 3, n=10000)
mean(re)
