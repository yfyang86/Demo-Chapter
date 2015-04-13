IPtranfrom2 = function(x){
if (x >= 256^4 ) stop(">255.255.255.255")
x1 <- bitwShiftR(bitwAnd(x,-1),24) # 24 bit 
x2 <- bitwShiftR(bitwAnd(x,16777215L),16) # 65536 -> 16 bit
x3 <- bitwShiftR(bitwAnd(x,65535L),8) # 256 -> 8bit
x4 <- bitwAnd(x,255L)
y = paste(x1,x2,x3,x4,sep=".")
return(y);
}

x= 117710
IPtranfrom2(x)
x=100000000000
IPtranfrom2(x)
