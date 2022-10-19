library(raster)
rasterOptions(maxmemory = 2e11,todisk = FALSE)
source('r/get_color4ft.R')

Mode.func <- function(x) {
  ux <- unique(x)
  ux=ux[!is.na(ux)]
  ux[which.max(tabulate(match(x, ux)))]
}

filter.ft.func <- function(ft.shrot.in = 'cache/out.access.short.rds',
                           ft.long.in = 'cache/out.access.long.rds',
                           out.nm = 'cache/ft.fine.access.hist.rds'){
  
  ft.short.ra <- readRDS(ft.shrot.in)
  
  # ft.short.ra <- calc(stack(ft.short.ra.six),Mode.func)
  # plot(ft.short.ra)
  

  # l.s.c.df$ft.new.num[l.s.c.df$nm == 'Rainforest'] <- 3
  # plot(ft.short.ra,
  #      # breaks = c(ft.nm.df$ID[1]-0.1,ft.nm.df$ID+0.1),
  #      col=c(col_vector[ft.df$ft.new.num]),legend=F)
  # plot(0,pch=NA,ann=F,axes=F)
  # legend('top',legend = levels(ft.df$ft.new),col = col_vector[ft.df$ft.new.num],
  #        pch=15,ncol=2,bty='n',xpd=T,cex=0.8)
  ft.full.ra <- readRDS(ft.long.in)
  
  # plot(prob.tmp.ra.sub[[1]])
  
  get.max.nm.func <- function(nm.in){
    # delete any temp file on hard drive
    removeTmpFiles(h=0.01)
    # give raster a new name
    temp.ft.short.ra <- ft.short.ra
    # remove pixels that are not in the given short list
    temp.ft.short.ra[temp.ft.short.ra != nm.in] <- NA
    # mask predictions
    r3 <- mask(ft.full.ra, temp.ft.short.ra)
    # remove X in the col names
    ra.name <- paste0('X',l.s.c.df$ID[l.s.c.df$ft.new.num==nm.in])
    prob.tmp.ra.sub <- subset(r3,ra.name)
    # replace NA
    prob.tmp.ra.sub[is.na(prob.tmp.ra.sub)] <- -99
    
    # make the raster stack into ft numbers rather than short list number
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
    # convert to df
    x.df <- as.data.frame(x, xy=TRUE)
    names(x.df) <- c('x','y','layer')
    x.df <- x.df[!is.na(x.df$layer),]
    saveRDS(x.df,sprintf('cache/tmp.df.ft.%s.rds',nm.in))
    return(x.df)
  }
  
  out.ls <- lapply(unique(l.s.c.df$ft.new.num),get.max.nm.func)
  
  
  # saveRDS(out.ls,'tmp.rds')
  tmp.df <- as.data.frame(ft.short.ra,xy=TRUE)
  names(tmp.df) <- c('x','y','layer')
  tmp.df <- tmp.df[!is.na(tmp.df$layer),]
  
  out.ls[[3]] <- tmp.df[tmp.df$layer==3 ,]
  out.ls[[3]]$layer <- 3047
  # out.ls <- readRDS('tmp.rds')
  out.df <- do.call(rbind,out.ls)
  
  test <- out.df[duplicated(out.df[,1:2]),]
  out.df <- out.df[complete.cases(out.df),]
  # out.ra <- rasterFromXYZ(out.df)
  # plot(out.ra)
  out.df$layer <- as.numeric(out.df$layer)
  coordinates(out.df) <- ~ x + y
  gridded(out.df) <- TRUE
  out.ra <- raster(out.df)
  # writeRaster(out.ra,'cache/ft_90m_filtered.tif',options=c('TFW=YES'))
  saveRDS(out.ra,out.nm)
}

filter.ft.func(ft.shrot.in = 'cache/out.access.rcp85.20852100.short.rds',
               ft.long.in = 'cache/out.access.rcp85.20852100.long.rds',
               out.nm = 'cache/ft.fine.access2100.rcp85.rds')

# # 
# out.ra <- readRDS('cache/ft.fine.access2100.rcp85.rds')
# # writeRaster(out.ra,'cache/ft_90m_filtered.tif',options=c('TFW=YES'))
# 
# # value.vec <- unique(out.ra)
# # 
# # value.vec.full <- c(3000,value.vec+0.1)
# # value.vec.full <- value.vec.full[order(value.vec.full)]
# # # 
# # 
# # 
# # plot(ID ~ ft.new.num,data = l.s.c.df,pch=16,col=col)
# # 
# # 
# # # l.s.c.df <- l.s.c.df[order(l.s.c.df$ft.new.num),]
plot.ft2pdf.func <- function(pdf.nm = 'ft.new.short.fine.filtered.pdf',ra.in.nm){
  out.ra <- readRDS(ra.in.nm)
  # 
  value.vec <- unique(out.ra)
  value.vec.full <- c(3000,value.vec+0.1)
  value.vec.full <- value.vec.full[order(value.vec.full)]

  # 
  pdf(pdf.nm,width = 8,height = 6*2)
  par(mar=c(4,4,1,1))
  par(mfrow=c(2,1))
  plot(out.ra,breaks = value.vec.full,legend=F,col = l.s.c.df$col[order(l.s.c.df$ID)])
  plot(0,ann=F,axes=F,xlab='',ylab='',pch=NA)
  legend('top',legend = l.s.c.df$nm,pch=15,col=l.s.c.df$col,ncol=2)
  
  
  dev.off()
}
plot.ft2pdf.func(pdf.nm = 'ft.short.90m.rcp85.2100.pdf',
                 ra.in.nm = 'cache/ft.fine.access2100.rcp85.rds')


