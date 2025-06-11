library(here)
library(r4ss)
library(dplyr)
library(purrr)
library(furrr)
library(ggplot2)


#SET UP BASE MODEL, DONT NEED TO RERUN THIS
#############################################################################
#testing ref folder

ref_model <- r4ss::SS_read(here::here('Document','report','ref_model'))
#this error:
#Multiple files in directory match pattern *.par, choosing based on the preferences described in the help for get_par_name(): ss3.par

#copied over the files from the google drive in models/base_model

#run base model

base_model_dir <- file.path(here::here('models','base_model'))

#add plots to base model folder

base_replist <- SS_output(dir = base_model_dir)
SS_plots(base_replist)


rcr_base_model_dir <- file.path(here::here('models','rcr_base_model'))

copy_SS_inputs(
  dir.old = base_model_dir, 
  dir.new = rcr_base_model_dir,
  create.dir = TRUE,
  overwrite = TRUE,
  use_ss_new = FALSE,
  verbose = TRUE
)

rcr_base_model <- r4ss::SS_read(here::here('models','rcr_base_model'))

r4ss::get_ss3_exe(dir = rcr_base_model_dir)

r4ss::run(dir = rcr_base_model_dir, show_in_console = TRUE, extras = "-nohess")

replist <- SS_output(dir = rcr_base_model_dir)

SS_plots(replist)

##############################################################

#start sensitivity runs here

model_directory <- here::here(
  'models')
base_model_dir <- here::here(
  'models',
  'RB_ref_model_updated'
)
#exe_loc <- here::here('models/base_model')
base_model <- SS_read(base_model_dir, ss_new = TRUE)
base_out <- SS_output(base_model_dir)

###############################################################
#################  Proportional fecundity to weight ###########
###############################################################

base_model <- SS_read(base_model_dir, ss_new = TRUE)

sensi_mod <- base_model

sensi_dir <- here::here('models/repro_sensitivities/proportional_fecundity')

sensi_mod$start$init_values_src <- 0

#base model fecundity option is 2 (cubic), change it to 1 (linear)
sensi_mod$ctl$fecundity_option <- 1

#change a to 1, b to 0
sensi_mod$ctl$MG_parms["Eggs_alpha_Fem_GP_1", ]$INIT <- 1
sensi_mod$ctl$MG_parms["Eggs_alpha_Fem_GP_1", ]$PRIOR <- 1

sensi_mod$ctl$MG_parms["Eggs_beta_Fem_GP_1", ]$INIT <- 0
sensi_mod$ctl$MG_parms["Eggs_beta_Fem_GP_1", ]$PRIOR <- 0

SS_write(
  sensi_mod,
  sensi_dir,
  overwrite = TRUE
)

r4ss::get_ss3_exe(dir = sensi_dir)

r4ss::run(dir = sensi_dir, show_in_console = TRUE, extras = "-nohess")

replist <- r4ss::SS_output(dir = sensi_dir)
r4ss::SS_plots(replist)

models <- c(base_model_dir, sensi_dir)
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/sensitivities/1_proportional_fecundity"),
                  legendlabels = c("2025 base model", "Proportional fecundity"),
                  print = TRUE
)


####################################################
#try this with ss_new = FALSE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

base_model <- SS_read(base_model_dir, ss_new = FALSE)

sensi_mod <- base_model

sensi_dir <- here::here('models/repro_sensitivities/proportional_fecundity_old')

#base model fecundity option is 2 (cubic), change it to 1 (linear)
sensi_mod$ctl$fecundity_option <- 1 #linear fecundity to length

SS_write(
  sensi_mod,
  sensi_dir,
  overwrite = TRUE
)

r4ss::get_ss3_exe(dir = sensi_dir)

r4ss::run(dir = sensi_dir, show_in_console = TRUE, extras = "-nohess")

replist <- r4ss::SS_output(dir = sensi_dir)
r4ss::SS_plots(replist)

#there is a small difference between these runs

###############################################################
#################  Functional maturity A50 ###################
###############################################################

base_model <- SS_read(base_model_dir, ss_new = TRUE)

sensi_mod <- base_model

sensi_dir <- here::here('models/repro_sensitivities/maturity_a50')

sensi_mod$start$init_values_src <- 0

sensi_mod$ctl$maturity_option <- 2 #age logistic
#supply A50 values

sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$INIT <- 26.01807
sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$PRIOR <- 26.01807

sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$INIT <- -0.13084
sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$PRIOR <- -0.13084

SS_write(
  sensi_mod,
  sensi_dir,
  overwrite = TRUE
)

r4ss::get_ss3_exe(dir = sensi_dir)

r4ss::run(dir = sensi_dir, show_in_console = TRUE, extras = "-nohess")

replist <- r4ss::SS_output(dir = sensi_dir)
r4ss::SS_plots(replist)

models <- c(base_model_dir, sensi_dir)
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/sensitivities/2_maturity_a50"),
                  legendlabels = c("2025 base model", "Functional maturity A50"),
                  print = TRUE
)

