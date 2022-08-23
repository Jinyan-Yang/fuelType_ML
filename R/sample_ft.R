# this file is greated by getsample_index.r
sample.df <- readRDS('cache/sample.ft.rds')

# combine soil and met####
soil.density.ra <- raster('data/soil/BDW_000_005_EV_N_P_AU_TRN_N_20140801.tif')
# density
sample.df$soil.density <- extract(x = soil.density.ra,
                                  y =  cbind(sample.df$lon,sample.df$lat))

# clay
soil.clay.ra <- raster('data/soil/CLY_000_005_EV_N_P_AU_TRN_N_20140801.tif')
sample.df$clay <- extract(x = soil.clay.ra,
                          y =  cbind(sample.df$lon,sample.df$lat))

#get topo####
# shortwave radiation
rad.jan.ra <- raster('data/topo/rad/SRADTotalShortwaveSlopingSurf_0115_lzw.tif')
sample.df$rad.short.jan <- extract(x = rad.jan.ra,
                                   y =  cbind(sample.df$lon,
                                                             sample.df$lat))
rm(rad.jan.ra)

rad.jul.ra <- raster('data/topo/rad/SRADTotalShortwaveSlopingSurf_0715_lzw.tif')
sample.df$rad.short.jul <- extract(x = rad.jul.ra,
                                   y =  cbind(sample.df$lon,sample.df$lat))
rm(rad.jul.ra)

# get wi#####
wi.ra <- raster('data/topo/wetness_index/90m/twi_3s.tif')
sample.df$wi <- extract(x = wi.ra, 
                     y =  cbind(sample.df$lon,sample.df$lat))
rm(wi.ra)

# get profile_c
fn <- 'data/topo/curvature_profile/90m/profile_curvature_3s.tif'
c_profile.ra <- raster(fn)
sample.df$curvature_profile <- extract(x = c_profile.ra,
                                       y = cbind(sample.df$lon,sample.df$lat))

fn.c.plan <- 'data/topo/curvature_plan/90m/plan_curvature_3s.tif'
c_plan.ra <- raster(fn.c.plan)
sample.df$curvature_plan <- extract(x = c_plan.ra,
                                    y = cbind(sample.df$lon,sample.df$lat))

# add longterm climate######
# read annual silo
silo.annual.ra <- readRDS('cache/slio.met.annual.rds')
met.sample.df <- as.data.frame(extract(silo.annual.ra,
                         cbind(sample.df$lon,sample.df$lat)))
sample.df$tmax.mean <- met.sample.df$tmax
sample.df$map <- met.sample.df$prcp
sample.df$vpd.mean <- met.sample.df$vpd

# get rainfall seaonality
pr.seaon.ra <- readRDS('cache/pr_seaonality_silo.rds')

sample.df$pr.seaonality <- raster::extract(pr.seaon.ra,
                                        cbind(sample.df$lon,sample.df$lat))
# 
saveRDS(sample.df,'cache/ft.met.rds')

#####get lai for long term clim
# predict lai####
tmp.df <- readRDS('cache/ft.met.rds')
par_fraction <- 0.368

# library("devtools")
# install_bitbucket("Jinyan_Jim_Yang/g1.opt.package.git")

tmp.df$PAR <- (tmp.df$rad.short.jan + tmp.df$rad.short.jul)/2 *par_fraction
get.vp.from.t.func <- function(temperature){
  # Magnus_pressure = 
  0.61094 * exp((17.625 * temperature) / (temperature + 243.04))
}


tmp.df$vpd <- tmp.df$vpd.mean
tmp.df$vpd[tmp.df$vpd<0.05] <- 0.05
library(g1.opt.func)
opt.out.ls <- list()
n.days <- 365.25
for (i in 1:nrow(tmp.df)) {
  tmp <- try(g1.lai.e.func(VPD = tmp.df$vpd[i],
                           E = tmp.df$map[i],
                           PAR = tmp.df$PAR[i]*n.days,
                           TMAX = tmp.df$tmax[i],
                           Ca = 400))
  if(class(tmp)=='try-error'){
    opt.out.ls[[i]] <- NA
  }else{
    opt.out.ls[[i]] <- tmp
  }
  print(i)
}

opt.out.df <- do.call(rbind,opt.out.ls)
tmp.df$lai.opt.mean <- opt.out.df[,'LAI']
saveRDS(tmp.df,'cache/ft.met.lai.rds')


# read soil depth####
tmp.df <- readRDS('cache/ft.met.lai.rds')

soil.depth.ra <- raster('data/soil/DER_000_999_EV_N_P_AU_NAT_C_20150601.tif')
# density
tmp.df$soil.depth <- extract(x = soil.depth.ra,
                                  y =  cbind(tmp.df$lon,tmp.df$lat))

saveRDS(tmp.df,'cache/ft.met.lai.rds')




