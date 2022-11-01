source('r/get_vic_shape.R')
input.df <- readRDS('cache/ft.train.evaluation.rds')
map.ra <- readRDS('cache/ft.fine.access.hist.rds')
pdf('sample.map.pdf',width = 8,height = 6)
par(mar=c(2,2,1,1))
plot(map.ra,legend=F,col='white')
points(x = input.df$long,
       y = input.df$lat,
       pch=15,col=rgb(1,0.2,0.1,0.2))
dev.off()

