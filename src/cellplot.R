# Request: http://www.zhihu.com/question/21664179

f1 <- function(x) -x^2
f2 <- function(x) -x^2+.5


x = seq(-2,.5,.1)

plot(x,f1(x), type='n', 
     ylim = c(-5,1), xlim = c(-2.5,.5), 
     xaxt='n', yaxt='n',main='',xlab='',ylab='')

lines(x,f1(x),lty=1, lwd=2)
lines(x,f2(x),lty=2, lwd=2)
grid(nx=6,ny=6,col='black')

points(
  x=c(-1.75+(0:4)/2, -1.75, -1.25), y=c(rep(.5,5), -.5,-.5),
  pch=16,
  cex=2
  )

points(
  x=c(.25, .75, -.25,.25,-.75)-.5,y=c(-.5,-.5,-1.5,-1.5,-2.5),
  pch=13,
  cex=2
)

points(
  x=c(.25, .75, -.25,.25,-.75),y=c(-.5,-.5,-1.5,-1.5,-1.5)-1,
  pch=12,
  cex=2
)

points(
  x=c(-1.25, -.75),y=c(-1.5, -.5),pch=10, cex=1
)

text(-2.25,-3.5,"n")
text(-2.25,-4,"n+1")

IP = c(-1,0)
BI = c(-.5,-1)
IPBI= rbind(IP,BI)

polygon(
  x = c(-1.25, BI[1], -.75,-1.25),
  y = c(-.5, BI[2], .5,.5),
  col = rgb(.25,.25,.25,.25)
)

points(IPBI[,1],IPBI[,2],type='b')
text(IP[1]-.1,IP[2],"IP")
text(BI[1]+.1,BI[2],"BI")

add_legend <- function(...) {
  opar <- par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0), 
              mar=c(0, 0, 0, 0), new=TRUE)
  on.exit(par(opar))
  plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
  legend(...)
}

add_legend("bottom",legend = c("Fluid-Cell", "Ghost-cell", "Solid-Cell", "Fresh-Cell"),
       pch=c(16,13,12,10),box.lty =0, horiz=T)
