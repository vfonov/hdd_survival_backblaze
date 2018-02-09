library(tidyverse)
library(scales)
library(survival)
library(zoo)

# using survminer package for plotting pretty survival curves
library(survminer)

# make graph plotting prettier on linux without X11
#options(bitmapType='cairo')

# default theme 
theme_set(theme_bw(base_size = 20))

hdd<-read_csv('backblaze_2013_2017_hdd_survival.csv')

hdd<-hdd %>% filter(make!="", make!="SAMSUNG", capacity>0, capacity<100) # limit capacity at 100Tb (there is one misreported drive)

hdd<-hdd %>% mutate(make=as.factor(make), model=as.factor(model), capacity = as.factor(capacity),
                    year=as.factor(format(start,format='%Y')),
                    quarter=as.factor(as.yearqtr(start)))

# let's see how the hard drives were installed

png("figure/figure0.png",width=800,height=600)

ggplot(hdd,aes(x=start, fill=capacity))+
   geom_histogram()+
   scale_x_date(labels=date_format("%Y-%b"),
                breaks = date_breaks('1 month'), 
                limits = c(as.Date("2013-01-01"), as.Date("2018-01-01")))+
   theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+xlab(NULL)


# example of survival plot:
png("figure/figure1.png",width=800,height=600)

hdd_example1<-hdd %>% filter(model=='ST31500341AS')
ggsurvplot( survfit(Surv(age_days, status) ~ 1, data=hdd_example1),data=hdd_example1, 
  conf.int = TRUE,xlab = "Days of service",ylim=c(0.4,1.0),
  conf.int.style ='step',censor=T,legend='none',surv.scale='percent' )
  

png("figure/figure2.png",width=800,height=600)
hdd_example2<-hdd %>% filter(model %in% c('ST31500341AS','ST31500541AS')) %>% mutate(model=droplevels(model))
s<-survfit(Surv(age_days, status) ~ model, data=hdd_example2)
ggsurvplot(s,data=hdd_example2, legend.title='1.5Tb model',
  conf.int = TRUE,xlab = "Days of service",
  ylim=c(0.4,1.0),conf.int.style ='step',censor=T,pval=T,pval.coord=c(100,0.7),
  surv.scale='percent',
  legend.labs = levels(hdd_example2$model))


png("figure/figure3.png",width=800,height=600)
hdd_ST4000DM000=hdd %>% filter(model=='ST4000DM000')

model_by_quarter<-survfit(Surv(age_days, status) ~ quarter, data=hdd_ST4000DM000 )
ggsurvplot(model_by_quarter,data=hdd_ST4000DM000,
  conf.int = F,xlab = "Days of service",ylim=c(0.7,1.0),censor=F,pval=T,
  pval.coord=c(100,0.7),surv.scale='percent',legend.labs = levels(hdd_ST4000DM000$quarter),
  legend.title="ST4000DM000\nby quarter",  legend = "right")

# now let's do something interesting
# here we COX proportional hazard model to estimate multiplicative effects 
# main assumptionis that they are actually fit Cox model
# see https://en.wikipedia.org/wiki/Proportional_hazards_model 
# and 
png("figure/figure4.png",width=800,height=1000)
model_by_quarter_coxph<-coxph(Surv(age_days, status) ~ quarter, data=hdd_ST4000DM000)
# plot results
ggforest(model_by_quarter_coxph)


# and now for large hard drives
png("figure/figure5.png",width=800,height=600)

hdd_large<-hdd %>% filter(capacity %in% c(8,10,12)) %>% mutate(model=droplevels(model))
hdd_common_large<-hdd_large %>% group_by(model) %>% summarise(n=n()) %>% arrange(desc(n)) %>% head(4)

hdd_large<-hdd_large %>% filter(model %in% hdd_common_large$model)  %>% mutate(model=droplevels(model))
print("Large models:")
print(hdd_common_large$model)

model_large<-survfit(Surv(age_days, status) ~ model, data=hdd_large)
ggsurvplot(model_large, data=hdd_large, 
  conf.int = TRUE,xlab = "Days",
  ylim=c(0.925,1.0),
  conf.int.style ='step', 
  pval=T, censor=F, pval.coord=c(10,0.95), surv.scale='percent',
  legend = "right",
  legend.labs = levels(hdd_large$model), legend.title='Large HDD' )

png("figure/figure6.png",width=800,height=300)
model_coxph<-coxph(Surv(age_days, status) ~ model, data=hdd_large)
# plot results
ggforest(model_coxph)
 

  
png("figure/figure7.png",width=800,height=600)
hdd_common_10<-hdd %>% group_by(model) %>% summarise(n=n()) %>% arrange(desc(n)) %>% head(10)
hdd_common<-hdd %>% filter(model %in% hdd_common_10$model) %>% 
      mutate( model=factor( as.character(model),levels=hdd_common_10$model))

