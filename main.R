# ######################################################################
# this is the repo to fit a RF model to fuel type data
# ######################################################################

#1. prepare environment####
source('r/load.r')

# 2. download met####
source('r/get_silo_met.R')
source('r/get_rainfal_seaonality.R')
source('r/get_silo_annual.R')

# 3. other attributes####
# note that the topography, soil, CMIP6 climate, land use map, 
# and fuel type map need to be manually added
source('r/get_annaul_clim_cmip.R')
source('r/get_lcm4vic.R')

# 4. fit the model####
# we fit for the full fuel type list
source('r/rf_fuelType.R')
# and for a short list that makes more ecological sense
source('r/ft_shortlist.R')

# 5. predictions####
# 23/08/2022 note that the current prediction is set up for access01 only
# the reason is CFA has not provided with a final short list

# predict for all fuel types
source('r/run_parallel.R')
# and for the short list
source('r/run_parallel_shortlist.R')

# the plan then is to use the fuel type in the short list 
# to filter out types that are unlikely to present 
# so the final predictions has more categories but also 
# ecologically constrained

