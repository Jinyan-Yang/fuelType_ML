source('r/load.R')
source('r/get_color4ft.R')
# 
out.ra <- readRDS('cache/ft.fine.access.hist.rds')
# 
lat.vec <- -c(37.33588,37.38554,37.38554,37.33588)
lon.vec <-  c(147.27566,147.27566,147.32566,147.32566)
p = spPolygons(matrix(c(lon.vec,lat.vec), ncol=2, byrow = F))

# 
value.vec <- unique(out.ra)
# 
value.vec.full <- c(3000,value.vec+0.1)
value.vec.full <- value.vec.full[order(value.vec.full)]
# 
dargo.ra <- get.small.area.func(out.ra,p=p)
plot(dargo.ra,breaks = value.vec.full,legend=F,col = l.s.c.df$col[order(l.s.c.df$ID)])

plot(0,ann=F,axes=F,xlab='',ylab='',pch=NA)
dargo.ft.nm <- l.s.c.df[l.s.c.df$ID %in% unique(dargo.ra),]
legend('top',legend = dargo.ft.nm$nm,pch=15,col=dargo.ft.nm$col,ncol=2)

# 
ft.map.ra <- readRDS('cache/ft.map.gps.rds')
dargo.ft.nm <- l.s.c.df[l.s.c.df$ID %in% unique(ft.map.ra),]
plot(ft.map.ra)
plot(ft.map.ra,
     breaks = value.vec.full,
     legend=F,
     col = l.s.c.df$col[order(l.s.c.df$ID)])
plot(0,ann=F,axes=F,xlab='',ylab='',pch=NA)
legend('top',legend = dargo.ft.nm$nm,pch=15,col=dargo.ft.nm$col,ncol=2)