ggsurvplot(survfit(Surv(age_days, status) ~ model, data=hdd_common),data=hdd_common,
  conf.int = F,xlab = "Days of service",ylim=c(0.4,1.0),conf.int.style ='step',censor=F,pval=T,
  pval.coord=c(100,0.7),surv.scale='percent',legend.labs = levels(hdd_common$model),
  legend.title='Top 10 models',  legend = "right")

png("figure/figure8.png",width=1000,height=800)
hdd_common_coxph<-coxph(Surv(age_days, status) ~ model, data=hdd_common)
# plot results
ggforest(hdd_common_coxph)

# post-hoc comparision of most reliable hard drives:
compare<-pairwise_survdiff(Surv(age_days, status) ~ model, data=hdd_common)

# check if 5 most reliable are different:
reliable=c('HDS5C3030ALA630', 'HMS5C4040ALE640', 'HDS5C4040ALE630' , 'HDS722020ALA330' , 'HMS5C4040BLE640')

broom::tidy(compare) %>% filter(group1 %in% reliable , group2 %in% reliable) %>% 
    mutate( sig=symnum(p.value, cutpoints = c(0, 0.0001, 0.001, 0.01, 0.05, 0.1, 1),
                                symbols = c("****", "***", "**", "*", "+", " ") ) )

# parametric models

fit_model_weibull<-survreg(Surv(age_days, status) ~ model, data=hdd_common)
fit_model_exp<-survreg(Surv(age_days, status) ~ model, data=hdd_common,dist='exponential')


png("figure/figure9.png",width=800,height=600)

data_ST4000DM000<-hdd %>% filter(model=='ST4000DM000')
k_m_fit<-broom::tidy(survfit(Surv(age_days, status) ~ 1, data=data_ST4000DM000))

fit_range=0:200/1000 # CDF from 0 to 30%

par_fit_W<-data.frame(predict(fit_model_weibull, newdata=list(model='ST4000DM000'),se=T,type="quantile",p=fit_range))
par_fit_W$survival<-1.0-fit_range
par_fit_W$se[is.na(par_fit_W$se)]=0.0 # fix undefined Se at 0 

par_fit_E<-data.frame(predict(fit_model_exp, newdata=list(model='ST4000DM000'),se=T,type="quantile",p=fit_range))
par_fit_E$survival<-1.0-fit_range
par_fit_E$se[is.na(par_fit_E$se)]=0.0 # fix undefined Se at 0 



ggplot(k_m_fit,aes(x=time,y=estimate))+
  geom_line(aes(colour='K-M'),alpha=0.6)+
  geom_line(aes(x=time,y=conf.low,colour='K-M'),lty=2,alpha=0.6)+
  geom_line(aes(x=time,y=conf.high,colour='K-M'),lty=2,alpha=0.6)+
  geom_line(data=par_fit_W,aes(x=fit,y=survival,colour='Weibull'),alpha=0.4)+
  geom_line(data=par_fit_W,aes(x=fit+se*1.96,y=survival,colour='Weibull'),lty=2,alpha=0.4)+
  geom_line(data=par_fit_W,aes(x=fit-se*1.96,y=survival,colour='Weibull'),lty=2,alpha=0.4)+
  geom_line(data=par_fit_E,aes(x=fit,y=survival,colour='Exponential'),alpha=0.4)+
  geom_line(data=par_fit_E,aes(x=fit+se*1.96,y=survival,colour='Exponential'),lty=2,alpha=0.4)+
  geom_line(data=par_fit_E,aes(x=fit-se*1.96,y=survival,colour='Exponential'),lty=2,alpha=0.4)+
  scale_colour_manual(values=c("black", "red", "green"), 
                      name="Fit type",
                      breaks=c("K-M", "Weibull", "Exponential"))
  
    
png("figure/figure10.png",width=800,height=600)


newdat<-expand.grid(model=levels(hdd_common$model))
newdat_W<-cbind(newdat,predict(fit_model_weibull, newdata=newdat,type="quantile",p=0.1,se=T))
newdat_E<-cbind(newdat,predict(fit_model_exp, newdata=newdat,type="quantile",p=0.1,se=T))
newdat_W$fit_type='Weibull'
newdat_E$fit_type='Exponential'

newdat<-rbind(newdat_W,newdat_E)

ggplot(newdat,aes(x=model,y=fit,ymin=fit-1.96*se.fit,ymax=fit+1.96*se.fit,colour=fit_type))+
    geom_errorbar()+geom_point()+coord_flip()+ylab('Days of service')+
    xlab('HDD Model')+
    ggtitle('Expected time to 10% failure')


  
  