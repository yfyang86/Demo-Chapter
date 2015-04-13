# DEMO 1
# transf  Mat[,] to
# rbind(mat[,1:4],mat[,5:8],...)


mat <-  matrix(1:36,byrow=T,nrow=3)


f2<-function(mat){
 dims=dim(mat)
 m=dims[1]
 n=dims[2]
 if (n%%4 != 0) stop('wrong')
 L= n/4
f <- Vectorize(function(i,...){
	mat[,(4*i-3):(4*i)]
},"i",F)


do.call(rbind,f(1:L))
}


f2(matrix(1:60,byrow=T,nrow=5))

## DEMO 2

data1 =  matrix(runif(9),nrow=3)
index<- list(1:3,2:3,3)

f<-function(i,...) sum(data1[index[[i]],1:i])
f2<- Vectorize(f,'i')

f(1:3)  # WRONG
f2(1:3)  # equ to 
c(f(1),f(2),f(3))


## DEMO 3
# use LIST/Matrix in pvec


library(parallel)

mat <- runif(1000*10000)
dim (mat) <- c(1000,10000)

f1  <- Vectorize(function (i,...){  # IMPORTANT!
	sum(mat[i,])
},
"i"
)

index<-list(1:3,2:100,1:1000)
pvec(unlist(index),f1,mat=mat,mc.cores=20) -> re # well, if you use vectorize, pvec is better

re.split = c(0,cumsum(do.call(c,lapply(index,length))))
for (i in 1:3) cat(sum(rowSums(mat[index[[i]],]) == re[(re.split[i]+1):re.split[i+1]] )==length(index[[i]]),'\n')   # check the result



