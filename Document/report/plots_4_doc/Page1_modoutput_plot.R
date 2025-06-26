library(ggplot2)
library(viridis)

assessment_comps_1325<-read.csv("C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/plots_4_doc/Comp_2013_2025.csv")
catch_col="black"
Model_2025<-subset(assessment_comps_1325,Model=="2025")

#pal <- wes_palette("AsteroidCity3", 100, type = "continuous")
pal <- viridis(100)
ggplot(assessment_comps_1325,aes(x=Year))+
  geom_point(aes(y = Depletion,colour=Scale_comp))+
  geom_ribbon(aes(x = Year,ymin = Lowdep, ymax = Hidep,group=Model),fill = "gray30", alpha = 0.2)+
  geom_line(aes(y = Depletion_line,group="Model"),col="black")+
  ylim(0,1.2)+
  labs(colour="Absolute abundance multiplier of current vs past model values")+
  geom_hline(yintercept = c(0.4,0.25),col=c("black","red"),linetype = c("dashed","solid"))+
  #scale_colour_gradientn(colours = pal,breaks=c(1:6),labels=c("1x 2013","2x 2013","3x 2013","4x 2013","5x 2013","6x 2013"))+
  scale_colour_gradientn(colours = pal,breaks=c(1:6))+
  ylab("Relative Stock Status")+
  theme_bw()+
  theme(legend.position = "top",legend.key.width = unit(2.5, "cm"))+
  guides(colour = guide_colorbar(title.position = "top"))+
  geom_line(aes(x = Year,y = Catch_stand),col=viridis(1))+
  annotate(geom="text",x=c(1905,1903),y=c(0.45,0.21),label=c("Target stock status","Limit stock status"),color=c("black","red"))+
  annotate(geom="text",x=c(2013),y=c(0.07),label=c("Catch history"),color=col=viridis(1))

  
  
  
  
    scale_y_continuous(
    name = "Relative Stock Status",
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.+ assessment_comps_1325$Diff_catch_dep, name="Total Removals (mt)")
  )
