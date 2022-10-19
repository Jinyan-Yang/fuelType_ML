# prepare#########
library(raster)
library(randomForest)
library(caret)
library(doParallel)
library(foreach)

###########
fit.paral.func <- function(data.path = 'cache/input_access.rds',
                           model.path = 'cache/rf.fit.fuelType.new.rds',
                           out.nm = 'cache/out.access.long.rds',
                           doProb=FALSE,isLongList){
  # model fit#############
  # read inputs
  model.input.df <- readRDS(data.path)
  # split inputs by no. of cpu core
  model.input.df <- model.input.df[complete.cases(model.input.df),]
  sample.d <- model.input.df#[1:1000,]
  n.split <- 10
  data.ls <- split(sample.d, rep(1:n.split, 
                                 length.out = nrow(sample.d), 
                                 each = ceiling(nrow(sample.d)/n.split)))
  # save memory
  rm(model.input.df)
  # rm(sample.d)
  #  rf model####
  # model.rf <- readRDS('cache/rf.fit.fuelType.new.rds')
  model.rf <- readRDS(model.path)
  
  print('Parallel computing start')
  # set up parallel computing#
  cores=n.split#use multicore, set to the number of our cores
  cl <- makeCluster(cores[1]) 
  registerDoParallel(cl)
  # record time used
  s.time <- Sys.time()
  
  out.list <- foreach (i=1:cores, .packages = 'randomForest') %dopar% {
    if(doProb){
      predict(object = model.rf,newdata=data.ls[[i]],type='prob')
    }else{
      predict(object = model.rf,newdata=data.ls[[i]])
    }
  }
  stopImplicitCluster()
  
  e.time <- Sys.time()
  
  time.use <- e.time - s.time
  print(time.use)
  # get output####
  # out.list <- lapply(X = out.list,as.character)
 
  rm(model.rf)
  rm(cl)
  # put input output together
  # sample.d <- do.call(rbind,data.ls)
  rm(data.ls)
  
  if(isLongList){
    out.vec <- do.call(rbind,out.list)
    sample.d.new <- cbind(sample.d[,c('x','y')],out.vec)
    
    make.raster.func <- function(x.in){
      spg <- sample.d.new[,c(1,2,x.in)]
      # spg$pred <- as.numeric(spg$pred)
      coordinates(spg) <- ~ x + y
      gridded(spg) <- TRUE
      out.ra <- raster(spg)
      return(out.ra)
    }
    num.vec <- seq_along(sample.d.new)[-c(1,2)]
    out.ra.stack <- stack(sapply(X = num.vec,make.raster.func))
  }else{
    out.list <- lapply(X = out.list,as.character)
    
    rm(model.rf)
    rm(cl)
    # put input output together
    # sample.d <- do.call(rbind,data.ls)
    rm(data.ls)
    sample.d$pred <- do.call(c,out.list)
    # make a raster output #####
    spg <- sample.d[,c('x','y','pred')]
    # spg <- sample.d[,c('x','y','pred')]
    spg$pred <- as.numeric(spg$pred)
    coordinates(spg) <- ~ x + y
    gridded(spg) <- TRUE
    out.ra.stack <- raster(spg)
  }
  
  # plot(out.ra.stack)
  saveRDS(out.ra.stack,out.nm)
}
#############

fit.paral.func(data.path = 'cache/input_access_rcp85_20852100.rds',
               model.path = 'cache/rf.fit.fuelType.new.short.rds',
               out.nm = 'cache/out.access.rcp85.20852100.short.rds',
               doProb=FALSE,isLongList=FALSE)

fit.paral.func(data.path = 'cache/input_access_rcp85_20852100.rds',
               model.path = 'cache/rf.fit.fuelType.new.rds',
               out.nm = 'cache/out.access.rcp85.20852100.long.rds',
               doProb=TRUE,isLongList=TRUE)

x <- readRDS('cache/out.access.rcp85.20852100.short.rds')
plot(x)
