# set locale UTF-8, Chinese

print.ch<-function(mat){
 
  for (i in 1:nrow(mat$data)){
    if(i!=(floor(nrow(mat$data)/2)+1)){cat('\n   | ')}else{cat('\ndet| ')}
    for (j in 1:ncol(mat$data))
      cat(mat$data[i,j],' ')
    if(i!=(floor(nrow(mat$data)/2)+1)){cat('|') }else{cat(' | = ',mat$ch)} 
  }
 
}
 
det.char<-function(mat){
  re<- paste(diag(mat),collapse='')
  re2<- paste(diag(apply(mat,1,rev)),collapse=''); #antidiag
  rere<-list(ch=paste(re,re2,sep='一'),data=mat);
  class(rere)<-'ch';
  return(rere);
}
 
mat<-matrix(c('我',' ','生',' ' ,'有',' ','你',' ','幸'),byrow=T,nrow=3)#UTF-8
det.char(mat)
Sys.setlocale(category = "LC_CTYPE", locale= "zh_CN.UTF-8")
det.char(mat)
