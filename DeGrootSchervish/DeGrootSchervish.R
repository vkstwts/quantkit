# TODO: Add comment
# 
# Author: torenvln
###############################################################################


#Ex. 3.4.3
xx <- seq(-2,2,len=200)
yy <- seq(0,2,len=200)
zFunc <- function(x,y){ifelse(x^2 < y & y < 1, 3*x^2*y, NA)}
z <- outer(xx,yy,zFunc)
persp(xx,yy,z,theta=30,phi=30,ticktype="detailed")

#Ex. 3.4.6
xx <- seq(-2,4,len=200)
yy <- seq(-2,4,len=200)
zFunc <- function(x,y){ifelse(0 < y & y <2 & 0 <x & x < 2 , 1/16*x*y*(x+y), NA)}
z <- outer(xx,yy,zFunc)
persp(xx,yy,z,theta=30,phi=30,ticktype="detailed")





