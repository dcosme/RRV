# load packages
library(tidyverse)

# source data
source("load_data.R")

# standardize
betas_std = betas %>%
  group_by(roi, session) %>%
  mutate(meanPE_std = scale(meanPE, center = TRUE, scale = TRUE),
         meanPE_std = ifelse(meanPE_std > 3 | meanPE_std < -3, NA, meanPE_std)) %>%
  ungroup()

dots_std = dots %>%
  group_by(map, test, mask, session) %>%
  mutate(dotProduct_std = scale(dotProduct, center = TRUE, scale = TRUE),
         dotProduct_std = ifelse(dotProduct_std > 3 | dotProduct_std < -3, NA, dotProduct_std)) %>%
  ungroup()

# join data frames
dataset = full_join(betas_std, dots_std, by = c("subjectID", "con", "process", "condition", "control", "session")) %>%
  mutate(subjectID = as.character(subjectID)) %>%
  left_join(., ind_diffs, by = "subjectID") %>%
  ungroup() %>%
  mutate(subjectID = as.factor(subjectID),
         condition = as.factor(condition),
         control = as.factor(control),
         roi = as.factor(roi),
         process = as.factor(process),
         test = as.factor(test))

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

betas_rest = betas_sca %>%
  filter(grepl("rest", variable) & grepl("snack|meal|dessert|food", variable)) %>%
  unique() %>%
  spread(variable, meanProcessPEstd) %>%
  ungroup()

betas_nature = betas_sca %>%
  filter(grepl("nature", variable) & grepl("snack|meal|dessert|food", variable)) %>%
  unique() %>%
  spread(variable, meanProcessPEstd) %>%
  ungroup()

# set na.action for dredge
options(na.action = "na.fail")

# specify number of cores
n_cores = 28

# betas > rest
if (file.exists("fat_betas_rest_sca.RDS")) {
  betas_rest_sca = readRDS("fat_betas_rest_sca.RDS")
} else {
  data = betas_rest %>%
    select(-bmi) %>%
    na.omit()
  lm_predictors = paste(names(select(betas_rest, -c(subjectID, bmi, fat))), collapse = " + ")
  lm_formula = formula(paste0("fat ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  betas_rest_sca = MuMIn::dredge(full_model, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(betas_rest_sca, "fat_betas_rest_sca.RDS")
}

# betas > nature
if (file.exists("fat_betas_nature_sca.RDS")) {
  betas_nature_sca = readRDS("fat_betas_nature_sca.RDS")
} else {
  data = betas_nature %>%
    select(-bmi) %>%
    na.omit()
  lm_predictors = paste(names(select(betas_nature, -c(subjectID, bmi, fat))), collapse = " + ")
  lm_formula = formula(paste0("fat ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  betas_nature_sca = MuMIn::dredge(full_model, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(betas_nature_sca, "fat_betas_nature_sca.RDS")
}
