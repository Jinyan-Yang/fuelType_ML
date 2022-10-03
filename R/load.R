# 
library(randomForest)
require(caTools)
library(caret)
library(raster)
library(rgdal)
library(ncdf4)
library(lubridate)
library(readr)
# 
source('r/function_rf.R')
source('r/get_vic_shape.R')

# #this code below is to deal with rnaturalearth no longer available on cran
# install.packages("devtools") # I guess you also need this
# devtools::install_github("ropensci/rnaturalearthhires")
# library("rnaturalearth")