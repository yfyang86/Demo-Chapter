

plotautoadj<-function(x,y,scalors=400,...){
  id <- sort(x,index.return = TRUE)$ix
  scalor= abs(diff(range((x-min(x))/diff(range(x)))))
  x <- x[id]
  y <- y[id]
  sc<- (quantile(x)[4]-quantile(x)[2])*scalors/length(x)
  u = which(diff(x) > sc)
  if (length(u)>0){
    uu = min(u-1)
    uu1 = uu-1
    vv=diff(range(x[uu:length(x)]))
    x1 = c(x[1:uu1],
           (x[uu:length(x)]-x[uu1])/vv+2*scalor+x[uu1]
           )
    plot(x1,y,yaxt='n',xaxt='n',...)
    xran=range(x[1:uu1])
    xran2=range( (x[uu:length(x)]-x[uu1])/vv+2*scalor+x[uu1])  
    xe1=seq( xran[1], xran[2] , length.out =5)
    xe2=seq( xran2[1], xran2[2] , length.out =3)
    axis(1,at=xe1,ceiling(100*c(xe1))/100,las=2,
         col.axis ="blue")
    axis(1,at=max(xe1)/2+min(xe2)/2,'...',col.axis ="darkred",col.ticks = "darkred")
    
    axis(1,at=xe2,ceiling(100*c(vv*(xe2-2*scalor-x[uu1])+x[uu1]))/100,las=2,
         col.axis ="red")
        
  }else{
    plot(x,y,...)
  }
    
}

N = 1000
y = c(runif(N),.1,.2,.25,.9)
x <- c(2*abs(rnorm(N)),10,20,25,30)

plotautoadj(x,y,scalors=1000,xlab='usrX',ylab='Val',main='Demo plot')
