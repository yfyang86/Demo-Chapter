library(showtext)
font.add('xkcd3','xkcd3.ttf')
xkcd_codes <- data.frame(
  code=c('\u0080','\u0081','\u0082','\u0083','\u0084','\u0085','\u0086','\u0087','\u0088','\u0089'),
  chars=c('cloud','p1','partist','tree','board','p2','earth','simpson','sit','p3')
)
xkcd_codec = list()
for(i in 1:10) xkcd_codec[[i]]=as.character(xkcd_codes[i,1])
names(xkcd_codec) = as.character(xkcd_codes[,2])

pdf('./xkcd.pdf')
plot(1, type = "n",xaxt='n',yaxt='n',frame.plot=T,xlab='',ylab='')
showtext.begin()
text(.65, .85, xkcd_codec$partist, cex = 20, family = "xkcd3")
text(1, 1.1, xkcd_codec$cloud, cex = 20, family = "xkcd3")
text(1.15, 1.1, "MYSTERIES", cex =5, family = "xkcd3")
showtext.end()
dev.off()
