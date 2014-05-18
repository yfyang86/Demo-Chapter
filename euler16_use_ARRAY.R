# 
# @brief LONG INT calculation
# Power digit sum
# Problem 16
# 215 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
# What is the sum of the digits of the number 21000?
# @para: n 2^n


f16L <- Vectorize(function(n){
  if (!is.integer(n)) stop("must be int");
  if (n<=0) stop('must be >0')
  if (n>3318) stop('Temp: n<=3318')
  dig.num=rep(0L,1000)
  # 38: rev(digits)
  digits <- as.integer(unlist(strsplit(as.character(2), split = "")))
  dig.num[1] <- rev(digits)
  for (i in 1:(n-1)){
    dig2 <- dig.num *2
    dig3 <- dig2 %%10
    dig4 <- floor(dig2/10)
    dig.num <- dig3 + c(0,dig4[-302])
  }  
  sum(dig.num)
})

#f16L(c(25L,1000L))
