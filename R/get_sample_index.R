# read fuel type map
# this data is from CFA
evc.df <- raster('data/EVC_fuelType/evc/VICSANSW161.tif')
# remove area catagories that are not in VIC (3000+)
evc.df[evc.df >= 4000] <- NA
evc.df[evc.df <= 2999] <- NA

# sample each for 5000 obs
set.seed(1935)
sample.index <- sampleStratified(evc.df,5000, na.rm=TRUE)
saveRDS(sample.index,'cache/ft.sample.index.rds')

# ############
sample.index <- readRDS('cache/ft.sample.index.rds')

sample.index <- sample.index[sample.index[,2]>2999,]
sample.index <- sample.index[sample.index[,2]<3999,]

# get sample details
sample.df <- xyFromCell(evc.df,sample.index) 
sample.df <- as.data.frame(sample.df)
sample.df$ft <- sample.index[,2]

# 
# convert to wgs84 projection#####
# set the crs (GDA 94) that the data is in 
sincrs <- "+proj=lcc +lat_1=-36 +lat_2=-38 +lat_0=-37 +lon_0=145 +x_0=2500000 +y_0=2500000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs "
# GPS (WGS84)
lonlat <- '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0' 
# convert coords to spatial points
s <- SpatialPoints(cbind(sample.df$x, sample.df$y), 
                   proj4string=CRS(sincrs))
# transfer to gps
coords.new <- spTransform(s, lonlat)

sample.df$lat <- coords.new@coords[,2]
sample.df$long <- coords.new@coords[,1]

saveRDS(sample.df,'cache/sample.ft.rds')