###############################################################
###  Genetically confirmed Blackspotted functional L50  ############
###############################################################

base_model <- SS_read(base_model_dir, ss_new = TRUE)

sensi_mod <- base_model

sensi_dir <- here::here('models/repro_sensitivities/blackspotted_l50')

sensi_mod$start$init_values_src <- 0

sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$INIT <- 51.44882
sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$PRIOR <- 51.44882

sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$INIT <- -0.2926
sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$PRIOR <- -0.2926

SS_write(
  sensi_mod,
  sensi_dir,
  overwrite = TRUE
)

r4ss::get_ss3_exe(dir = sensi_dir)

r4ss::run(dir = sensi_dir, show_in_console = TRUE, extras = "-nohess")

replist <- r4ss::SS_output(dir = sensi_dir)
r4ss::SS_plots(replist)

models <- c(base_model_dir, sensi_dir)
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/sensitivities/3_blackspotted_l50"),
                  legendlabels = c("2025 base model", "Blackspotted functional maturity L50"),
                  print = TRUE
)

###############################################################
###  Genetically confirmed Rougheye functional L50  ############
###############################################################

base_model <- SS_read(base_model_dir, ss_new = TRUE)

sensi_mod <- base_model

sensi_dir <- here::here('models/repro_sensitivities/rougheye_l50')

sensi_mod$start$init_values_src <- 0

sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$INIT <- 43.56674
sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$PRIOR <- 43.56674

sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$INIT <- -0.42588
sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$PRIOR <- -0.42588

SS_write(
  sensi_mod,
  sensi_dir,
  overwrite = TRUE
)

r4ss::get_ss3_exe(dir = sensi_dir)

r4ss::run(dir = sensi_dir, show_in_console = TRUE, extras = "-nohess")

replist <- r4ss::SS_output(dir = sensi_dir)
r4ss::SS_plots(replist)

models <- c(base_model_dir, sensi_dir)
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/sensitivities/4_rougheye_l50"),
                  legendlabels = c("2025 base model", "Rougheye functional maturity L50"),
                  print = TRUE
)


###############################################################
###################  Biological L50  ##########################
###############################################################

base_model <- SS_read(base_model_dir, ss_new = TRUE)

sensi_mod <- base_model

sensi_dir <- here::here('models/repro_sensitivities/biological_l50')

sensi_mod$start$init_values_src <- 0

sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$INIT <- 42.91512
sensi_mod$ctl$MG_parms["Mat50%_Fem_GP_1", ]$PRIOR <- 42.91512

sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$INIT <- -0.26047
sensi_mod$ctl$MG_parms["Mat_slope_Fem_GP_1", ]$PRIOR <- -0.26047

SS_write(
  sensi_mod,
  sensi_dir,
  overwrite = TRUE
)

r4ss::get_ss3_exe(dir = sensi_dir)

r4ss::run(dir = sensi_dir, show_in_console = TRUE, extras = "-nohess")

replist <- r4ss::SS_output(dir = sensi_dir)
r4ss::SS_plots(replist)

models <- c(base_model_dir, sensi_dir)
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/sensitivities/5_biological_l50"),
                  legendlabels = c("2025 base model", "Biological maturity L50"),
                  print = TRUE
)

#################################################################

#comparison plots for all repro sensitivities

models <- c(base_model_dir, here::here('models/repro_sensitivities/proportional_fecundity'), 
                            here::here('models/repro_sensitivities/maturity_a50'),
                            here::here('models/repro_sensitivities/blackspotted_l50'),
                            here::here('models/repro_sensitivities/rougheye_l50'),
                            here::here('models/repro_sensitivities/biological_l50'))
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SSplotComparisons(models_summary,
                  plotdir = here::here("Rcode/SSplotComparisons_output/sensitivities/6_all_repro_bio"),
                  legendlabels = c("2025 base model", "Proportional fecundity", "Functional maturity A50", "Blackspotted functional maturity L50", "Rougheye functional maturity L50", "Biological maturity L50"),
                  print = TRUE,
                  legendloc = "bottomright"
)

#############################################################
#comparison table for all repro sensitivities

models <- c(base_model_dir, here::here('models/repro_sensitivities/proportional_fecundity'), 
            here::here('models/repro_sensitivities/maturity_a50'),
            here::here('models/repro_sensitivities/blackspotted_l50'),
            here::here('models/repro_sensitivities/rougheye_l50'),
            here::here('models/repro_sensitivities/biological_l50'))
models
models_output <- SSgetoutput(dirvec = models)
models_summary <- SSsummarize(models_output)
SStableComparisons(models_summary,
                   modelnames = c("2025 base model", "Proportional fecundity", "Functional maturity A50", "Blackspotted functional maturity L50", "Rougheye functional maturity L50", "Biological maturity L50"),
                   csv = TRUE,
                   csvdir = here::here("Rcode/SSplotComparisons_output/sensitivities/6_all_repro_bio"))
