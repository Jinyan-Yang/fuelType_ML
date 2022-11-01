library(raster)
ft.ra <- readRDS(file = 'cache/ft.fine.access.hist.rds')
plot(ft.ra)

train.df <- readRDS('cache/ft.train.evaluation.rds')
train.df$predict.final.ft <- extract(x = ft.ra,
                                     y = SpatialPoints(cbind(train.df$long,train.df$lat)))
train.df <- train.df[!duplicated(train.df),]
plot(ft~predict.final.ft,data = train.df,
     pch=16,col=rgb(1,0,0,0.05))


summary(lm(ft~predict.final.ft,data = train.df))

library(caret)
#Creates vectors having data points
train.df$ft.f <- as.factor(train.df$ft)
train.df$predict.final.ft.f <- as.factor(train.df$predict.final.ft)
expected_value <- train.df$ft.f
predicted_value <- train.df$predict.final.ft.f
library(dplyr)
#Creating confusion matrix
example <- confusionMatrix(data=predicted_value, reference = expected_value)
xxx <- as.data.frame(example$table)
write.csv(xxx,'conmatrixLong.csv',row.names = F)
