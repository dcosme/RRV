# load packages
library(tidyverse)

# source data
source("load_data.R")

# standardize
dots_std = dots %>%
  group_by(map, test, mask, session) %>%
  mutate(dotProduct_std = scale(dotProduct, center = TRUE, scale = TRUE),
         dotProduct_std = ifelse(dotProduct_std > 3, 3,
                          ifelse(dotProduct_std < -3, -3, dotProduct_std))) %>%
  ungroup()

# SCA
## tidy data
dots_sca = dots_std %>%
  filter((!grepl("neuralsig", map) &  mask == "masked") | (grepl("neuralsig", map) & mask == "unmasked")) %>%
  unite(variable, process, test, condition, control, sep = "_", remove = TRUE) %>%
  mutate(variable = sprintf("multivariate_%s", variable)) %>%
  filter(session == "all") %>%
  select(-c(map, con, mask, session, dotProduct)) %>%
  left_join(., ind_diffs) %>%
  select(-c(sample, DBIC_ID, age, gender))

dots_sca_fat = dots_sca %>%
  filter(grepl("snack|meal|dessert|food", variable)) %>%
  unique() %>%
  select(-bmi) %>%
  spread(variable, dotProduct_std) %>%
  ungroup() %>%
  na.omit()

# set na.action for dredge
options(na.action = "na.fail")

# specify number of cores
n_cores = 28

# dots association > rest
if (file.exists("fat_dots_rest_assoc_sca.RDS")) {
  dots_rest_assoc_sca = readRDS("fat_dots_rest_assoc_sca.RDS")
} else {
  data = dots_sca_fat %>%
    select_if(grepl("subjectID|fat|association", names(.))) %>%
    select_if(grepl("subjectID|fat|rest", names(.)))
  lm_predictors = paste(names(select(data, -c(subjectID, fat))), collapse = " + ")
  lm_formula = formula(paste0("fat ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_rest_assoc_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_rest_assoc_sca, "fat_dots_rest_assoc_sca.RDS")
}

# dots uniformity > rest
if (file.exists("fat_dots_rest_uniform_sca.RDS")) {
  dots_rest_uniform_sca = readRDS("fat_dots_rest_uniform_sca.RDS")
} else {
  data = dots_sca_fat %>%
    select_if(grepl("subjectID|fat|uniformity", names(.))) %>%
    select_if(grepl("subjectID|fat|rest", names(.)))
  lm_predictors = paste(names(select(data, -c(subjectID, fat))), collapse = " + ")
  lm_formula = formula(paste0("fat ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_rest_uniform_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_rest_uniform_sca, "fat_dots_rest_uniform_sca.RDS")
}

# dots association > nature
if (file.exists("fat_dots_nature_assoc_sca.RDS")) {
  dots_nature_assoc_sca = readRDS("fat_dots_nature_assoc_sca.RDS")
} else {
  data = dots_sca_fat %>%
    select_if(grepl("subjectID|fat|association", names(.))) %>%
    select_if(grepl("subjectID|fat|nature", names(.)))
  lm_predictors = paste(names(select(data, -c(subjectID, fat))), collapse = " + ")
  lm_formula = formula(paste0("fat ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_nature_assoc_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_nature_assoc_sca, "fat_dots_nature_assoc_sca.RDS")
}

# dots uniformity > nature
if (file.exists("fat_dots_nature_uniform_sca.RDS")) {
  dots_nature_uniform_sca = readRDS("fat_dots_nature_uniform_sca.RDS")
} else {
  data = dots_sca_fat %>%
    select_if(grepl("subjectID|fat|uniformity", names(.))) %>%
    select_if(grepl("subjectID|fat|nature", names(.)))
  lm_predictors = paste(names(select(data, -c(subjectID, fat))), collapse = " + ")
  lm_formula = formula(paste0("fat ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_nature_uniform_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_nature_uniform_sca, "fat_dots_nature_uniform_sca.RDS")
}
