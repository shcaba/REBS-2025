library(here)
library(r4ss)
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

prev_model_df_bt_discard <- prev_model_df %>%
  dplyr::filter(typename == "discard" & fleetnames == "BOTTOM_TRAWL")

prev_model_df <- prev_model_df %>%
  dplyr::filter(!(typename == "discard" & fleetnames == "BOTTOM_TRAWL"))

prev_model_df_bt_discard$typename <- "catch"
prev_model_df_bt_discard$fleetnames <- "BOTTOM_TRAWL_DISCARD"

prev_model_df <- rbind(prev_model_df, prev_model_df_bt_discard)

prev_model_df_nt_discard <- prev_model_df %>%
  dplyr::filter(typename == "discard" & fleetnames == "NON_TRAWL")

prev_model_df <- prev_model_df %>%
  dplyr::filter(!(typename == "discard" & fleetnames == "NON_TRAWL"))

prev_model_df_nt_discard$typename <- "catch"
prev_model_df_nt_discard$fleetnames <- "NON_TRAWL_DISCARD"

prev_model_df <- rbind(prev_model_df, prev_model_df_nt_discard)


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

facet_labels <- c(
  catch = "Catch",
  cpue = "Indices",
  lendbase = "Lengths",
  condbase = "Ages"
)

labels_use <- both_models %>%
  distinct(fleet_source, fleetnames) %>%
  tibble::deframe()  

