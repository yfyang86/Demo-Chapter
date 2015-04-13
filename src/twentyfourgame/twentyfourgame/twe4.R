#!/usr/local/bin/R

perm2 <- function(n,m){
if (m == 1){
 matrix(return(1:n),nrow=1)
}else{
re = perm2(n,m-1)
u = NULL
for (i in 1:n){
	u= cbind(u,rbind(i,re))
}
return (u)
}
}

guess24 <- function(input_n = 24,groups = c(2,3,6,7)){
ops = c("+","-","*","/")
# patten 1

finalre = list()
iop=1


p1 <- function(ops,groups){
re = floor(get(ops[1])(groups[1],groups[2]))
l = length(ops)
for (i in 2:l) re = floor(get(ops[i])(re,groups[i+1]))
return(re);
}

UUZ =  do.call(cbind,combinat::permn(1:4))

p1.check = perm2(4,3)
p0.check = UUZ

#print("Patten 1: a?b?c?d")
for (j in 1:24){
for (i in 1:ncol(p1.check)){
	re9=p1(ops[p1.check[,i]],groups[p0.check[,j]])
	if (re9==input_n){ # Line 1
#	cat("Result: ",ops[p1.check[,i]],groups[p0.check[,j]],"\n")
	finalre[[iop]] = c(1,ops[p1.check[,i]],groups[p0.check[,j]])
	iop = iop + 1
	}
}
}
# patten 2
#print("Patten 2: (a?b?c)*/d")
# p2.mul 2
# p2.div 3
ops2 = c("+","-","/")
ops3 = c("+","-","*")

UUZ2 = perm2(3,2)
for (j in 1:24){
for (i in 1:ncol(UUZ2)){
	re=p1(ops2[UUZ2[,i]],groups[p0.check[,j]])
    re="*"(re,groups[p0.check[4,j]])
	if (re==input_n){# lp0
#	cat("Result: ",ops2[UUZ2[,i]],"*",groups[p0.check[,j]],"\n")
	finalre[[iop]] = c(2,ops2[UUZ2[,i]],"*",groups[p0.check[,j]])
	iop = iop+1
	}
}
}


for (j in 1:24){
for (i in 1:ncol(UUZ2)){
	re=p1(ops2[UUZ2[,i]],groups[p0.check[,j]])
    re="/"(re,groups[p0.check[4,j]])
	if (re == input_n){# lp
#	cat("Result: ",ops2[UUZ2[,i]],"/",groups[p0.check[,j]],"\n")
	finalre[[iop]] = c(2,ops2[UUZ2[,i]],"/",groups[p0.check[,j]])
	iop = iop+1
	}
}
}

# Pattern 3: (+-)*/(+-)
#print("Patten 3")
ops3.1 = c("+","-")
UUZ3 = perm2(2,2)

pattern3 <- function(ops,groups,midop="*"){
get(midop)(
		get(ops[1])(groups[1],groups[2]),
		get(ops[2])(groups[3],groups[4])
		)
}

for (j in 1:24){
for (i in 1:ncol(UUZ3)){
	re6=pattern3(ops3.1[UUZ3[,i]],groups[p0.check[,j]])
	if (re6==input_n){ # lp1
	finalre[[iop]] = c(3,ops3.1[UUZ3[,i]],"*",groups[p0.check[,j]])
	iop = iop+1
	}
}
}


for (j in 1:24){
for (i in 1:ncol(UUZ3)){
	re5=pattern3(ops3.1[UUZ3[,i]],groups[p0.check[,j]],"/")
	if ((!is.na(re5)) & re5==input_n){ # lp2
	finalre[[iop]] = c(3,ops3.1[UUZ3[,i]],"/",groups[p0.check[,j]])
	iop = iop+1
	}
}
}





print24 <- function(.lst){
if (.lst[1]=='1'){
#	#print("Pattern 1")
	pp = c(5,2,6,3,7,4,8)
	s = paste(c("((",.lst[pp[1:3]],")",.lst[pp[4:5]],")",.lst[pp[6:7]]," = ",input_n),collapse='')
	cat(s,'\n')
}else{
	if(.lst[1]=='2'){
#	#print("Pattern 2")
	pp = c(5,2,6,3,7)
	pp2 = c(4,8)
	s=paste(c("((",.lst[pp[1:3]],")",.lst[pp[4:5]],")",.lst[pp2]," = ",input_n),collapse='')
	cat(s,'\n')
	}else{
	s= paste(c("(",.lst[c(5,2,6)],")",.lst[4],"(",.lst[c(7,3,8)],") = ",input_n  ) ,collapse='')
    cat(s,'\n')
	}
}
return(s);
}
#print("Clean")
StrRe = lapply(print24,X=finalre)

StrRe = unique(StrRe)

return(list(raw = finalre, str = do.call(c,StrRe)));
}


# example

#guess24(24,c(2,2,3,3))
