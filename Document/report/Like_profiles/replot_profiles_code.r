plot_profile <- function(mydir, rep, para, profilesummary) {
  label <- ifelse(para == "SR_LN(R0)", expression(log(italic(R)[0])),
    ifelse(para %in% c("NatM_p_1_Fem_GP_1", "NatM_uniform_Fem_GP_1", "NatM_break_1_Fem_GP_1"), "Natural Mortality (female)",
      ifelse(para %in% c("NatM_p_1_Mal_GP_1", "NatM_uniform_Mal_GP_1", "NatM_break_1_Mal_GP_1"), "Natural Mortality (male)",
        ifelse(para == "SR_BH_steep", expression(Steepness ~ (italic(h))),
          para
        )
      )
    )
  )

  get <- ifelse(para == "SR_LN(R0)", "R0", para)

  if (para %in% c(
    "SR_LN(R0)", "NatM_p_1_Fem_GP_1", "NatM_p_1_Mal_GP_1", "NatM_break_1_Mal_GP_1",
    "NatM_break_1_Fem_GP_1", "NatM_uniform_Fem_GP_1", "NatM_uniform_Mal_GP_1", "SR_BH_steep"
  )) {
    exact <- FALSE
  } else {
    exact <- TRUE
  }

  n <- 1:profilesummary[["n"]]

  like_comp <- unique(profilesummary[["likelihoods_by_fleet"]][["Label"]][
    c(
      -grep("_lambda", profilesummary[["likelihoods_by_fleet"]][["Label"]]),
      -grep("_N_use", profilesummary[["likelihoods_by_fleet"]][["Label"]]),
      -grep("_N_skip", profilesummary[["likelihoods_by_fleet"]][["Label"]])
    )
  ])
  ii <- which(profilesummary[["likelihoods_by_fleet"]][["Label"]] %in% like_comp)
  check <- stats::aggregate(ALL ~ Label, profilesummary[["likelihoods_by_fleet"]][ii, ], FUN = sum)
  use <- check[which(check$ALL != 0), "Label"]
  # If present remove the likes that we don't typically show
  use <- use[which(!use %in% c("Disc_like", "Catch_like", "mnwt_like"))]

  tot_plot <- length(use)
  if (tot_plot == 1) {
    panel <- c(2, 1)
  }
  #if (tot_plot != 1 & tot_plot <= 3) {
  #  panel <- c(3, 1)
  #}
  if (tot_plot >= 2) {
    panel <- c(2, 2)
  }
  if (tot_plot >= 4) {
    panel <- c(3, 2)
  }

  # Determine the y-axis for the profile plot for all data types together
  ymax1 <- max(profilesummary[["likelihoods"]][1, n]) - min(profilesummary[["likelihoods"]][1, n])
  if (ymax1 > 70) {
    ymax1 <- 70
  }
  if (ymax1 < 5) {
    ymax1 <- 5
  }

  # Determine the y-axis for the piner profile plots by each data type
  lab.row <- ncol(profilesummary[["likelihoods"]])
  ymax2 <- max(apply(profilesummary[["likelihoods"]][-1, -lab.row], 1, max) -
    apply(profilesummary[["likelihoods"]][-1, -lab.row], 1, min))
  if (ymax2 > 70) {
    ymax2 <- 70
  }
  if (ymax2 < 5) {
    ymax2 <- 5
  }

  adj_size <- ifelse(length(profilesummary$FleetNames[[1]]) < 6, 7, 10)
  pngfun(wd = mydir, file = paste0("piner_panel_", para, ".png"), h = adj_size, w = adj_size)
  on.exit(grDevices::dev.off(), add = TRUE)
  graphics::par(mfrow = panel)
  r4ss::SSplotProfile(
    summaryoutput = profilesummary,
    main = "Changes in total likelihood",
    profile.string = get,
    profile.label = label,
    ymax = ymax1,
    exact = exact
  )
  graphics::abline(h = 1.92, lty = 3, col = "red")

  if ("Length_like" %in% use) {
    r4ss::PinerPlot(
      summaryoutput = profilesummary,
      plot = TRUE,
      print = FALSE,
      component = "Length_like",
      main = "Length-composition likelihoods",
      profile.string = get,
      profile.label = label,
      exact = exact,
      ylab = "Change in -log-likelihood",
      legendloc = "topright",
      ymax = ymax2
    )
  }

  if ("Age_like" %in% use) {
    r4ss::PinerPlot(
      summaryoutput = profilesummary,
      plot = TRUE,
      print = FALSE,
      component = "Age_like",
      main = "Age-composition likelihoods",
      profile.string = get,
      profile.label = label,
      exact = exact,
      ylab = "Change in -log-likelihood",
      legendloc = "topright",
      ymax = ymax2
    )
  }

  if ("Surv_like" %in% use) {
    r4ss::PinerPlot(
      summaryoutput = profilesummary,
      plot = TRUE,
      print = FALSE,
      component = "Surv_like",
      main = "Survey likelihoods",
      profile.string = get,
      profile.label = label,
      exact = exact,
      ylab = "Change in -log-likelihood",
      legendloc = "topright",
      ymax = ymax2
    )
  }

  if ("Init_equ_like" %in% use) {
    r4ss::PinerPlot(
      summaryoutput = profilesummary,
      plot = TRUE,
      print = FALSE,
      component = "Init_equ_like",
      main = "Initial equilibrium likelihoods",
      profile.string = get,
      profile.label = label,
      exact = exact,
      ylab = "Change in -log-likelihood",
      legendloc = "topright",
      ymax = ymax2
    )
  }

  maxyr <- min(profilesummary[["endyrs"]] + 1)
  minyr <- max(profilesummary[["startyrs"]])
  est <- rep[["parameters"]][rep[["parameters"]][["Label"]] == para, "Value", 2]
  sb0_est <- rep[["derived_quants"]][rep[["derived_quants"]][["Label"]] == "SSB_Virgin", "Value"]
  sbf_est <- rep[["derived_quants"]][rep[["derived_quants"]][["Label"]] == paste0("SSB_", maxyr), "Value"]
  depl_est <- rep[["derived_quants"]][rep[["derived_quants"]][["Label"]] == paste0("Bratio_", maxyr), "Value"]

  x <- as.numeric(profilesummary[["pars"]][profilesummary[["pars"]][["Label"]] == para, n])
  # determine whether to include the prior likelihood component in the likelihood profile
  starter <- r4ss::SS_readstarter(file = file.path(mydir, "starter.ss"))
  like <- as.numeric(profilesummary[["likelihoods"]][profilesummary[["likelihoods"]][["Label"]] == "TOTAL", n] -
    ifelse(starter[["prior_like"]] == 0,
      profilesummary[["likelihoods"]][profilesummary[["likelihoods"]][["Label"]] == "Parm_priors", n],
      0
    ) -
    rep[["likelihoods_used"]][1, 1])

  ylike <- c(min(like) + ifelse(min(like) != 0, -0.5, 0), max(like))
  sb0 <- as.numeric(profilesummary[["SpawnBio"]][stats::na.omit(profilesummary[["SpawnBio"]][["Label"]]) == "SSB_Virgin", n])
  sbf <- as.numeric(profilesummary[["SpawnBio"]][stats::na.omit(profilesummary[["SpawnBio"]][["Yr"]]) == maxyr, n])
  depl <- as.numeric(profilesummary[["Bratio"]][stats::na.omit(profilesummary[["Bratio"]][["Yr"]]) == maxyr, n])

  # Get the relative management targets - only grab the first element since the targets should be the same
  btarg <- as.numeric(profilesummary[["btargs"]][1])
  thresh <- as.numeric(profilesummary[["minbthreshs"]][1])

  pngfun(wd = mydir, file = paste0("parameter_panel_", para, ".png"), h = 7, w = 7)
  #on.exit(grDevices::dev.off(), add = TRUE)
  graphics::par(mfrow = c(2, 2), mar = c(4, 4, 2, 2), oma = c(1, 1, 1, 1))
  # parameter vs. likelihood
  plot(x, like, type = "l", lwd = 2, xlab = label, ylab = "Change in -log-likelihood", ylim = ylike)
  graphics::abline(h = 0, lty = 2, col = "black")
  if (max(ylike) < 40) {
    graphics::abline(h = 1.92, lty = 3, col = "red")
    graphics::abline(h = -1.92, lty = 3, col = "red")
  }
  graphics::points(est, 0, pch = 21, col = "black", bg = "blue", cex = 1.5)

  # parameter vs. final depletion
  plot(x, depl, type = "l", lwd = 2, xlab = label, ylab = expression("Fraction Unfished"[final]), ylim = c(0, 1.2))
  points(est, depl_est, pch = 21, col = "black", bg = "blue", cex = 1.5)
  abline(h = c(btarg, thresh), lty = c(2, 2), col = c("darkgreen", "red"))
  if (btarg > 0) {
    graphics::legend("bottomright",
      legend = c("Management target", "Minimum stock size threshold"),
      lty = 2, col = c("darkgreen", "red"), bty = "n"
    )
  }

  # parameter vs. SB0
  plot(x, sb0,
    type = "l", lwd = 2, xlab = label,
    ylab = ifelse(profilesummary[["SpawnOutputUnits"]][1] == "biomass",
      expression(SB[0]), expression(SO[0])
    ), ylim = c(0, max(sb0))
  )
  points(est, sb0_est, pch = 21, col = "black", bg = "blue", cex = 1.5)

  # parameter vs. SBfinal
  plot(x, sbf,
    type = "l", lwd = 2, xlab = label,
    ylab = ifelse(profilesummary[["SpawnOutputUnits"]][1] == "biomass",
      expression(SB[final]), expression(SO[final])
    ), ylim = c(0, max(sbf))
  )
  points(est, sbf_est, pch = 21, col = "black", bg = "blue", cex = 1.5)
dev.off()
  # Create the sb and depl trajectories plot
  # Figure out what the base model parameter is in order to label that in the plot
  get <- dplyr::case_when(
    para == "SR_LN(R0)" ~ "log(R0)",
    para %in% c("NatM_uniform_Fem_GP_1", "NatM_p_1_Fem_GP_1", "NatM_break_1_Fem_GP_1") ~ "M (f)",
    para %in% c("NatM_uniform_Mal_GP_1", "NatM_p_1_Mal_GP_1", "NatM_break_1_Mal_GP_1") ~ "M (m)",
    para == "SR_BH_steep" ~ "h",
    .default = para
  )

  r4ss::SSplotComparisons(
    summaryoutput = profilesummary,
    legendlabels = sprintf(
      fmt = "%s = %s%s",
      # Paste the following three strings together element wise
      # using the above format of string1 = string2string3
      get,
      pretty_decimal(x),
      ifelse(est == x, " (base)", "")
    ),
    ylimAdj = 1.15,
    btarg = btarg,
    minbthresh = thresh,
    plotdir = mydir,
    subplots = profilesummary[["subplots"]],
    pdf = FALSE, print = TRUE, plot = FALSE,
    filenameprefix = paste0(para, "_trajectories_")
  )
}


 plot_profile("C:\\Users\\Jason.Cope\\Documents\\Current Action\\Assessments\\Rougheye_blackspotted_2025\\Sensitivities\\Profiles\\RB_ref_model_updated_profile_SR_LN(R0)",rep,para,profilesummary)

plot_profile("C:\\Users\\Jason.Cope\\Documents\\Current Action\\Assessments\\Rougheye_blackspotted_2025\\Sensitivities\\Profiles\\Ref_model_STAR-3_R0515_profile_SR_LN(R0)",rep,para,profilesummary)
 