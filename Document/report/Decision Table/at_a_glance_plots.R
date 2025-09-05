library(ggplot2)
library(tidyr)
library(dplyr)
library(stringr)
library(r4ss)

model_output <- r4ss::SS_output(here::here("C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/Decision Table/Reference"),covar=FALSE, printstats = FALSE, verbose = FALSE)
model_output_high <- r4ss::SS_output(here::here("C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/Decision Table/High"),covar=FALSE, printstats = FALSE, verbose = FALSE)
model_output_low <- r4ss::SS_output(here::here("C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/Decision Table/Low"),covar=FALSE, printstats = FALSE, verbose = FALSE)
mymodels <- list(model_output_high,model_output,model_output_low)
mysummary <- SSsummarize(mymodels)

############################################
############################################
#Plot removals figure (front page middle panel)
old.fleets<-unique(model_output$catch$Fleet_Name)
new.fleet<-c("Bottom trawl","Bottom trawl discard","Non-trawl","Non-trawl discard","Midwater","At-sea Hake")
landings <- model_output$catch |> 
  dplyr::mutate(
    year = Yr,
    catch_mt = dead_bio,
    Fleet = dplyr::case_when(
      Fleet_Name == old.fleets[1] ~ new.fleet[1],
      Fleet_Name == old.fleets[2] ~ new.fleet[2],
      Fleet_Name == old.fleets[3] ~ new.fleet[3],
      Fleet_Name == old.fleets[4] ~ new.fleet[4],
      Fleet_Name == old.fleets[5] ~ new.fleet[5],
      Fleet_Name ==old.fleets[6] ~ new.fleet[6],
      .default = Fleet_Name)
  )


ggplot(landings,  aes(x = year, y = catch_mt, fill = Fleet)) +
  geom_bar(stat = 'identity') +
  theme_bw() +
  labs(x = "Year", y = "Removals (mt)") +
  xlim(NA, 2025) + 
  scale_y_continuous(
    labels = function(x) format(x, scientific = FALSE)) +
  scale_fill_viridis_d() +
  theme(
    legend.key.height =  unit(0.05, "cm"),
    legend.position = 'inside',
    legend.position.inside = c(0.175, 0.8),
    legend.title=element_text(size = 16), 
    legend.text =  element_text(size = 14),
    axis.text.y =  element_text(angle = 0, vjust = 0.5, hjust = 0.5),
    axis.text =  element_text(size = 19),
    axis.title =  element_text(size = 21)
  )

ggsave(filename = "C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/Decision Table/removals.png", height = 8/1.7, width = 8, dpi = 500)


############################################
############################################
#Plot stock status with error and states of nature (front page bottom panel)
SSplotComparisons(mysummary,subplots=4,col=c("#6DCD59FF","#440154FF", "#1F9E89FF"),
                  print=TRUE,
                  plotdir="C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/Decision Table",
                  legendlabels = c("High State of Nature","Reference","Low State of Nature"),
                  legendloc = "topleft",legendncol=1)


#Spawning Output
model_output_high_no_var <- r4ss::SS_output(here::here("C:/Users/Jason.Cope/Documents/Current Action/Assessments/Rougheye_blackspotted_2025/STAR requests/Request 13/Using base model catches/M0.039_nohess"),covar=FALSE, printstats = FALSE, verbose = FALSE)
mymodels_SO <- list(model_output_high_no_var,model_output,model_output_low)
mysummary_SO <- SSsummarize(mymodels_SO)

SSplotComparisons(mysummary_SO,subplots=2,col=c("#6DCD59FF","#440154FF", "#1F9E89FF"),
                  print=TRUE,
                  plotdir="C:/Users/Jason.Cope/Documents/Github/REBS-2025/Document/report/Decision Table",
                  legendlabels = c("High State of Nature","Reference","Low State of Nature"),
                  legendloc = "topleft",legendncol=1)














#make above in ggplot2
bratio_pt <- mysummary[["Bratio"]] %>%
  pivot_longer(
    cols = starts_with("model"),
    names_to = "Model",
    values_to = "Bratio"
  )

bratio_lims <- purrr::map(mysummary[c('BratioLower', 'BratioUpper')], pivot_longer,
                          cols = starts_with('model'), names_to = 'Model', 
                          values_to = 'Bratio'
) |>
  bind_rows(.id = 'lim') |>
  filter(Model == 'model2') |>
  pivot_wider(names_from = lim, values_from = Bratio)

