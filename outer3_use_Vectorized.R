##  anoter "outer" function 
# @brief 3-layer-without-loops
#       f(x,y,z)
# @para x,y,z array
#       f     function(x,y,z,...)
#       mat   double number used in ...
#

cross3<-function(x,y,z,func,...){#func MUST be vectorized
  func<-match.fun(func);
  length(x) -> x.l
  length(y) -> y.l
  length(z) -> z.l

  X <- rep(x,rep.int(z.l*y.l,x.l));
  Y <- rep(rep(y,each=z.l),x.l);
  Z <- rep(z,times=y.l*x.l);
  func(X,Y,Z,...)
}



#############
## Comparison
#############

f.test<-Vectorize(function(x,y,z,mat){
  return(c(x+y+z+mat,x*y*z-mat));# I highly suggest using a vector/array here
    },
    vectorize.args =c('x','y','z')
    )


##  cross.noncir
# @brief 3-for-loops
# @para x,y,z array
#       f     function(x,y,z,...)
#       mat   double number used in ...

cross.noncir <- function(x,y,z,f,mat){
  length(x) -> x.l
  length(y) -> y.l
  length(z) -> z.l
  re<- rep(0,x.l*y.l*z.l*2)
  dim(re)<-c(x.l,y.l,z.l,2)
  ii=0;jj=0;kk=0
  for (i in x){ii=ii+1;jj=0;
    for (j in y) {jj=jj+1;kk=0
      for (k in z) {kk=kk+1
        re[ii,jj,kk,1:2]=as.double(f(x[ii],y[jj],z[kk],mat))
      }
    }
  } 
  re
}

 x=500:600
 y=300:400
 z=10:20
 system.time( re0<-cross3(x,y,z,f.test,mat=0) ) 
 system.time( re2<-cross.noncir(x,y,z,f.test,mat=2) )
 
