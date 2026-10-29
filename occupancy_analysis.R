out<-'occupancy_results';dir.create(out,showWarnings=FALSE)
# Occupancy receipts are not room occupancy rates or tax collected.
x<-read.csv('occupancy_snapshot.csv');x$Month<-factor(x$Month,levels=month.name)
stopifnot(!anyNA(x),!anyDuplicated(x[c('Month','Year')]),all(table(x$Year)==12),all(table(x$Month)==11))
y<-aggregate(Occupancy.Receipts~Year,x,sum);write.csv(y,file.path(out,'occupancy_year.csv'),row.names=FALSE)
v<-aggregate(Occupancy.Receipts~Month,x,median);write.csv(v,file.path(out,'occupancy_month.csv'),row.names=FALSE)
png(file.path(out,'occupancy_chart.png'),width=1500,height=800,res=150);par(mar=c(5,5,3,1));boxplot(Occupancy.Receipts/1e6~Month,x,names=month.abb,col='#C8F1EF',border='#087C83',xlab='Month',ylab='Reported occupancy receipts (USD millions)',main='Monthly distributions across supplied Year labels, 2011-2021');dev.off()
