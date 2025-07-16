library(here)
library(r4ss)
library(dplyr)
library(purrr)
library(furrr)
library(ggplot2)


base_model_dir <- here::here(
  'Document',
  'report',
  'ref_model'
)

base_model <- r4ss::SS_read(base_model_dir, ss_new = TRUE)
#base_out <- r4ss::SS_output(base_model_dir)

recdev1920_model <- base_model

recdev1920_model$start$init_values_src <- 0

recdev1920_model_dir <- here::here(
  'models',
  'recdev1920_model'
)

ctlfile <- recdev1920_model$ctl
ctlfile$MainRdevYrFirst <- 1920

recdev1920_model$ctl <- ctlfile

r4ss::SS_write(recdev1920_model, dir = recdev1920_model_dir, overwrite = TRUE)

r4ss::get_ss3_exe(dir = recdev1920_model_dir)

#r4ss::run(dir = recdev1920_model_dir, show_in_console = TRUE, extras = "-nohess")
r4ss::run(dir = recdev1920_model_dir, show_in_console = TRUE)

replist <- SS_output(dir = recdev1920_model_dir)
SS_plots(replist)

####################################################
models <- c(base_model_dir, recdev1920_model_dir)
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/review/request_8"),
                  legendlabels = c("2025 base model", "recdevs first year 1920"),
                  print = TRUE,
                  legendloc = "bottomright"
)

###########################################
retro(
  dir = recdev1920_model_dir, # wherever the model files are
  oldsubdir = "", # subfolder within dir
  newsubdir = "retrospectives", # new place to store retro runs within dir
  years = 0:-5, # years relative to ending year of model
  exe = "ss3",
  extras = "-nohess"
  )
