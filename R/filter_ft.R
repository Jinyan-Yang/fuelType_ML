ft.short.ra <- readRDS('cache/out.access.short.rds')

# 
tmp.ft.df <- readRDS('cache/ft.train.evaluation.rds')
ft.df <- tmp.ft.df[,c('ft.new','ft.new.num')]
ft.df <- ft.df[!duplicated(ft.df),]
# 
long.short.convert.df <- read.csv('cache/fuelName.csv')
long.short.convert.df$new_nm[long.short.convert.df$new_nm==''] <- NA
long.short.convert.df$ID <- as.character(long.short.convert.df$ID)
l.s.c.df <- merge(long.short.convert.df,ft.df,by.x = 'new_nm',by.y= 'ft.new')
# l.s.c.df$ft.new.num[l.s.c.df$nm == 'Rainforest'] <- 3
# plot(ft.short.ra,
#      # breaks = c(ft.nm.df$ID[1]-0.1,ft.nm.df$ID+0.1),
#      col=c(col_vector[ft.df$ft.new.num]),legend=F)
# plot(0,pch=NA,ann=F,axes=F)
# legend('top',legend = levels(ft.df$ft.new),col = col_vector[ft.df$ft.new.num],
#        pch=15,ncol=2,bty='n',xpd=T,cex=0.8)
ft.full.ra <- readRDS('cache/out.access.long.rds')

# prob.tmp.ra <- ft.full.ra[["prob"]]
# 

get.max.nm.func <- function(nm.in){
  
  temp.ft.short.ra <- ft.short.ra
  temp.ft.short.ra[temp.ft.short.ra != nm.in] <- NA
  
  r3 <- mask(ft.full.ra, temp.ft.short.ra)
  ra.name <- paste0('X',l.s.c.df$ID[l.s.c.df$ft.new.num==nm.in])
  prob.tmp.ra.sub <- subset(r3,ra.name)
  # plot(prob.tmp.ra.sub[[1]])
  prob.tmp.ra.sub[is.na(prob.tmp.ra.sub)] <- -99
  if(length(names(prob.tmp.ra.sub))>1){
    x <- which.max(prob.tmp.ra.sub)
    x <- mask(x,temp.ft.short.ra)
    # plot(x)
    x.name <- gsub('X','',x = ra.name)
    for (i in seq_along(x.name)) {
      x[x==i] <- as.numeric(x.name[i])
    }
  }else{
    x <- prob.tmp.ra.sub
    x[x>-1] <- gsub('X','',x = ra.name)
  }
 
  x.df <- as.data.frame(x, xy=TRUE)
  names(x.df) <- c('x','y','layer')
  x.df <- x.df[!is.na(x.df$layer),]
  return(x.df)
}

out.ls <- lapply(unique(l.s.c.df$ft.new.num),get.max.nm.func)
saveRDS(out.ls,'tmp.rds')
tmp.df <- as.data.frame(ft.short.ra,xy=TRUE)
names(tmp.df) <- c('x','y','layer')
tmp.df <- tmp.df[!is.na(tmp.df$layer),]

out.ls[[3]] <- tmp.df[tmp.df$layer==3 ,]
out.ls[[3]]$layer <- 3047
out.ls <- readRDS('tmp.rds')
out.df <- do.call(rbind,out.ls)

test <- out.df[duplicated(out.df[,1:2]),]
out.df <- out.df[complete.cases(out.df),]
# out.ra <- rasterFromXYZ(out.df)
# plot(out.ra)
out.df$layer <- as.numeric(out.df$layer)
coordinates(out.df) <- ~ x + y
gridded(out.df) <- TRUE
out.ra <- raster(out.df)
saveRDS(out.ra,'cache/ft.fine.access2100.rcp85.rds')
value.vec <- unique(out.ra)
value.vec.full <- c(value.vec-0.1,value.vec+0.1)
value.vec.full <- value.vec.full[order(value.vec.full)]
# 
col.in.df <- data.frame(col.1 = c('deeppink','coral','cyan','darkgoldenrod','green','darkorchid'),
                        col.2 = c('deeppink4','coral4','cyan4','darkgoldenrod4','darkgreen','darkorchid4'))
l.s.c.df$col <- NA
l.s.c.df <- l.s.c.df[order(l.s.c.df$ID),]
for (i.col in 1:6 ) {
  c.f <- colorRampPalette(colors = col.in.df[i.col,])
  l.s.c.df$col[l.s.c.df$ft.new.num==i.col] <- c.f(length(l.s.c.df$col[l.s.c.df$ft.new.num==i.col]))
}
# 
l.s.c.df <- l.s.c.df[order(l.s.c.df$ft.new.num),]
pdf('ft.new.short.fine.filtered.pdf',width = 8,height = 6*2)
par(mar=c(4,4,1,1))
par(mfrow=c(2,1))
plot(out.ra,breaks = value.vec.full,legend=F,col = l.s.c.df$col[order(l.s.c.df$ID)])
plot(0,ann=F,axes=F,xlab='',ylab='',pch=NA)
legend('top',legend = l.s.c.df$nm,pch=15,col=l.s.c.df$col,ncol=2)
dev.off()