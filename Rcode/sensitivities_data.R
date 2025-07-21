### RUN SENSITIVITIES FOR REBS 2025 UPDATE ASSESSMENT
# CODE ADAPTED BY A. WHITMAN (ODFW) & E. PERL (NMFS OST) FROM K. OKEN (NWFSC)

# LAST UPDATE: 07/18/2025

# output directory was corrected, so output available now
# running models individually to ID ones with major issues

# running some items during the STAR 

# 7/18 - updating with new reference model post-STAR

library(here)
library(r4ss)
library(dplyr)
library(purrr)
library(furrr)
library(ggplot2)

# setwd("C:/Github/REBS-2025")
# file.create(".here")
# here::here()

model_directory <- here::here(
  'models'
)
base_model_name <- here::here(
  'models',
  'ref_model'
)
exe_loc <- here::here('Document/report/Sensis/ss3')
base_model <- SS_read(base_model_name, ss_new = T)
base_out <- SS_output(base_model_name)

#base_model$start$init_values_src<-0 # will try if runs with ss_new = F doesn't work

# Write sensitivities -----------------------------------------------------

# Remove Indices ----------------------------------------------------------

## 1) remove Triennial survey 

sensi_mod <- base_model

sensi_mod$start$init_values_src<-0

sensi_mod$dat$CPUE <- sensi_mod$dat$CPUE %>%
  filter(index != 7)

sensi_mod$ctl$Q_options <- sensi_mod$ctl$Q_options[
  -grep('TRIENNIAL', rownames(sensi_mod$ctl$Q_options)),
]
sensi_mod$ctl$Q_parms <- sensi_mod$ctl$Q_parms[
  -grep('TRIENNIAL', rownames(sensi_mod$ctl$Q_parms)),
]

sensi_mod$ctl$Q_parms_tv <- sensi_mod$ctl$Q_parms_tv[
  -grep('TRIENNIAL', rownames(sensi_mod$ctl$Q_parms_tv)),
]

# Need to remove length data, age data, and selectivities. 
# If no catch or index, you can't have length or age data
sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 7)
# no age data for triennial
#sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
#  filter(fleet != 8)

## DON"T NEED TO REMOVE SIZE SELEX

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '01_no_Triennial'
  ),
  overwrite = TRUE
)

# # run manually at STAR with updated base model
# 
# setwd("C:/Github/REBS-2025/models/data_sensitivities/01_no_Triennial")
# shell("ss3 -nohess",wait = T) # no hessian
# #mydir<-getwd()
# #replist<-SS_output(mydir)
# #SS_plots(replist) # creates the plots


## 2) remove AK slope survey

sensi_mod <- base_model

sensi_mod$start$init_values_src<-0

sensi_mod$dat$CPUE <- sensi_mod$dat$CPUE %>%
  filter(index != 8)

sensi_mod$ctl$Q_options <- sensi_mod$ctl$Q_options[
  -grep('AK_SLOPE', rownames(sensi_mod$ctl$Q_options)),
]
sensi_mod$ctl$Q_parms <- sensi_mod$ctl$Q_parms[
  -grep('AK_SLOPE', rownames(sensi_mod$ctl$Q_parms)),
]

# Need to remove length data, age data, and selectivities. 
# If no catch or index, you can't have length or age data
sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 8)
# no age data for AK slope
#sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
#  filter(fleet != 8)

# i think I need to fix the NW slope because it's mirrored to this survey


## DON"T NEED TO REMOVE SIZE SELEX

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '02_no_AK_slope'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/02_no_AK_slope")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 3) remove NW slope survey

sensi_mod <- base_model

sensi_mod$start$init_values_src<-0

sensi_mod$dat$CPUE <- sensi_mod$dat$CPUE %>%
  filter(index != 9)

sensi_mod$ctl$Q_options <- sensi_mod$ctl$Q_options[
  -grep('NW_SLOPE', rownames(sensi_mod$ctl$Q_options)),
]
sensi_mod$ctl$Q_parms <- sensi_mod$ctl$Q_parms[
  -grep('NW_SLOPE', rownames(sensi_mod$ctl$Q_parms)),
]

