## @brief:  return TRUE if there were 
#           any number showing up more than 
#           3 times (i.e. >=4) continuously.

string.counting<-Vectorize(function(txt,lim=4){#Yifan
  #str_match(txt,"([0-9]+)")
  xx=strsplit(txt,split='')[[1]]
  yy=as.numeric(xx)
  xx.nan=!is.na(yy)
  xx.numericpart=yy;
  nu=sum(xx.nan);
  char=length(xx)-nu
  xx.numericpart[!xx.nan]=sample(-(1:10000),char)
  flag=F
  if (length(xx.numericpart[xx.nan])>lim){
    for (i in 1:(length(xx.numericpart)-lim+1)){
      tg=xx.numericpart[i];
      if (sum(xx.numericpart[i:(i+3)]==tg)==4) {flag=T;break;}
    }
  }
 
  return(list(length=nu+char,nu.len=nu,char.len=char,flags=flag,numeric=yy));
})
 
 
a=c("absadj102220aid000998","10000ans")
string.counting(a)
