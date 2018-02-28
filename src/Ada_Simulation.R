set.seed(2016)
n=500
u=sort(runif(n)*2*pi)
y=sin(u)+rnorm(n)*2
df=data.frame(xx=u,yy=y,z=as.double(sin(u)*2+y+rnorm(n)/5>0))
nd=expand.grid(xx=seq(0,2*pi,length.out = 100),yy=seq(-6,6,length.out = 100))

x_gr = seq(0,2*pi,length.out = 100)

library(animation)


user_number_output<-function(n){
  if (n%%10==1) return(paste(n,'-st run',sep=''));
  if (n%%10==2) return(paste(n,'-nd run',sep=''));
  if (n%%10==3) return(paste(n,'-rd run',sep=''));
  return(paste(n,'-th run',sep=''));
  }


cols=c("red",'firebrick3','olivedrab4')
cols_pred=c("red",'magenta','green2')
cols_ss=c('firebrick2','chartreuse3')

VIS<-function(MM=5,mul=1){
  split.screen(rbind(c(0.1,0.98,0.35, 0.98), c(0.1, 0.98, 0.1, 0.32)))
  screen(1)
  par(mar = c(0, 0, 0, 0))
  plot(yy~xx,data=df,col=cols[df$z+2],xlab='x',ylab='y',pch=c("o",'x')[df$z+1],xaxt='n',yaxt='n',cex=1.5)
  points(x_gr,-2*sin(x_gr),type='l',lwd=2,lty=2)
  screen(2)
  par(mar = c(0, 0, 1, 0))
  plot(df$xx,rep(1/(dim(df)[1]),dim(df)[1]),type='h',col=1,
       ylab='weight',xlab='x',main=paste("Initial run, Error rate:",floor(1000*mean(df$z!= 1 ))/1000," %"),
       ylim=c(0,.08),lwd=1
  )
  close.screen(all.screens = TRUE)
  
  for(i in 1:MM){
    re_1 = ada(z~xx+yy,data=df,iter=i*mul)
    split.screen(rbind(c(0.1,0.98,0.35, 0.98), c(0.1, 0.98, 0.1, 0.32)))
    screen(1)
    par(mar = c(0, 0, 0, 0))
    plot(yy~xx,data=df,col=cols[df$z+2],xlab='x',ylab='y',pch=c("o",'x')[df$z+1],xaxt='n',yaxt='n',cex=1.5)
    points(x_gr,-2*sin(x_gr),type='l',lwd=2,lty=2)
    points(nd$xx,nd$yy,col=cols_pred[as.double(predict(re_1,nd))+1],pch=16,cex=.25)
    screen(2)
    par(mar = c(0, 0, 1, 0))
    plot(df$xx,re_1$model$lw,type='h',col=cols_ss[1+as.double(re_1$fit != df$z)],
         ylab='weight',xlab='x',
         main=paste(user_number_output(i*mul),"Error rate:",floor(1000*mean(df$z!=re_1$fit))/1000," %"),
         ylim=c(0,4/n)
         ,lwd=1
         )
    close.screen(all.screens = TRUE)
  }
  
}


ani.options(ani.width=900,ani.height=900)
saveHTML(expr={VIS(MM=2,mul=25)},htmlfile='demo.html' ) # MAKE HTML

#MAKE GIF
ani.options(convert="C:/Rtools/mingw_64/bin/convert.exe")
saveGIF(expr = {
  VIS(10);
}, movie.name = "ada.gif", interval =.5, nmax = 30, ani.width = 900, 
ani.height = 900)

################################################
## COMPARISON: CART vs. BOOSTING vs. BAGGING ###
################################################

df2 = df
df2$z = as.factor(df$z)

pdf('comp.pdf',width = 10,height = 6)
par(mfrow=c(1,3))
par(mar = c(0.5, 0.5, 1.5, 0.5))
re_CART <- rpart(z~.,data=df, maxdepth = 2)
pred_CART <- predict(re_CART, nd)

plot(yy~xx,data=df,col=cols[df$z+2],xlab='x',ylab='y',pch=c("o",'x')[df$z+1],cex=1,xaxt='n',yaxt='n', main="Single")
points(x_gr,-2*sin(x_gr),type='l',lwd=2,lty=2)
points(nd$xx,nd$yy,col=cols_pred[as.double(pred_CART>.5)+2],pch=16,cex=.25)

re_1 = ada(z~xx+yy,data=df,iter=50)
plot(yy~xx,data=df,col=cols[df$z+2],xlab='x',ylab='y',pch=c("o",'x')[df$z+1],cex=1,xaxt='n',yaxt='n', main="Boosting")
points(x_gr,-2*sin(x_gr),type='l',lwd=2,lty=2)
points(nd$xx,nd$yy,col=cols_pred[as.double(predict(re_1,nd))+1],pch=16,cex=.25)


re_bag <- bagging(z~.,data=df2, mfinal=50)
ss = predict(re_bag,nd)
plot(yy~xx,data=df,col=cols[df$z+2],xlab='x',ylab='y',pch=c("o",'x')[df$z+1],cex=1,xaxt='n',yaxt='n', main='Bagging')
points(x_gr,-2*sin(x_gr),type='l',lwd=2,lty=2)

points(nd$xx,nd$yy,col=cols_pred[as.double( ss$class)+2],pch=16,cex=.25)



dev.off()

