library(rpart)
dir.create('bank_marketing_results',showWarnings=FALSE)
d <- read.csv('bank.csv',sep=';',stringsAsFactors=FALSE)
stopifnot(nrow(d)==4521,!anyNA(d),!anyDuplicated(d))
# Exclude duration and current-campaign fields unavailable before a call.
vars<-c('y','age','job','marital','education','default','balance','housing','loan','pdays','previous','poutcome')
d<-d[vars]; d$previously_contacted<-factor(ifelse(d$pdays==-1,'no','yes'));d$pdays<-ifelse(d$pdays==-1,0,d$pdays)
for(n in names(d)[sapply(d,is.character)])d[[n]]<-factor(d[[n]])
d$y<-factor(d$y,levels=c('no','yes'))
set.seed(117317);train<-valid<-test<-integer()
for(v in levels(d$y)){
 ids<-sample(which(d$y==v));n<-length(ids);a<-floor(.6*n);b<-floor(.2*n)
 train<-c(train,ids[seq_len(a)]);valid<-c(valid,ids[a+seq_len(b)]);test<-c(test,ids[(a+b+1):n])
}
tr<-d[train,];va<-d[valid,];te<-d[test,]
stopifnot(!length(intersect(train,valid)),!length(intersect(train,test)),!length(intersect(valid,test)))
g<-glm(y~.,data=tr,family=binomial())
set.seed(117317)
t0<-rpart(y~.,data=tr,method='class',control=rpart.control(cp=.001,minsplit=30,maxdepth=6,xval=5))
cp<-t0$cptable[which.min(t0$cptable[,'xerror']),'CP'];tree<-prune(t0,cp=cp)
auc<-function(y,p){b<-as.integer(y=='yes');n1<-sum(b);n0<-sum(1-b);(sum(rank(p)[b==1])-n1*(n1+1)/2)/(n1*n0)}
score<-function(y,p,th){b<-y=='yes';h<-p>=th;tp<-sum(b&h);fp<-sum(!b&h);fn<-sum(b&!h);tn<-sum(!b&!h);prec<-if(tp+fp)tp/(tp+fp) else 0;rec<-tp/(tp+fn);c(Accuracy=mean(b==h),Precision=prec,Recall=rec,F1=if(prec+rec)2*prec*rec/(prec+rec)else 0,Balanced_accuracy=(rec+tn/(tn+fp))/2,ROC_AUC=auc(y,p),Brier=mean((as.integer(b)-p)^2))}
threshold<-function(p){ts<-seq(.05,.5,.01);fs<-sapply(ts,function(t)score(va$y,p,t)['F1']);ts[which.max(fs)]}
pvg<-predict(g,va,type='response');pvt<-predict(tree,va,type='prob')[,'yes'];tg<-threshold(pvg);tt<-threshold(pvt)
pg<-predict(g,te,type='response');pt<-predict(tree,te,type='prob')[,'yes'];p0<-rep(mean(tr$y=='yes'),nrow(te))
metrics<-rbind(Majority_baseline=score(te$y,p0,1),Logistic_regression=score(te$y,pg,tg),Decision_tree=score(te$y,pt,tt))
write.csv(metrics,'bank_marketing_results/test_metrics.csv')
write.csv(data.frame(model=c('Logistic_regression','Decision_tree'),threshold=c(tg,tt)),'bank_marketing_results/thresholds.csv',row.names=FALSE)
write.csv(data.frame(actual=te$y,logistic=pg,tree=pt),'bank_marketing_results/test_predictions.csv',row.names=FALSE)
write.csv(data.frame(split=c('train','validation','test'),n=c(nrow(tr),nrow(va),nrow(te)),yes=c(sum(tr$y=='yes'),sum(va$y=='yes'),sum(te$y=='yes'))),'bank_marketing_results/split_counts.csv',row.names=FALSE)
write.csv(data.frame(row_id=seq_len(nrow(d)),split=ifelse(seq_len(nrow(d))%in%train,'train',ifelse(seq_len(nrow(d))%in%valid,'validation','test'))),'bank_marketing_results/split_membership.csv',row.names=FALSE)
capture.output(sessionInfo(),file='bank_marketing_results/sessionInfo.txt');print(metrics);print(c(logistic_threshold=tg,tree_threshold=tt,tree_cp=cp))