# Need to remove length data, age data, and selectivities. 
# If no catch or index, you can't have length or age data
sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 9)
# no age data for NW slope
#sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
#  filter(fleet != 8)

## DON"T NEED TO REMOVE SIZE SELEX

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '03_no_NW_slope'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/03_no_NW_slope")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 4) remove WCGBTS survey

sensi_mod <- base_model

sensi_mod$start$init_values_src<-0

sensi_mod$dat$CPUE <- sensi_mod$dat$CPUE %>%
  filter(index != 10)

sensi_mod$ctl$Q_options <- sensi_mod$ctl$Q_options[
  -grep('WCGBTS', rownames(sensi_mod$ctl$Q_options)),
]
sensi_mod$ctl$Q_parms <- sensi_mod$ctl$Q_parms[
  -grep('WCGBTS', rownames(sensi_mod$ctl$Q_parms)),
]

# Need to remove length data, age data, and selectivities. 
# If no catch or index, you can't have length or age data
sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 10)
sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
  filter(fleet != 10)

## DON"T NEED TO REMOVE SIZE SELEX

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '04_no_WCGBTS'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/04_no_WCGBTS")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 4a) remove WCGBTS survey - run during STAR

sensi_mod <- base_model

sensi_mod$start$init_values_src<-0

sensi_mod$dat$CPUE <- sensi_mod$dat$CPUE %>%
  filter(index != 10)

sensi_mod$ctl$Q_options <- sensi_mod$ctl$Q_options[
  -grep('WCGBTS', rownames(sensi_mod$ctl$Q_options)),
]
sensi_mod$ctl$Q_parms <- sensi_mod$ctl$Q_parms[
  -grep('WCGBTS', rownames(sensi_mod$ctl$Q_parms)),
]

# Need to remove length data, age data, and selectivities. 
# If no catch or index, you can't have length or age data

# running without index and length comps (so still includes age data)
sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 10)
# sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
#   filter(fleet != 10)

## DON"T NEED TO REMOVE SIZE SELEX

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '04a_no_WCGBTS_ageonly_hess'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/models/data_sensitivities/04a_no_WCGBTS_ageonly_hess")
# shell("ss3",wait = T) # includes hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots
# 

## 5) remove all indices

sensi_mod <- base_model

sensi_mod$start$init_values_src<-0

#sensi_mod$dat$CPUE$year <- -1 * sensi_mod$dat$CPUE$year
#sensi_mod$ctl$Q_options <- sensi_mod$ctl$Q_parms <- NULL
#sensi_mod$ctl$Q_parms_tv <- NULL

# Need to remove length data, age data, and selectivities. 
# If no catch or index, you can't have length or age data
indices_no_catches <- c(7, 8, 9, 10)
indices_und <- paste0(indices_no_catches, "_")
indices_chr <- paste0("(", indices_no_catches, ")")

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp %>%
  filter(!fleet %in% indices_no_catches)
sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp %>%
  filter(!fleet %in% indices_no_catches)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '05_no_indices'
  ),
  overwrite = TRUE
)
# 
# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/05_no_indices")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 5a) remove all indices except WCGBTS 

sensi_mod <- base_model

sensi_mod$start$init_values_src<-0

sensi_mod$dat$CPUE <- sensi_mod$dat$CPUE %>%
  filter(!index %in% c(7:9))

no_index_names<-c("TRIENNIAL","NW_SLOPE","AK_SLOPE")

sensi_mod$ctl$Q_options <- sensi_mod$ctl$Q_options[
  -grep(paste(no_index_names, collapse = "|"), rownames(sensi_mod$ctl$Q_options)),
]
sensi_mod$ctl$Q_parms <- sensi_mod$ctl$Q_parms[
  -grep(paste(no_index_names, collapse = "|"), rownames(sensi_mod$ctl$Q_parms)),
]