p1 <- ggplot(bratio_pt) +
  geom_ribbon(aes(x = Yr, ymin = BratioLower, ymax = BratioUpper), 
              data = bratio_lims, fill = "blue", alpha = 0.2) +
  geom_line(aes(x = Yr, y = Bratio, color = Model), size = 1.2) +
  labs(x = "Year", y = "Fraction of unfished\nspawning output") +
  lims(x = c(2000, 2037)) +
  scale_color_manual(labels = c("High State of Nature", "Base Model","Low State of Nature"), 
                     values = c("darkolivegreen4", "blue", "brown4")) +
  annotate('rect', xmin = 2025, xmax = 2037, ymin = 0, ymax = 1, alpha = 0.3, fill='gray35') +
  geom_hline(yintercept = 0.25, linetype = "dashed", color = "red", linewidth = 0.7) +
  geom_hline(yintercept = 0.40, linetype = "dashed", color = "red", linewidth = 0.7) +
  annotate(geom = "text", x = 2015, y = 0.41, label = "Management Target", 
           color = "red", vjust = 0, size = 5) +
  annotate(geom = "text", x = 2015, y = 0.26, label = "Minimum Stock Size Threshold", 
           color = "red", vjust = 0, size = 5) +
  annotate(geom="text", x = 2027, y = 0.05, label = "Forecast Period", 
           color = "gray35", hjust = 0, size = 5) +
  annotate(geom = "text", x = 2000, y = 0.02, 
           label = "Blue shading represents 95% uncertainty range\nfor the base model", 
           color = "gray40", hjust = 0, vjust = 0, size = 4) +
  theme_bw() +
  theme(
    # plot.margin = margin(60, 5.5, 5.5, 5.5, unit = 'pt'),
    legend.key.height = unit(0.05, "cm"),
    legend.position = 'inside',
    legend.position.inside = c(0.80, 1),
    legend.title = element_blank(), 
    legend.text = element_text(size = 16),
    axis.text = element_text(size = 19),
    axis.title = element_text(size = 21)
  ) +
  NULL

p2 <- ggplot() +
  geom_ribbon(aes(x = Yr, ymin = BratioLower, ymax = BratioUpper), 
              data = bratio_lims, fill = "blue", alpha = 0.2) +
  geom_line(data = bratio_pt, aes(x=Yr,y=Bratio, color = Model), size = 0.8) +
  scale_color_manual(values = c("darkolivegreen4", "blue", "brown4")) +
  annotate('rect', xmin = 2025, xmax = 2037, ymin = 0, ymax = 1.0, alpha = 0.3, fill='gray35') +
  geom_hline(yintercept = 0.25, linetype = "dashed", color = "red", size = 0.5) +
  geom_hline(yintercept = 0.40, linetype = "dashed", color = "red", size = 0.5) +
  theme_bw() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(size = 14),
    axis.text.y = element_blank(),
    axis.title = element_blank(), 
  ) +
  NULL

layout <- c(
  patchwork::area(t = 3, l = 1, b = 17, r = 50),
  patchwork::area(t = 1, l = 2, b = 5, r = 22)
)

p1 + p2 + patchwork::plot_layout(design = layout)

ggsave(filename = here::here("figures", "at_at_glance", "fraction_unfished.png"), height = 8/1.7, width = 8, dpi = 500)


#### mean age

png(filename = here::here("figures", "at_at_glance", "mean_age.png"), height = 6/1.7, width = 6, units = 'in', res = 500)
r4ss::SSMethod.TA1.8(fit = model_output, type = 'age', fleet = 1, 
                     plotadj = FALSE, label.part = FALSE, 
                     fleetnames = rep('', 7))
dev.off()

#### rec index

model_output$cpue |> 
  filter(Fleet_name == 'SMURF') |>
  ggplot(aes(x = Yr)) +
  geom_line(aes(y = Exp), col = '#2297E6', linewidth = 1) +
  geom_point(aes(y = Obs)) +
  geom_linerange(aes(ymin = qlnorm(0.025, meanlog = log(Obs), sdlog = SE_input),
                     ymax = qlnorm(0.975, meanlog = log(Obs), sdlog = SE_input))) +
  labs(x = 'Year', y = 'Recruitment index') +
  theme_bw(16)