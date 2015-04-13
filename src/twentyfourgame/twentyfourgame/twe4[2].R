guess24.lex <- function(numbers = c(2,3,7,3),target = 24){

print24 <- function(.lst,input_n){
s=''
if (.lst[1]=='2'){
	pp = c(5,2,6,3,7,4,8)
	s = paste(c("((",.lst[pp[1:3]],")",.lst[pp[4:5]],")",.lst[pp[6:7]]," = ",input_n),collapse='')
	cat(s,'\n')
}

if(.lst[1]=='1'){
	s= paste(c("(",.lst[c(5,3,6)],")",.lst[2],"(",.lst[c(7,4,8)],") = ",input_n  ) ,collapse='')
        cat(s,'\n')
	}

return(s);
}


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

evalLex <- function(lex){
pattern = lex[1]
op = lex[2:4]
nu = lex[5:8]
if (pattern == 1){
# Dictionary
# (a op2 b)op1(c op3 d)
# (5 3 6) 2 (7 4 8)
	re = paste('\"',op[1],'\"(\"',op[2],'\"(',nu[1],',',nu[2],'),\"',
		  op[3],'\"(',nu[3],',',nu[4],'))',sep=''
		  )
}

if (pattern == 2){ 
# Dictionary
# ((a op1 b) op2 c) op3 d
# "op3"("op2"("op1"(a,b),c),d)
# ((5 2 6) 3 7) 4 8
	re=paste('\"',op[3],'\"(\"',op[2],'\"(\"',op[1],'\"(',
		 nu[1],',',nu[2],"),",nu[3],'),',nu[4],')',sep=''
		)
}

gsub(" ",'',re)
}




oper = perm2(4,3)
number.perm = do.call(cbind,combinat::permn(1:4))
n.oper = ncol(oper)
OPS = c("+","-","*","/")


re=NULL
for (i in 1:n.oper){
for (j in 1:24){
for (patt in 1:2){
	lex1 = c(	patt, 
			OPS[oper[,i]],
			numbers[number.perm[,j]]
		)
	tmp = eval(parse(text=evalLex(lex1)))
	if ((! is.na(tmp)) & tmp == target){
	print(lex1)
	re = rbind(re,lex1)
        }        
}
}

}

colnames(re) = c("Patten","Op1","Op2","Op3",letters[1:4])
return(list(raw=re,str=apply(re,1,function(x) print24(x,target))));
}

guess24.lex(c(1,5,11,2),25)
