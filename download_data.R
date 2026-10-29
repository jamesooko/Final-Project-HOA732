# Run from the repository root. Downloads public UCI datasets with verified HTTPS.
stopifnot(requireNamespace('readxl',quietly=TRUE))
fetch_zip <- function(url) {
 f<-tempfile(fileext='.zip');download.file(url,f,mode='wb');d<-tempfile();dir.create(d);unzip(f,exdir=d);d
}
b<-fetch_zip('https://archive.ics.uci.edu/static/public/222/bank+marketing.zip')
unzip(file.path(b,'bank.zip'),files='bank.csv',exdir=b)
file.copy(file.path(b,'bank.csv'),'bank.csv',overwrite=TRUE)
r<-fetch_zip('https://archive.ics.uci.edu/static/public/477/real%2Bestate%2Bvaluation%2Bdata%2Bset.zip')
d<-as.data.frame(readxl::read_excel(file.path(r,'Real estate valuation data set.xlsx')))
names(d)<-c('No','Date','Age','Dist.MRT','N.Cstores','latitude','longitude','Y')
write.csv(d,'real_estate_data.csv',row.names=FALSE)
cat('UCI datasets downloaded. See README.md for source attribution and licenses.\n')
