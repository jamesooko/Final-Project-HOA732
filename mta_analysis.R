out<-'mta_results';dir.create(out,showWarnings=FALSE)
# MTA supplied snapshot: daily distributions, without adding vehicle counts to rides.
d<-read.csv('mta_snapshot.csv',check.names=FALSE);d$Date<-as.Date(d$Date)
stopifnot(!anyNA(d),!anyDuplicated(d$Date),nrow(d)==as.integer(max(d$Date)-min(d$Date))+1)
cols<-c('Subways','Buses','LIRR','Metro_North','Access','Bridges_Tunnels','Staten.Island.Railway')
sumry<-do.call(rbind,lapply(cols,function(n)data.frame(service=n,n=nrow(d),median=median(d[[n]]),mean=mean(d[[n]]),p25=unname(quantile(d[[n]],.25)),p75=unname(quantile(d[[n]],.75)))))
write.csv(sumry,file.path(out,'mta_summary.csv'),row.names=FALSE)
d$month<-as.Date(format(d$Date,'%Y-%m-01'));z<-aggregate(d[cols],list(month=d$month),mean);write.csv(z,file.path(out,'mta_monthly.csv'),row.names=FALSE)
png(file.path(out,'mta_chart.png'),width=1500,height=800,res=150);par(mar=c(4,5,3,1));matplot(z$month,z[c('Subways','Buses')]/1e6,type='l',lty=c(1,2),col=c('#008D98','#0B172A'),lwd=2,xaxt='n',xlab='Month',ylab='Mean daily rides (millions)',main='Subway and bus ridership in the supplied snapshot');axis.Date(1,at=seq(as.Date('2020-03-01'),as.Date('2024-10-01'),by='year'),format='%Y');legend('topleft',c('Subway','Bus'),lty=c(1,2),col=c('#008D98','#0B172A'),lwd=2,bty='n');dev.off()