# Need to remove length and age data
indices_no_catches <- c(7, 8, 9)
indices_und <- paste0(indices_no_catches, "_")
indices_chr <- paste0("(", indices_no_catches, ")")

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp %>%
  filter(!fleet %in% indices_no_catches)
sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp %>%
  filter(!fleet %in% indices_no_catches)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '05a_no_indices_except_WCGBTS'
  ),
  overwrite = TRUE
)
 
# setwd("C:/Github/REBS-2025/models/data_sensitivities/05a_no_indices_except_WCGBTS")
# shell("ss3",wait = T) # hessian on
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots

# run comparisons with base model
# 
# # single folder for comparisons
# setwd("C:/Github/REBS-2025/Document/report/Sensis/output/STAR_Request_4")
# mydir<-getwd()

# assign the outputs from each model 
# base<-base_out
# no_indices_ex_WCGBTS<-replist # already did it above
# Minus_tri<-SS_output(dir="C:/Github/REBS-2025/models/data_sensitivities/01_no_Triennial")
# 
# #create comparisons
# mymodels <- list(base,no_indices_ex_WCGBTS,Minus_tri)
# mysummary <- SSsummarize(mymodels)
# modelnames <- c("Base","No indices except WCGBTS","- Triennial")

#add plots to a folder created in the directory you're working in
# the folder needs to be created before this will run 
# SSplotComparisons(mysummary, legendlabels=modelnames,
#                   plotdir=mydir,
#                   print=TRUE,endyr=2024,new=F,densitynames = c("SPB_Virgin","R0"))
# dev.off()


# Remove length comps -----------------------------------------------------

# need to add runs that estimate selex

## 6) remove bottom trawl and BT discard lengths

# We don't need to remove the selex params if we are removing length comps from
# data that has catch

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(!fleet %in% c(1,2))

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '06_no_BT_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/06_no_BT_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 6a) remove bottom trawl only lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 1)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '06a_no_BTonly_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/06a_no_BTonly_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 6b) remove bottom trawl discard lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 2)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '06b_no_BTdis_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/06b_no_BTdis_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 7) remove non-trawl and non-trawl discard lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(!fleet %in% c(3,4))

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '07_no_NT_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/07_no_NT_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 7a) remove non-trawl lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 3)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '07a_no_NTonly_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/07a_no_NTonly_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 7b) remove non-trawl discard lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 4)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '07b_no_NTdis_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/07b_no_NTdis_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots

## 8) remove MWT lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 5)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '08_no_MWT_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/08_no_MWT_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots

## 9) remove at-sea hake lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 6)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '09_no_ASHOP_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/09_no_ASHOP_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots

## 10) remove Triennial lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 7)

# Fix params by *-1 instead of removing them for indices - says Ian

# note from Jason on REBS - will estimate selex without lengths after I run with fixing

sensi_mod$ctl$size_selex_parms[
  grepl('TRIENNIAL', rownames(sensi_mod$ctl$size_selex_parms)),
]$PHASE <-
  abs(
    sensi_mod$ctl$size_selex_parms[
      grepl('TRIENNIAL', rownames(sensi_mod$ctl$size_selex_parms)),
    ]$PHASE
  ) *
  -1

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '10_no_Triennial_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/10_no_Triennial_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots

## 11) remove AK slope lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 8)

sensi_mod$ctl$size_selex_parms[
  grepl('AK_SLOPE', rownames(sensi_mod$ctl$size_selex_parms)),
]$PHASE <-
  abs(
    sensi_mod$ctl$size_selex_parms[
      grepl('AK_SLOPE', rownames(sensi_mod$ctl$size_selex_parms)),
    ]$PHASE
  ) *
  -1

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '11_no_AKslope_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/11_no_AKslope_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 12) remove NW slope lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 9)

sensi_mod$ctl$size_selex_parms[
  grepl('NW_SLOPE', rownames(sensi_mod$ctl$size_selex_parms)),
]$PHASE <-
  abs(
    sensi_mod$ctl$size_selex_parms[
      grepl('NW_SLOPE', rownames(sensi_mod$ctl$size_selex_parms)),
    ]$PHASE
  ) *
  -1

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '12_no_NWslope_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/12_no_NWslope_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 13) remove WCGBTS lengths

