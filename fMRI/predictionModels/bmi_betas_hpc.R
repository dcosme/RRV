# load packages
library(tidyverse)

# source data
source("load_data.R")

# standardize
betas_std = betas %>%
  group_by(roi, session) %>%
  mutate(meanPE_std = scale(meanPE, center = TRUE, scale = TRUE),
         meanPE_std = ifelse(meanPE_std > 3, 3,
                      ifelse(meanPE_std < -3, -3, meanPE_std))) %>%
  ungroup()

# SCA
## tidy data
betas_sca = betas_std %>%
  group_by(subjectID, process, condition, control) %>%
  mutate(meanProcessPEstd = mean(meanPE_std, na.rm = TRUE)) %>%
  select(-c(con, xyz, roi, meanPE, sdPE, meanPE_std)) %>%
  unique() %>%
  spread(process, meanProcessPEstd) %>%
  mutate(balance = cognitive_control - reward) %>%
  gather(process, meanProcessPEstd, cognitive_control, reward, value, balance) %>%
  unite(variable, process, condition, control, sep = "_", remove = TRUE) %>%
  mutate(variable = sprintf("univariate_%s", variable)) %>%
  filter(session == "all") %>%
  select(-c(session)) %>%
  left_join(., ind_diffs) %>%
  select(-c(sample, DBIC_ID, age, gender))

betas_sca_bmi = betas_sca %>%
  filter(grepl("snack|meal|dessert|food", variable)) %>%
  unique() %>%
  select(-fat) %>%
  spread(variable, meanProcessPEstd) %>%
  ungroup() %>%
  na.omit()

# set na.action for dredge
options(na.action = "na.fail")

# specify number of cores
n_cores = 28

# betas > rest
if (file.exists("bmi_betas_rest_sca.RDS")) {
  betas_rest_sca = readRDS("bmi_betas_rest_sca.RDS")
} else {
  data = betas_sca_bmi %>%
    select_if(grepl("subjectID|bmi|rest", names(.)))
  lm_predictors = paste(names(select(data, -c(subjectID, bmi))), collapse = " + ")
  lm_formula = formula(paste0("bmi ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  betas_rest_sca = MuMIn::dredge(full_model, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(betas_rest_sca, "bmi_betas_rest_sca.RDS")
}

# betas > nature
if (file.exists("bmi_betas_nature_sca.RDS")) {
  betas_nature_sca = readRDS("bmi_betas_nature_sca.RDS")
} else {
  data = betas_sca_bmi %>%
    select_if(grepl("subjectID|bmi|nature", names(.)))
  lm_predictors = paste(names(select(data, -c(subjectID, bmi))), collapse = " + ")
  lm_formula = formula(paste0("bmi ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  betas_nature_sca = MuMIn::dredge(full_model, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(betas_nature_sca, "bmi_betas_nature_sca.RDS")
}
