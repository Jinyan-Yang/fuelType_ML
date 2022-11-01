library(randomForest)
library(caret)
importance.full.df <- as.data.frame(model.rf$importance)
importance.full.df$var.nm <- rownames(importance.full.df)
importance.full.df <- importance.full.df[,
                                         c('var.nm',"MeanDecreaseAccuracy")]
importance.full.df <- importance.full.df[order(importance.full.df$MeanDecreaseAccuracy,
                                               decreasing = T),]
write.csv(importance.full.df,'importance_full.csv',row.names = F) 
# 
rf.short.fit <- readRDS('cache/rf.fit.fuelType.new.short.rds')
importance.short.df <- as.data.frame(rf.short.fit$importance)
importance.short.df$var.nm <- rownames(importance.short.df)
importance.short.df <- importance.short.df[,
                                           c('var.nm',"MeanDecreaseAccuracy")]
importance.short.df <- importance.short.df[order(importance.short.df$MeanDecreaseAccuracy,
                                                 decreasing = T),]
write.csv(importance.short.df,'importance_short.csv',row.names = F) 
# 
jpeg(filename = 'importance.jpg',height = 480,
     width = 480*2)
par(mar=c(5,5,1,1),mfrow=c(1,2))
varImpPlot(rf.short.fit,type = 1,main = 'Short list')
varImpPlot(model.rf,type = 1,main = 'Full list')
dev.off()
