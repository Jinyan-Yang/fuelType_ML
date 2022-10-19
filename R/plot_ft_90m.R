# 
source('r/get_color4ft.R')
tmp.ft.df <- readRDS('cache/ft.train.evaluation.rds')
ft.df <- tmp.ft.df[,c('ft.new','ft.new.num')]
ft.df <- ft.df[!duplicated(ft.df),]
# 
long.short.convert.df <- read.csv('cache/fuelName.csv')
long.short.convert.df$new_nm[long.short.convert.df$new_nm==''] <- NA
long.short.convert.df$ID <- as.character(long.short.convert.df$ID)
l.s.c.df <- merge(long.short.convert.df,ft.df,by.x = 'new_nm',by.y= 'ft.new')
# 
out.ra <- readRDS('cache/ft.fine.access2100.rcp85.rds')
# writeRaster(out.ra,'cache/ft_90m_filtered.tif',options=c('TFW=YES'))

value.vec <- unique(out.ra)
# 
value.vec.full <- c(3000,value.vec+0.1)
value.vec.full <- value.vec.full[order(value.vec.full)]
# # 
# 
# 
# plot(ID ~ ft.new.num,data = l.s.c.df,pch=16,col=col)
# 
# 
# # l.s.c.df <- l.s.c.df[order(l.s.c.df$ft.new.num),]
pdf('ft.new.short.fine.filtered.pdf',width = 8,height = 6*2)
par(mar=c(4,4,1,1))
par(mfrow=c(2,1))
plot(out.ra,breaks = value.vec.full,legend=F,col = l.s.c.df$col[order(l.s.c.df$ID)])
plot(0,ann=F,axes=F,xlab='',ylab='',pch=NA)
legend('top',legend = l.s.c.df$nm,pch=15,col=l.s.c.df$col,ncol=2)


dev.off()