sensi_mod <- base_model

sensi_mod$dat$lencomp <- sensi_mod$dat$lencomp |>
  filter(fleet != 10)

sensi_mod$ctl$size_selex_parms[
  grepl('WCGBTS', rownames(sensi_mod$ctl$size_selex_parms)),
]$PHASE <-
  abs(
    sensi_mod$ctl$size_selex_parms[
      grepl('WCGBTS', rownames(sensi_mod$ctl$size_selex_parms)),
    ]$PHASE
  ) *
  -1

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '13_no_WCGBTS_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/13_no_WCGBTS_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 14) remove all fishery length comps

sensi_mod <- base_model

sensi_mod$ctl$lambdas <- sensi_mod$ctl$lambdas |>
  bind_rows(data.frame(
    like_comp = 4,
    fleet = 1:6,
    phase = 1,
    value = 0,
    sizefreq_method = 0
  ))

sensi_mod$ctl$N_lambdas <- nrow(sensi_mod$ctl$lambdas)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '14_no_fishery_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/14_no_fishery_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 15) remove all survey length comps

sensi_mod <- base_model

sensi_mod$ctl$lambdas <- sensi_mod$ctl$lambdas |>
  bind_rows(data.frame(
    like_comp = 4,
    fleet = 7:10,
    phase = 1,
    value = 0,
    sizefreq_method = 0
  ))

sensi_mod$ctl$N_lambdas <- nrow(sensi_mod$ctl$lambdas)

# Turn size selex phase to -1 for indices that don't have catch or aren't mirroring catch selectivity
indices_list <- paste0(
  "TRIENNIAL",
  "AK_SLOPE",
  "NW_SLOPE",
  "WCGBTS",
  collapse = "|"
)
sensi_mod$ctl$size_selex_parms[
  grepl(indices_list, rownames(sensi_mod$ctl$size_selex_parms)),
]$PHASE <-
  abs(
    sensi_mod$ctl$size_selex_parms[
      grepl(indices_list, rownames(sensi_mod$ctl$size_selex_parms)),
    ]$PHASE
  ) *
  -1

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '15_no_survey_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/15_no_survey_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 16) remove all length comps

sensi_mod <- base_model

sensi_mod$ctl$lambdas <- sensi_mod$ctl$lambdas |>
  bind_rows(data.frame(
    like_comp = 4,
    fleet = 1:10,
    phase = 1,
    value = 0,
    sizefreq_method = 0
  ))

sensi_mod$ctl$N_lambdas <- nrow(sensi_mod$ctl$lambdas)

# # Turn size selex phase to -1 for indices that don't have catch or aren't mirroring catch selectivity
indices_list <- paste0(
  "TRIENNIAL",
  "AK_SLOPE",
  "NW_SLOPE",
  "WCGBTS",
  collapse = "|"
)
sensi_mod$ctl$size_selex_parms[
  grepl(indices_list, rownames(sensi_mod$ctl$size_selex_parms)),
]$PHASE <-
  abs(
    sensi_mod$ctl$size_selex_parms[
      grepl(indices_list, rownames(sensi_mod$ctl$size_selex_parms)),
    ]$PHASE
  ) *
  -1

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '16_no_lengths'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/16_no_lengths")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


# Remove age comps --------------------------------------------------------

## 17) remove bottom trawl ages 

sensi_mod <- base_model

sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
  filter(fleet != 1)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '17_no_BT_ages'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/17_no_BT_ages")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 18) remove non-trawl ages

sensi_mod <- base_model

sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
  filter(fleet != 3)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '18_no_NT_ages'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/18_no_NT_ages")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots
# 

## 19) remove MWT trawl ages

sensi_mod <- base_model

sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
  filter(fleet != 5)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '19_no_MWT_ages'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/19_no_MWT_ages")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 20) remove ASHOP ages

