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
  
  for(iii in 1:50){
    png(paste(imga_name,ff_des(iii,4),'.png',sep='',collapse = ''),width = 720, height = 720)  
    plot(x=0:1,y=0:1,type='n',frame.plot = F,xaxt='n',yaxt='n',xlab='',ylab='')
    rasterImage(lolMap,0,0,1,1) ## bg
    for(i in 1:iii){
      uu=paths[i,]
      iicons2=iicons
      iicons2[,,1:3] = iicons[,,1:3]/(iii/i)^2
      rasterImage(iicons2,uu[1],uu[2],uu[1]+.075,uu[2]+.075) 
      uuu = paths[i:(i+1), ]
      #points(x=uuu[,1],y=uuu[,2],type = 'l',lty=2,lwd=1,col='white')
    }
    dev.off() 
  }
  
  system(paste("convert -delay", delay_time,"-loop 0 img*.png",outgif))
  ## mp4: use ffmpeg
  ## ffmpeg -framerate 4 -s hd720 -i img%04d.png -c:v libx265 -vf fps=25 -vf scale=720:720 out.mp4
}


paths = matrix(0,nrow=51,ncol=2)
paths[1,] = c(.5,.5)
paths_len = runif(100)/10
paths_direct = matrix(sample(c(-1,1),100,replace = T,prob = c(.5,.5)),nrow=50,ncol=2)
paths_sep = paths_direct*paths_len
paths[-1,] = paths_sep
paths[,1] = cumsum(paths[,1])
paths[,2] = cumsum(paths[,2])

cc_lol(
  lolMap = readPNG("./Pictures/lol.png"),
  iicons = readPNG("./Pictures/acfun.png"),
  paths = paths,
  imga_name = "img",
  delay_time = 100
)


