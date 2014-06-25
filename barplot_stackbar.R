# 

statckbar<-function(data,cols,pct=50){
  
  data1<-t(data.matrix(data))*100
  
  colnames(data1) <- 1:dim(data1)[2]
  
  nn=dim(data1)[1]
  
  ll=unique(c(0,seq(from = ceiling(-max(colSums(data1[,-nn]))*1.01),to=ceiling(max(data1[nn,])),length.out = 5)))
  
  if (pct<max(abs(ll))) pct=max(abs(ll))
  if (length(cols)<dim(data1)[1]) cols=rainbow(dim(data1)[1])
  
  barplot(-data1[-nn,], main="Demo",
          xlab="Percentages", col=cols[-nn],
          horiz=TRUE,xlim=c(-pct,pct),xaxt='n')
  
  par(new=T)
  barplot(data1[nn,], main="",
          xlab="Percentages", col=cols[nn],
          horiz=TRUE,xlim=c(-pct,pct),xaxt='n')
  axis(2,labels=F)
  ll = seq(from = -pct,to=pct,length.out = 5)
  axis(1,
       at=sort(ll),
       labels=abs(ceiling(sort(ll)))
  )
  legend('topright',legend=rownames(data1),col=cols,pch=15)
  grid()
  par(new=F)
}


data<-data.frame(
  A=abs(runif(10))*.2,
  B=abs(runif(10))*.1,
  C=abs(runif(10))*.05,
  D=abs(runif(10))*.4
)

cols=c(
  rgb(153/256,255/256,153/256,alpha =.8),
  rgb(103/256,178/256,255/256,alpha =.8),
  rgb(255/256,255/256,153/256,alpha =.8),
  rgb(204/256,255/256,255/256,alpha =.8)
)

statckbar(data,cols,20)
