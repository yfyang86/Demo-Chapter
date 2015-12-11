colorizedplot <- function(x,x_axis=1:length(x),add =F, cols = rainbow(100), rev =F){

  colors = cols

  if(rev){
    xlim_u = rev(range(x_axis))
  }else{
    xlim_u = range(x_axis)

  }


  if(length(cols)>1){
    alpha.max = max(x)
    alpha.min = min(x)
    max.alpha <- max(x)
    min.alpha <- min(x)

    if (add==F) plot( x_axis[1:(length(x))],x, type="n", xlab="x", ylab="y", main="trace", xlim = xlim_u, ylim = c(-alpha.max,alpha.max)*1.125)
    max.y <- max(axTicks(4))
    min.y <- min(axTicks(4))
    LLL = length(x)

    grid(ny=5,nx=0,col='gray')
    abline(h = 0, lty =1, col="gray")

    tryCatch({
      alpha.ticks <- approxfun(c(min.y, max.y),
                               c(min.alpha, max.alpha)) ( axTicks(4))
      alpha2y <- approxfun(c(min(alpha.ticks), max(alpha.ticks)),
                           c(min.y,max.y))
      col.cutoffs <- rev(seq(min.alpha,max.alpha, length=length( colors )))
      display.bool <- (col.cutoffs >= min(alpha.ticks) &
                         col.cutoffs < max(alpha.ticks))
      y.lower <- alpha2y( col.cutoffs )[display.bool]

      colors <- colors[display.bool]

      y.width <- y.lower[2] - y.lower[1]
      y.upper <- y.lower + y.width
      if (rev){
        x.left <- x_axis[1] - diff(range(x_axis))*0.05 
        x.right <- x_axis[1] - diff(range(x_axis))*0.075 
      }else{
        x.left <- x_axis[LLL] + diff(range(x_axis))*0.05 
        x.right <- x_axis[LLL] + diff(range(x_axis))*0.075 
      }

      rect(x.left, y.lower, x.right, y.upper,
           col=colors, border=colors,xpd=NA)

    }, error=function(e) warning("No color palatte.")

    )

    l_col = length(colors)
      segments(x0 = x_axis[1:(length(x)-1)], x[-length(x)] ,
             x1 = x_axis[2:length(x)], x[-1],
             col  =colors[sapply(l_col+1-ceiling(rank(abs(x) )*l_col/LLL),min,l_col)],
             lwd = 1)
  }else{
    if (add==F){
      plot(x_axis[1:(length(x))],x, type="l", xlab="x", ylab="y", main="trace",col=cols, xlim = xlim_u)
    }else{
      points(x_axis[1:(length(x))],x, type="l", xlab="x", ylab="y", main="trace",col=cols)
    }

  }

  max_inx = which.max(x)
}




plot_colorized2 <- function(dta,cols= rainbow(100), rev =F){
  dta = dta[order(dta[,1]),]

  nnn = nrow(dta)-1
  for (nn in 1:(nnn)){
    as.data.frame(cbind(
      seq(dta[nn,1], dta[nn+1,1],length.out =10),
      seq(dta[nn,2], dta[nn+1,2],length.out =10))) -> tmp
    names(tmp) <- names(dta)

    dta = rbind(dta,  tmp
    )
  }

  dta = dta[order(dta[,1]),]
  colorizedplot(dta[,2],dta[,1], cols= cols, rev=rev)

}

dta = data.frame(rnorm(100),rnorm(100))

plot_colorized2(dta, cols=rainbow(256)[1:180],rev=T)
