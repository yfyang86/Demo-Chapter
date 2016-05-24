library(png)

cc_lol<-function(iicons,lolMap,paths,imga_name,delay_time, outgif='out.gif'){
  ff_des <- function(i,n){
    u = rep(0,n)
    fg = FALSE;
    if (i ==0 ) {
      return(u);}else{
        nn = ceiling(log(i)/log(10))
        if (i%%(10^nn)==0) {nn = nn+1}
        for (nnn in 1:nn){
          u[nnn] = i %% 10
          i = floor(i/10)
        }
        
      }
    rev(u)
    paste(rev(u),collapse='')
  }
  
  for(iii in 1:10){
    png(paste(imga_name,ff_des(iii,4),'.png',sep='',collapse = ''))  
    plot(x=0:1,y=0:1,type='n',frame.plot = F,xaxt='n',yaxt='n',xlab='',ylab='')
    rasterImage(lolMap_raster,0,0,1,1) ## bg
    for(i in 1:iii){
      uu=paths[i,]
      rasterImage(iicons,uu[1],uu[2],uu[1]+.075,uu[2]+.075) 
      uuu = paths[i:(i+1), ]
      points(x=uuu[,1],y=uuu[,2],type = 'l',lty=2,lwd=1,col='white')
    }
    dev.off() 
  }
  
  system(paste("convert -delay", delay_time,"-loop 0 img*.png",outgif))
}

cc_lol(
  lolMap = readPNG("./Pictures/lol.png"),
  iicons = readPNG("./Pictures/acfun.png"),
  paths = matrix( (runif(22)+.3)/1.4,ncol=2),
  imga_name = "img",
  delay_time = 500
)


