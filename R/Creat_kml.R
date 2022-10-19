source('r/get_color4ft.R')
library(raster)

# 
l.s.c.df$ID <- as.numeric(l.s.c.df$ID)
l.s.c.df.full <- data.frame(ID = seq(min(l.s.c.df$ID),max(l.s.c.df$ID)),col=NA)
l.s.c.df.full <- l.s.c.df.full[l.s.c.df.full$ID %in% 
                                 setdiff(l.s.c.df.full$ID,l.s.c.df$ID),]
col.df <- merge(l.s.c.df.full,l.s.c.df,all=T)
# 
out.ra <- readRDS('cache/ft.fine.access2100.rcp85.rds')
crs(out.ra) <- '+init=epsg:4326'
KML(x = out.ra, filename="ft.fine.access2000.kml",
    col=col.df$col[order(col.df$ID)],
    colNA=NA, maxpixels=length(out.ra),overwrite=T)

out.ra <- readRDS('cache/ft.fine.access2100.rcp85.rds')
crs(out.ra) <- '+init=epsg:4326'
KML(x = out.ra, filename="ft.fine.access.rcp85.2100.kml",
    col=col.df$col[order(col.df$ID)],
    colNA=NA, maxpixels=length(out.ra),overwrite=T)