sensi_mod <- base_model

sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
  filter(fleet != 6)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '20_no_ASHOP_ages'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/20_no_ASHOP_ages")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots

## 21) remove WCGBTS ages

sensi_mod <- base_model

sensi_mod$dat$agecomp <- sensi_mod$dat$agecomp |>
  filter(fleet != 10)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '21_no_WCGBTS_ages'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/21_no_WCGBTS_ages")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots
# 

## 22) remove all fishery ages

sensi_mod <- base_model

sensi_mod$ctl$lambdas <- sensi_mod$ctl$lambdas |>
  bind_rows(data.frame(
    like_comp = 5,
    fleet = c(1,3,5,6),
    phase = 1,
    value = 0,
    sizefreq_method = 0
  ))

sensi_mod$ctl$N_lambdas <- nrow(sensi_mod$ctl$lambdas)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '22_no_fishery_ages'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/22_no_fishery_ages")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


## 23) remove all ages

sensi_mod <- base_model

sensi_mod$ctl$lambdas <- sensi_mod$ctl$lambdas |>
  bind_rows(data.frame(
    like_comp = 5,
    fleet = c(1,3,5,6,10),
    phase = 1,
    value = 0,
    sizefreq_method = 0
  ))

sensi_mod$ctl$N_lambdas <- nrow(sensi_mod$ctl$lambdas)

SS_write(
  sensi_mod,
  file.path(
    model_directory,
    'data_sensitivities',
    '23_no_ages'
  ),
  overwrite = TRUE
)

# setwd("C:/Github/REBS-2025/Document/report/Sensis/data_sensitivities/23_no_ages")
# shell("ss3 -nohess",wait = T) # no hessian
# mydir<-getwd()
# replist<-SS_output(mydir)
# SS_plots(replist) # creates the plots


# Run stuff ---------------------------------------------------------------

sensi_dirs <- c(
  list.files(
    file.path(
      model_directory,
      'data_sensitivities'
    ),
    full.names = TRUE
))

#tuning_mods <- grep('weighting', sensi_dirs)

future::plan(future::multisession(
  workers = parallelly::availableCores(omit = 1)
))

results <- future_map(
  sensi_dirs,
  ~ r4ss::run(
    dir = .x,
    exe = exe_loc,
    extras = '-nohess',
    skipfinished = FALSE
  )
)

future::plan(future::sequential)


# Plot stuff --------------------------------------------------------------

## function ----------------------------------------------------------------

make_detailed_sensitivites <- function(biglist, mods, outdir, grp_name) {
  shortlist <- big_sensitivity_output[c('base', mods$dir)] |>
    r4ss::SSsummarize()

  r4ss::SSplotComparisons(
    shortlist,
    subplots = c(2, 4),
    print = TRUE,
    plot = FALSE,
    plotdir = outdir,
    filenameprefix = grp_name,
    legendlabels = c('Base', mods$pretty),
    endyrvec = 2024
  )

  SStableComparisons(
    shortlist,
    modelnames = c('Base', mods$pretty),
    names = c(
      "Recr_Virgin",
      "R0",
      "NatM",
      "L_at_Amax",
      "VonBert_K",
      "SmryBio_unfished",
      "SSB_Virg",
      "SSB_2025",
      "Bratio_2025",
      "SPRratio_2024",
      "LnQ_base_WCGBTS"
    ),
    likenames = c(
      "TOTAL",
      "Survey",
      "Length_comp",
      "Age_comp",
      "Discard",
      "Mean_body_wt",
      "Recruitment",
      "priors"
    )
  ) |>
    # dplyr::filter(!(Label %in% c('NatM_break_1_Fem_GP_1',
    #                              'NatM_break_1_Mal_GP_1', 'NatM_break_2_Mal_GP_1')),
    #               Label != 'NatM_uniform_Mal_GP_1' | any(grep('break', Label)),
    #               Label != 'SR_BH_steep' | any(grep('break', Label))) |>
    # dplyr::mutate(dplyr::across(-Label, ~ sapply(., format, digits = 3, scientific = FALSE) |>
    #                               stringr::str_replace('NA', ''))) |>
    `names<-`(c('Label', 'Base', mods$pretty)) |>
    write.csv(
      file.path(outdir, paste0(grp_name, '_table.csv')),
      row.names = FALSE,
    )
}