ggplot(both_models, aes(
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



ggplot(both_models, aes(
  x = yr,
  y = fleetnames,
  color = source,
  size = size
)) +
  geom_point(alpha = 0.7) +
  facet_grid(typename ~ ., scales = "free_y", space = "free_y") +
  scale_color_manual(
    values = c("ref" = "blue", "prev" = "orange"),
    name = "Data Source"
  ) +
  scale_size(range = c(1, 6)) +
  guides(size = "none") +  # Hide size legend
  labs(
    x = "Year",
    y = "Fleet",
 #   title = "Comparison of Data by Fleet, Type, and Model"
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






ggplot(both_models, aes(
  x = yr,
  y = y_group,
  color = source,
  size = size
)) +
  geom_point(alpha = 0.7) +
  scale_color_manual(
    values = c("ref" = "blue", "prev" = "orange"),
    name = "Data Source"
  ) +
  scale_size(range = c(1, 6)) +
  guides(size = "none") +
  labs(
    x = "Year",
    y = NULL,
 #   title = "Comparison of Data by Fleet, Type, and Model"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 5),
    axis.text.x = element_text(size = 6),
    legend.text = element_text(size = 6),
 #   legend.title = element_text(size = 7),
    legend.position = "bottom"
  )






ggplot(both_models, aes(
  x = yr,
  y = factor(fleet_type_source),
  color = source,
  size = size
)) +
  geom_point(alpha = 0.7) +
  scale_size(range = c(1, 6)) +
  scale_color_manual(values = c("ref" = "blue", "prev" = "orange")) +
  labs(
    x = "Year",
    y = "Fleet & Data Type",
    color = "Data Source"
  #  size = "Relative Size",
#    title = "Comparison of Data Sources by Fleet, Type, and Year"
  ) +
  guides(size = "none") + 
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 6),
    axis.text.x = element_text(size = 6),
    legend.text = element_text(size = 6),
    strip.text = element_text(size = 6),
  #  plot.title = element_text(size = 8),
    axis.title = element_text(size = 7),
  legend.position = "bottom"
  )







ggplot(both_models, aes(
  x = yr,
  y = factor(fleetnames),
  color = source,
  size = size
)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~ typename, scales = "free_y") +
  scale_size(range = c(1, 6)) +
  labs(
    x = "Year",
    y = "Fleet",
    color = "Data Source",
    size = "Relative Size",
    title = "Comparison of Data Sources by Fleet, Type, and Year"
  ) +
  theme_minimal() +
  theme(strip.text = element_text(face = "bold"))



plotdata <- function(datasize) {
  par(mar = margins)
  
  xlim <- c(-1, 1) + range(typetable2[["yr"]], na.rm = TRUE)
  yval <- 0
  
  # color for source only
  source_colors <- c(a = "blue", b = "orange")
  
  ymax <- nrow(unique(typetable2[, c("fleet", "itype", "source")]))
  main.temp <- ""
  if (mainTitle) {
    main.temp <- if (datasize) {
      "Data by type and year, circle area is relative to precision within data type"
    } else {
      "Data by type and year"
    }
  }
  
  plot(
    0,
    xlim = xlim,
    ylim = c(0, ymax + 2 * ntypes + .5),
    axes = FALSE,
    xaxs = "i",
    yaxs = "i",
    type = "n",
    xlab = "Year",
    ylab = "",
    main = main.temp,
    cex.main = cex.main
  )
  
  xticks <- 5 * round(xlim[1]:xlim[2] / 5)
  abline(v = xticks, col = "grey", lty = 3)
  
  axistable <- data.frame(fleet = rep(NA, ymax), yval = NA, source = NA)
  itick <- 1
  
  for (itype in rev(unique(typetable2[["itype"]]))) {
    size.max <- max(typetable2[["size"]][typetable2[["itype"]] == itype], na.rm = TRUE)
    if (size.max > 0) {
      typetable2[["size"]][typetable2[["itype"]] == itype] <-
        typetable2[["size"]][typetable2[["itype"]] == itype] / size.max
    } else {
      typetable2[["size"]][typetable2[["itype"]] == itype] <- 0
    }
    
    typename <- unique(typetable2[["typename"]][typetable2[["itype"]] == itype])
    type.fleets <- unique(typetable2[typetable2$itype == itype, c("fleet", "source")])
    type.fleets <- type.fleets[order(type.fleets$fleet, type.fleets$source), ]
    
    for (i in seq_len(nrow(type.fleets))) {
      ifleet <- type.fleets$fleet[i]
      isource <- type.fleets$source[i]
      
      subset_idx <- typetable2$fleet == ifleet & typetable2$itype == itype & typetable2$source == isource
      yrs <- typetable2$yr[subset_idx]
      
      if (length(yrs) > 0) {
        col <- source_colors[isource]
        size.cex <- typetable2$size[subset_idx]
        
        yval <- yval + 1
        x <- min(yrs):max(yrs)
        n <- length(x)
        y <- rep(yval, n)
        y[!x %in% yrs] <- NA
        
        # identify solo points
        solo <- rep(FALSE, n)
        if (n == 1) solo <- 1
        if (n == 2 & yrs[2] != yrs[1] + 1) solo <- rep(TRUE, 2)
        if (n >= 3) {
          for (j in 2:(n - 1)) {
            if (is.na(y[j - 1]) & is.na(y[j + 1])) solo[j] <- TRUE
          }
          if (is.na(y[2])) solo[1] <- TRUE
          if (is.na(y[n - 1])) solo[n] <- TRUE
        }
        
        if (!datasize) {
          points(x[solo], y[solo], pch = 16, cex = cex, col = col)
          lines(x, y, lwd = lwd, col = col)
        } else {
          x <- x[!is.na(y)]
          y <- y[!is.na(y)]
          symbols(
            x = x,
            y = y,
            circles = sqrt(size.cex) * maxsize,
            bg = adjustcolor(col, alpha.f = alphasize),
            add = TRUE,
            inches = FALSE
          )
        }
        
        axistable[itick, ] <- c(ifleet, yval, isource)
        itick <- itick + 1
      }
    }
    
    yval <- yval + 2
    if (itype != 1) {
      abline(h = yval + .3, col = "grey", lty = 3)
    }
    text(mean(xlim), yval - .3, typelabels[typenames == typename], font = 2)
  }
  
  axistable$label <- paste0(fleetnames[axistable$fleet], " (", axistable$source, ")")
  
  axis(
    4,
    at = axistable$yval,
    labels = axistable$label,
    las = 1
  )
  axis(1, at = xticks)
  box()
}



plotdata(both_models)
















r4ss::SSplotData(
  replist = replist_2025,
  plot = !png,
  print = png,
  pwidth = pwidth,
  pheight = pheight_tall,
  punits = punits,
  ptsize = ptsize,
  res = res,
  mainTitle = mainTitle,
  cex.main = cex.main,
  plotdir = here::here('Rcode','SSplotComparisions_output','data_comparisons'),
  margins = c(5.1, 2.1, 4.1, SSplotDatMargin),
  fleetnames = "default",
  fleetcol = "default", # mismatch in names between functions
  maxsize = maxsize
)























r4ss::SSplotData(replist, plotdir = here::here('Rcode','SSplotComparisions_output','data_comparisons'))

# get quantities from the big list
nfleets <- replist$dat$Nfleets
nfishfleets <- replist[["nfishfleets"]]
nareas <- dat$N_areas
nseasons <- dat$nseas 
timeseries <- replist[["timeseries"]]
lbins <- replist[["lbins"]]
inputs <- replist[["inputs"]]
endyr <- replist[["endyr"]]
SS_version <- replist[["SS_version"]]
SS_versionNumeric <- replist[["SS_versionNumeric"]]
StartTime <- replist[["StartTime"]]
Files_used <- replist[["Files_used"]]
FleetNames <- replist[["FleetNames"]]
rmse_table <- replist[["rmse_table"]]
comp_data_exists <- replist[["comp_data_exists"]]



r4ss::SSplotData(
  replist = replist_2025,
  plot = !png,
  print = png,
  pwidth = pwidth,
  pheight = pheight_tall,
  punits = punits,
  ptsize = ptsize,
  res = res,
  mainTitle = mainTitle,
  cex.main = cex.main,
  plotdir = here::here('Rcode','SSplotComparisions_output','data_comparisons'),
  margins = c(5.1, 2.1, 4.1, SSplotDatMargin),
  fleetnames = "default",
  fleetcol = "default", # mismatch in names between functions
  maxsize = maxsize
)


S
