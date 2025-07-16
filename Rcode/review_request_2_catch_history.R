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

historical_catch_model <- base_model

historical_catch_model$start$init_values_src <- 0

historical_catch_model_dir <- here::here(
  'models',
  'historical_catch_model'
)

catch_data <- historical_catch_model$dat$catch

# Fleet 1: Commercial bottom trawl fishery.
# Fleet 2: Dead discard from bottom trawl fishery.
# Fleet 3: Commercial non-trawl (mainly the long-line) fishery.
# Fleet 4: Dead discard from non-trawl fishery.
# Fleet 5: Contemporary mid-water trawl fishery.
# Fleet 6: At-sea hake fishery bycatch.


#remove fleet 1 and 3 catch data prior to 1981
catch_data_minus_fleets <- catch_data %>%
  filter(fleet != 1) %>%
  filter(fleet != 3)

catch_data_add_1 <- catch_data %>%
  filter(fleet == 1 & year > 1980) 

catch_data_add_3 <- catch_data %>%
  filter(fleet == 3 & year > 1980)

#multiply fleet 1 by 1.5 (pre 1981)

fleet_1_pre1981 <- catch_data %>%
  filter(year < 1981) %>%
  filter(fleet == 1) %>%
  mutate(catch = catch * 1.5)

#multiply fleet 3 by 1.5 (pre 1981)

fleet_3_pre1981 <- catch_data %>%
  filter(year < 1981) %>%
  filter(fleet == 3) %>%
  mutate(catch = catch * 1.5)

catch_data_1.5historical <- rbind(catch_data_minus_fleets, catch_data_add_1, catch_data_add_3, fleet_1_pre1981, fleet_3_pre1981)

historical_catch_model$dat$catch <- catch_data_1.5historical

r4ss::SS_write(historical_catch_model, dir = historical_catch_model_dir, overwrite = TRUE)

r4ss::get_ss3_exe(dir = historical_catch_model_dir)

#r4ss::run(dir = historical_catch_model_dir, show_in_console = TRUE, extras = "-nohess")
r4ss::run(dir = historical_catch_model_dir, show_in_console = TRUE)

replist <- SS_output(dir = historical_catch_model_dir)
SS_plots(replist)

####################################################
models <- c(base_model_dir, historical_catch_model_dir)
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/review/request_2"),
                  legendlabels = c("2025 base model", "1.5 * catch < year 1981"),
                  print = TRUE,
                  legendloc = "bottomright"
)
