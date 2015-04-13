require('jpeg')
readJPEG('./data/th03.jpg') -> pic1

rn<-rnorm(10000)*2
hist(rn,col=rgb(0,0,0,alpha=.1),probability=T,xlim=c(-8,8)) -> re

#demo 1
plot(x=c(-8,8),y=c(0,max(range(re$density))),type='n')
rasterImage(pic1,min(re$breaks),0,max(re$breaks),range(re$density)[2])
hist(rn,add=T,col=rgb(0,0,0,alpha=.1),probability=T,xlim=c(-8,8)) -> re


#demo2
dim(pic1)[1:2] -> dims
ranges.y <- ceiling(dims[1] * re$density/max(re$density))
ranges.y[ranges.y==max(ranges.y)]=ranges.y[ranges.y==max(ranges.y)]-1
ranges.x <- floor(dims[2]*(-min(re$breaks)+(re$breaks))/diff(range(re$breaks)))+1
ranges.x[ranges.x==max(ranges.x)]=ranges.x[ranges.x==max(ranges.x)]-1


pic2=pic1# a copy

for (i in 1:length(ranges.y)){
  pic2[dims[1]-(ranges.y[i]:(dims[1]-1) ),(ranges.x[i]:ranges.x[i+1]),1:3] = 1
}# image 1.  x-axis -> col , 2. y-axis -> row, 3. reverse!!!


plot(x=c(-8,8),y=c(0,max(range(re$density))),type='n',ylab='',xlab='',yaxt='n',xaxt='n')
rasterImage(pic2,min(re$breaks),0,max(re$breaks),range(re$density)[2])
hist(rn,add=T,col=rgb(0,0,0,alpha=.1),probability=T,xlim=c(-8,8)) -> re
