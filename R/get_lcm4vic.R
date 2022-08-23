# need to get land use map from ge.gov.au####
lcm.ra <- raster('downloads/LCM/luav4g9abll07811a02egigeo___/lu05v4ag/w001001.adf')
lcm.vic <- get.small.area.func(lcm.ra,shape.vic)
lcm.lut <- lcm.vic@data@attributes[[1]]
lcm.lut.natrua <- lcm.lut$ID[lcm.lut$LU_DESC %in% c('CONSERVATION AND NATURAL ENVIRONMENTS',
                                                    'PRODUCTION FROM RELATIVELY NATURAL ENVIRONMENTS')]

lcm.vic[!(lcm.vic %in% lcm.lut.natrua)] <- NA
saveRDS(lcm.vic,'cache/lcm.vic.rds')
