##### section 1

## Pr set 1
data(airquality)

pairs(airquality[,-c(5,6)])
boxplot(airquality[,-c(5,6)])

lattice::cloud(Ozone~Solar.R+Wind,airquality)

coplot(Ozone~Solar.R|Wind,airquality)



ad=c('chr0112203.223','chr01122.3','chr01122.31','chr011220.3','chr09122.3','chr09122.3|chr09122.2')

unlist(regexec("22.3$|22.3.chr",text =ad )) >0
