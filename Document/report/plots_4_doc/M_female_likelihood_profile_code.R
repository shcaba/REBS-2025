library(ggplot2)

M_vals<-read.csv("C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/Like_profiles/Male_M/NatM_uniform_Mal_GP_1_results_plots.csv")

ggplot(M_vals,aes(M,Diff_like, color=ref))+
  geom_point()+
  ylab("Likelihood difference from reference model")+
  xlab("Natural mortality")+
  facet_wrap(~Sex)+
  geom_hline(yintercept=c(2.5),col="red")+
  scale_color_manual(values=c("black", "green"))+
  theme(legend.position = "none")
  

recr_es_table$`Lower Interval`[recr_es_table$`Lower Interval`<0]<-"<1"

spr_es_table <- spr_es$table
spr_es_table$`LowerInterval(SPR)`[recr_es_table$`LowerInterval(SPR)`<0]<-"<0.0001"
spr_es_cap <- spr_es$cap
rm(spr_es)
