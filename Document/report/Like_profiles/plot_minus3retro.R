library(ggplot2)

load("C:/Users/Jason.Cope/Documents/Current Action/Assessments/Rougheye_blackspotted_2025/Sensitivities/Profiles/Ref_model_STAR-3_R0515_profile_SR_LN(R0)/SR_LN(R0)_profile_output.Rdata")
likes<-as.numeric(profilesummary$likelihoods[1,1:21])
R0<-as.numeric(profilesummary$pars[profilesummary$pars$Label=="SR_LN(R0)",1:21])
Retro3_likes<-data.frame(lnR0=R0,Likelihood=likes,Like_diff=likes-(min(likes)))

ggplot(Retro3_likes[-(1:3),],aes(lnR0,Like_diff))+
  geom_line(lwd=1.25)+
  geom_point(aes(x=6.98,y=1.1),col="blue",fill="blue",size=3)+
  geom_hline(yintercept=1.96,col="red",linetype="dashed")+
  ylab("Likelihood difference from minimum value")
  