## grouped plots -----------------------------------------------------------

indices <- data.frame(
  dir = c(
    'data_sensitivities/01_no_Triennial',
    'data_sensitivities/02_no_AK_slope',
    'data_sensitivities/03_no_NW_slope',
    'data_sensitivities/04_no_WCGBTS',
    'data_sensitivities/05_no_indices'
  ),
  pretty = c(
    '- Triennial',
    '- AK slope',
    '- NW slope',
    '- WCGBTS',
    'No indices'
  )
)

length_comps_fleet <- data.frame(
  dir = c(
    'data_sensitivities/06_no_BT_lengths',
    'data_sensitivities/07_no_NT_lengths',
    'data_sensitivities/08_no_MWT_lengths',
    'data_sensitivities/09_no_ASHOP_lengths',
    'data_sensitivities/10_no_Triennial_lengths',
    'data_sensitivities/11_no_AKslope_lengths',
    'data_sensitivities/12_no_NWslope_lengths',
    'data_sensitivities/13_no_WCGBTS_lengths'
  ),
  pretty = c(
    '- BT lengths',
    '- NT lengths',
    '- MWT lengths',
    '- AtSea Hake lengths',
    '- Triennial lengths',
    '- AK slope lengths',
    '- NW slope lengths',
    '- WCGBTS lengths'
  )
)

length_comps_disfleets <- data.frame(
  dir = c(
    'data_sensitivities/06_no_BT_lengths',
    'data_sensitivities/06a_no_BTonly_lengths',
    'data_sensitivities/06b_no_BTdis_lengths',
    'data_sensitivities/07_no_NT_lengths',
    'data_sensitivities/07a_no_NTonly_lengths',
    'data_sensitivities/07b_no_NTdis_lengths'
  ),
  pretty = c(
    '- BT + dis lengths',
    '- BT lengths',
    '- BT dis lengths',
    '- NT + dis lengths',
    '- NT lengths',
    '- NT dis lengths'
  )
)

length_comps_all <- data.frame(
  dir = c(
    'data_sensitivities/14_no_fishery_lengths',
    'data_sensitivities/15_no_survey_lengths',
    'data_sensitivities/16_no_lengths'
  ),
  pretty = c(
    '- no fishery lengths',
    '- no survey lengths',
    '- no lengths'
  )
)

age_comps <- data.frame(
  dir = c(
    'data_sensitivities/17_no_BT_ages',
    'data_sensitivities/18_no_NT_ages',
    'data_sensitivities/19_no_MWT_ages',
    'data_sensitivities/20_no_ASHOP_ages',
    'data_sensitivities/21_no_WCGBTS_ages',
    'data_sensitivities/22_no_fishery_ages',
    'data_sensitivities/23_no_ages'
  ),
  pretty = c(
    '- BT ages',
    '- NT ages',
    '- MWT ages',
    '- AtSea Hake ages',
    '- WCGBTS ages',
    '- fishery ages',
    '- no ages'
  )
)


sens_names <- bind_rows(indices, age_comps, length_comps_fleet, 
                        length_comps_disfleets,length_comps_all)

# redefine the model_directory to get correct spot
model_directory <- here::here(
  'models')

big_sensitivity_output <- SSgetoutput(
  dirvec = file.path(
    model_directory,
    c(
      "base_model",
      glue::glue("{subdir}", subdir = sens_names$dir)
    )
  )
) |>
  `names<-`(c('base', sens_names$dir))

big_sensitivity_output$base = base_out

# test to make sure they all read correctly:
which(sapply(big_sensitivity_output, length) < 180) # all lengths should be >180

