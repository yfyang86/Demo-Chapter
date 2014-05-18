## @brief:  return TRUE if there were 
#           any number showing up more than 
#           lim=4 times (i.e. >=5) continuously.

string.counting<-Vectorize(function(txt,lim=5){#Yifan
  #str_match(txt,"([0-9]+)")
  xx=strsplit(txt,split='')[[1]]
  yy=as.numeric(xx)
  xx.nan=!is.na(yy)
  xx.numericpart=yy;
  nu=sum(xx.nan);
  char=length(xx)-nu
  xx.numericpart[!xx.nan]=sample(-(1:10000),char)
  flag=F
  tg.chars=NA
  if (length(xx.numericpart[xx.nan])>lim){
    for (i in 1:(length(xx.numericpart)-lim+1)){
      tg=xx.numericpart[i];
      if (sum(xx.numericpart[i:(i+lim-1)]==tg)==lim) {tg.chars=tg;flag=T;break;}
    }
  }
  
  return(list(length=nu+char,nu.len=nu,char.len=char,flags=flag,numeric=yy,tg=tg.chars));
})


a=c("absadj102220aid000999998","10000ans",'ABC')
string.counting(a)
