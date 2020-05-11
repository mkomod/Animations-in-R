library(RColorBrewer)
c.p <- colorRampPalette(rev(brewer.pal(9, "Spectral")))

f <- function(x, y) x^2 - y^2          # saddle
f <- function(x, y) x^2 + y^2          # convex
f <- function(x, y) -x^2 - y^2
f <- function(x, y) { r <- sqrt(x^2+y^2); 10*sin(r)/r }

x <- y <- seq(-10, 10, by=0.5)
z <- outer(x, y, f)
z.c <- (z[-1, -1] + z[-1, -ncol(z)] + z[-nrow(z), -1] 
	+ z[-nrow(z), - ncol(z)])/4
z.range <- cut(z.c, 100)
cols <- c.p(100)

gifname <- "saddle"
system("mkdir anim")

for (i in 0:360) {
    jpeg(paste0("./anim/", sprintf("%03d", i), ".jpg"), width=720, height=480) 
    persp(x, y, z, theta=i/2, phi=30,
	  col=cols[z.range], expand=1, border=T, box=F, lwd=0.2)
    dev.off()
}

system(paste0("ffmpeg -f image2 -framerate 40 -i ./anim/%3d.jpg ./anim/",
	      gifname, ".gif"))
system("rm ./anim/*.jpg")