sens_names_ls <- list(
  indices = indices,
  age_comps = age_comps,
  length_comps_fleet = length_comps_fleet,
  length_comps_disfleets = length_comps_disfleets,
  length_comps_all = length_comps_all
)

# outdir starts at here() - I think!
outdir <- here::here(
  'Document/report/Sensis/output')

purrr::imap(
  sens_names_ls,
  \(sens_df, grp_name)
    make_detailed_sensitivites(
      biglist = big_sensitivity_output,
      mods = sens_df,
      outdir = outdir,
      grp_name = grp_name
    )
)

## big plot ----------------------------------------------------------------

current.year <- 2025
CI <- 0.95

sensitivity_output <- SSsummarize(big_sensitivity_output)

lapply(
  big_sensitivity_output,
  function(.) .$warnings[grep('gradient', .$warnings)]
) # check gradients

dev.quants.SD <- c(
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == "SSB_Initial",
    1
  ],
  (sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == paste0("SSB_", current.year),
    1
  ]),
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == paste0("Bratio_", current.year),
    1
  ],
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == "Dead_Catch_SPR",
    1
  ],
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == "annF_SPR",
    1
  ]
)

dev.quants <- rbind(
  sensitivity_output$quants[
    sensitivity_output$quants$Label == "SSB_Initial",
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == paste0("SSB_", current.year),
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == paste0("Bratio_", current.year),
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == "Dead_Catch_SPR",
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == "annF_SPR",
    1:(dim(sensitivity_output$quants)[2] - 2)
  ]
) |>
  cbind(baseSD = dev.quants.SD) |>
  dplyr::mutate(
    Metric = c(
      "SB0",
      paste0("SSB_", current.year),
      paste0("Bratio_", current.year),
      "MSY_SPR",
      "F_SPR"
    )
  ) |>
  tidyr::pivot_longer(
    -c(base, Metric, baseSD),
    names_to = 'Model',
    values_to = 'Est'
  ) |>
  dplyr::mutate(
    relErr = (Est - base) / base,
    logRelErr = log(Est / base),
    mod_num = rep(1:nrow(sens_names), 5)
  )

metric.labs <- c(
  SB0 = expression(SB[0]),
  SSB_2023 = as.expression(bquote("SB"[.(current.year)])),
  Bratio_2023 = bquote(frac(SB[.(current.year)], SB[0])),
  MSY_SPR = expression(Yield['SPR=0.50']),
  F_SPR = expression(F['SPR=0.50'])
)

CI.quants <- dev.quants |>
  dplyr::filter(Model == unique(dev.quants$Model)[1]) |>
  dplyr::select(base, baseSD, Metric) |>
  dplyr::mutate(CI = qnorm((1 - CI) / 2, 0, baseSD) / base)

ggplot(dev.quants, aes(x = relErr, y = mod_num, col = Metric, pch = Metric)) +
  geom_vline(xintercept = 0, linetype = 'dotted') +
  geom_point() +
  geom_segment(
    aes(
      x = CI,
      xend = abs(CI),
      col = Metric,
      y = nrow(sens_names) +
        1.5 +
        seq(-0.5, 0.5, length.out = length(metric.labs)),
      yend = nrow(sens_names) +
        1.5 +
        seq(-0.5, 0.5, length.out = length(metric.labs))
    ),
    data = CI.quants,
    linewidth = 2,
    show.legend = FALSE,
    lineend = 'round'
  ) +
  theme_bw() +
  scale_shape_manual(
    values = c(15:18, 12),
    # name = "",
    labels = metric.labs
  ) +
  scale_y_continuous(
    breaks = 1:nrow(sens_names),
    name = '',
    labels = sens_names$pretty,
    limits = c(1, nrow(sens_names) + 2),
    minor_breaks = NULL
  ) +
  xlab("Relative change") +
  viridis::scale_color_viridis(discrete = TRUE, labels = metric.labs)
ggsave(
  file.path(outdir, 'sens_summary.png'),
  dpi = 300,
  width = 6,
  height = 6.5,
  units = "in"
)


##
## big plot with out no length comps model ----------------------------------

