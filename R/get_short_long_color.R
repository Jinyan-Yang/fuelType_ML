# 
tmp.ft.df <- readRDS('cache/ft.train.evaluation.rds')
ft.df <- tmp.ft.df[,c('ft.new','ft.new.num')]
ft.df <- ft.df[!duplicated(ft.df),]
# 
long.short.convert.df <- read.csv('cache/fuelName.csv')
long.short.convert.df$new_nm[long.short.convert.df$new_nm==''] <- NA
long.short.convert.df$ID <- as.character(long.short.convert.df$ID)
l.s.c.df <- merge(long.short.convert.df,ft.df,by.x = 'new_nm',by.y= 'ft.new')