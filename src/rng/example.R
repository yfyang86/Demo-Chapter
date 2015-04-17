#!/usr/bin/Rscript
#setwd("/home/yifan/git/Demo-Chapter/src/rng")
system("Rscript run.R > re1.log")
re=data.matrix(read.csv("re1.log")) 
load("prob.RData") 
plot(as.double(table(re)/N),type='s') 
points(prob,cex=.2,col=2)

