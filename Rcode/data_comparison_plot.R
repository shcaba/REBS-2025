library(here)
library(r4ss)
library(dplyr)
library(ggplot2)
library(tibble)

ref_model <- r4ss::SS_read(here::here('Document','report','ref_model'))

ref_model_dir <- file.path(here::here('Document','report','ref_model'))

ref_replist <- SS_output(dir = ref_model_dir)

#SS_plots(replist = replist, plot = 24, dir = here::here('Rcode','SSplotComparisions_output','data_comparisons'))

r4ss::SSplotData(ref_replist, plotdir = here::here('Rcode','SSplotComparisions_output','data_comparisons'))

savethisplot <- r4ss::SSplotData(ref_replist, plotdir = here::here('Rcode','SSplotComparisions_output','data_comparisons'))

ref_model_df <- savethisplot$typetable2

ref_model$dat$fleetnames

fleetnames <- c("1" = "BOTTOM_TRAWL", "2" = "BOTTOM_TRAWL_DISCARD", "3" = "NON_TRAWL", "4" = "NON_TRAWL_DISCARD", "5" = "MIDWATER_TRAWL", "6" = "AT_SEA_HAKE", "7" = "TRIENNIAL", "8" = "AK_SLOPE", "9" = "NW_SLOPE", "10" = "WCGBTS")  # from your SS model

ref_model_df <- ref_model_df %>%
  mutate(
    fleetnames = fleetnames[as.character(fleet)]
  )

prev_model <- r4ss::SS_read(here::here('models','Model_1_sex_minus_1'))

prev_model_dir <- file.path(here::here('models','Model_1_sex_minus_1'))

prev_replist <- SS_output(dir = prev_model_dir)

r4ss::SSplotData(prev_replist, plotdir = here::here('Rcode','SSplotComparisions_output','data_comparisons'))

savethisplottoo <- r4ss::SSplotData(prev_replist, plotdir = here::here('Rcode','SSplotComparisions_output','data_comparisons'))

prev_model_df <- savethisplottoo$typetable2

prev_model$dat$fleetnames

fleetnames <- c("1" = "BOTTOM_TRAWL", "2" = "NON_TRAWL", "3" = "AT_SEA_HAKE", "4" = "TRIENNIAL", "5" = "AK_SLOPE", "6" = "NW_SLOPE", "7" = "WCGBTS")  # from your SS model

prev_model_df <- prev_model_df %>%
  mutate(
    fleetnames = fleetnames[as.character(fleet)]
  )

prev_model_df <- prev_model_df %>%
  dplyr::filter(typename != "mnwgt")

#prev_model_df_bt_discard <- prev_model_df %>%
#  dplyr::filter(typename == "discard" & fleetnames == "BOTTOM_TRAWL")

prev_model_df <- prev_model_df %>%
  dplyr::filter(!(typename == "discard" & fleetnames %in% c("BOTTOM_TRAWL", "NON_TRAWL")))

prev_catch <- prev_replist$catch
prev_catch$all_dis <- prev_catch$dead_bio - prev_catch$ret_bio

prev_bt_nt_dis <- prev_catch %>%
  filter(Fleet %in% c("1","2")) %>%
  select(Yr, Fleet, Fleet_Name, all_dis)

prev_bt_nt_dis$itype <- 6
prev_bt_nt_dis$typename <- "catch"

prev_bt_nt_dis <- prev_bt_nt_dis %>%
  select(Yr, Fleet, itype, typename, Fleet_Name, all_dis) %>%
  mutate(Fleet_Name = recode(Fleet_Name,
                             "TRAWL" = "BOTTOM_TRAWL_DISCARD",
                             "FIXED" = "NON_TRAWL_DISCARD"
  ))

colnames(prev_bt_nt_dis) <- c("yr","fleet","itype","typename","fleetnames","size")

prev_model_df <- rbind(prev_model_df, prev_bt_nt_dis)


both_models <- rbind(
  cbind(ref_model_df, source = "ref"),
  cbind(prev_model_df, source = "prev")
)

both_models <- both_models %>%
  mutate(
    source = factor(source),
    fleetnames = as.character(fleetnames),
    typename = factor(
      typename,
      levels = c("catch", "cpue", "lendbase", "condbase")
    ),
    fleet_source = paste(fleetnames, source, sep = " - ")  # new y-axis
  )

#if we want bubble size to scale for lengths and ages
both_models <- both_models %>%
  mutate(size_scaled = case_when(
    typename == "catch" ~ size / max(size[typename == "catch"], na.rm = TRUE),
    typename == "cpue" ~ 0.1,  # fixed bubble size
    typename == "lendbase" ~ size / max(size[typename == "lendbase"], na.rm = TRUE),
    typename == "condbase" ~ size / max(size[typename == "condbase"], na.rm = TRUE)
  ))

facet_labels <- c(
  catch = "Catch",
  cpue = "Indices",
  lendbase = "Lengths",
  condbase = "Ages"
)

labels_use <- both_models %>%
  distinct(fleet_source, fleetnames) %>%
  tibble::deframe()  

################################################
#use this for all bubbles same size
data_comparison_plot <- ggplot(both_models, aes(
  x = yr,
  y = factor(fleet_source),
  color = source,
  #  size = size
)) +
  geom_point(alpha = 0.7) +
  facet_grid(typename ~ ., scales = "free_y", space = "free_y", labeller = labeller(typename = facet_labels)) +
  scale_color_manual(
    values = c("ref" = "blue", "prev" = "lightblue"),
    labels = c("ref" = "2025", "prev" = "2013"),
    name = "Assessment"
  ) +
  #  scale_size(range = c(1, 6)) +
  #  guides(size = "none") +
  scale_y_discrete(labels = labels_use) +
  labs(
    x = "Year",
    y = "Fleet",
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 6),
    axis.text.x = element_text(size = 7),
    legend.text = element_text(size = 7),
    legend.title = element_text(size = 8),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 8)
  )
######################################################
#or use this for bubbles scaled for lengths and ages
data_comparison_plot <- ggplot(both_models, aes(
  x = yr,
  y = factor(fleet_source),
  color = source,
  size = size_scaled
)) +
  geom_point(alpha = 0.7) +
  facet_grid(typename ~ ., scales = "free_y", space = "free_y", labeller = labeller(typename = facet_labels)) +
  scale_color_manual(
    values = c("ref" = "blue", "prev" = "lightblue"),
    labels = c("ref" = "2025", "prev" = "2013"),
    name = "Assessment"
  ) +
  scale_size(range = c(0.5, 4)) +
  guides(size = "none") +
  scale_y_discrete(labels = labels_use) +
  labs(
    x = "Year",
    y = "Fleet",
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 6),
    axis.text.x = element_text(size = 7),
    legend.text = element_text(size = 7),
    legend.title = element_text(size = 8),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 8)
  )
#################################################

ggsave(
  filename = "data_comparison_2013_2025.png",           
  plot = data_comparison_plot,                              
  path = here::here("Document", "report", "plots_4_doc"),
  width = 4, height = 5, units = "in", dpi = 300 
)
