tmp.ft.df <- readRDS('cache/ft.train.evaluation.rds')
ft.df <- tmp.ft.df[,c('ft.new','ft.new.num')]
ft.df <- ft.df[!duplicated(ft.df),]
# 
long.short.convert.df <- read.csv('cache/fuelName.csv')
long.short.convert.df$new_nm[long.short.convert.df$new_nm==''] <- NA
long.short.convert.df$ID <- as.character(long.short.convert.df$ID)
l.s.c.df <- merge(long.short.convert.df,ft.df,by.x = 'new_nm',by.y= 'ft.new')

col.in.df <- data.frame(col.1 = c('deeppink','coral','cyan',
                                  'gold','green','darkorchid'),
                        col.2 = c('deeppink4','coral4','cyan4',
                                  'gold4','darkgreen','darkorchid4'))
l.s.c.df$col <- NA
# l.s.c.df <- l.s.c.df[order(l.s.c.df$ID),]
for (i.col in 1:6) {
  c.f <- colorRampPalette(colors = col.in.df[i.col,])
  l.s.c.df$col[l.s.c.df$ft.new.num==i.col] <- 
    c.f(length(l.s.c.df$col[l.s.c.df$ft.new.num==i.col]))
  
}