current.year <- 2025
CI <- 0.95

sensitivity_output <- SSsummarize(
  big_sensitivity_output[!names(big_sensitivity_output) %in% "index_and_comp_data/22_no_length_comps"]
)

#length_comps_2_clean <- length_comps_2[length_comps_2$dir != "index_and_comp_data/22_no_length_comps", ]

sens_names <- bind_rows(modeling, indices, age_comps, length_comps_1, length_comps_2_clean)


lapply(
  big_sensitivity_output,
  function(.) .$warnings[grep('gradient', .$warnings)]
) # check gradients

dev.quants.SD <- c(
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == "SSB_Initial",
    1
  ],
  (sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == paste0("SSB_", current.year),
    1
  ]),
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == paste0("Bratio_", current.year),
    1
  ],
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == "Dead_Catch_SPR",
    1
  ],
  sensitivity_output$quantsSD[
    sensitivity_output$quantsSD$Label == "annF_SPR",
    1
  ]
)

dev.quants <- rbind(
  sensitivity_output$quants[
    sensitivity_output$quants$Label == "SSB_Initial",
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == paste0("SSB_", current.year),
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == paste0("Bratio_", current.year),
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == "Dead_Catch_SPR",
    1:(dim(sensitivity_output$quants)[2] - 2)
  ],
  sensitivity_output$quants[
    sensitivity_output$quants$Label == "annF_SPR",
    1:(dim(sensitivity_output$quants)[2] - 2)
  ]
) |>
  cbind(baseSD = dev.quants.SD) |>
  dplyr::mutate(
    Metric = c(
      "SB0",
      paste0("SSB_", current.year),
      paste0("Bratio_", current.year),
      "MSY_SPR",
      "F_SPR"
    )
  ) |>
  tidyr::pivot_longer(
    -c(base, Metric, baseSD),
    names_to = 'Model',
    values_to = 'Est'
  ) |>
  dplyr::mutate(
    relErr = (Est - base) / base,
    logRelErr = log(Est / base),
    mod_num = rep(1:nrow(sens_names[]), 5)
  )

metric.labs <- c(
  SB0 = expression(SB[0]),
  SSB_2023 = as.expression(bquote("SB"[.(current.year)])),
  Bratio_2023 = bquote(frac(SB[.(current.year)], SB[0])),
  MSY_SPR = expression(Yield['SPR=0.50']),
  F_SPR = expression(F['SPR=0.50'])
)

CI.quants <- dev.quants |>
  dplyr::filter(Model == unique(dev.quants$Model)[1]) |>
  dplyr::select(base, baseSD, Metric) |>
  dplyr::mutate(CI = qnorm((1 - CI) / 2, 0, baseSD) / base)

ggplot(dev.quants, aes(x = relErr, y = mod_num, col = Metric, pch = Metric)) +
  geom_vline(xintercept = 0, linetype = 'dotted') +
  geom_point() +
  geom_segment(
    aes(
      x = CI,
      xend = abs(CI),
      col = Metric,
      y = nrow(sens_names) +
        1.5 +
        seq(-0.5, 0.5, length.out = length(metric.labs)),
      yend = nrow(sens_names) +
        1.5 +
        seq(-0.5, 0.5, length.out = length(metric.labs))
    ),
    data = CI.quants,
    linewidth = 2,
    show.legend = FALSE,
    lineend = 'round'
  ) +
  theme_bw() +
  scale_shape_manual(
    values = c(15:18, 12),
    # name = "",
    labels = metric.labs
  ) +
  scale_y_continuous(
    breaks = 1:nrow(sens_names),
    name = '',
    labels = sens_names$pretty,
    limits = c(1, nrow(sens_names) + 2),
    minor_breaks = NULL
  ) +
  xlab("Relative change") +
  viridis::scale_color_viridis(discrete = TRUE, labels = metric.labs)
ggsave(
  file.path(outdir, 'sens_summary_with_no_length_comps.png'),
  dpi = 300,
  width = 6,
  height = 6.5,
  units = "in"
)

