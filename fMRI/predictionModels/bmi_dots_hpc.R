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
dots_sca = dots_std %>%
  filter((!grepl("neuralsig", map) &  mask == "masked") | (grepl("neuralsig", map) & mask == "unmasked")) %>%
  unite(variable, process, test, condition, control, sep = "_", remove = TRUE) %>%
  mutate(variable = sprintf("multivariate_%s", variable)) %>%
  filter(session == "all") %>%
  select(-c(map, con, mask, session, dotProduct)) %>%
  left_join(., ind_diffs) %>%
  select(-c(sample, DBIC_ID, age, gender))

dots_rest_assoc = dots_sca %>%
  filter(grepl("rest", variable) & grepl("snack|meal|dessert|food", variable) & grepl("association", variable)) %>%
  spread(variable, dotProduct_std) %>%
  unique() %>%
  ungroup()

dots_rest_uniform = dots_sca %>%
  filter(grepl("rest", variable) & grepl("snack|meal|dessert|food", variable) & grepl("uniformity", variable)) %>%
  spread(variable, dotProduct_std) %>%
  unique() %>%
  ungroup()

dots_nature_assoc = dots_sca %>%
  filter(grepl("nature", variable) & grepl("snack|meal|dessert|food", variable) & grepl("association", variable)) %>%
  spread(variable, dotProduct_std) %>%
  unique() %>%
  ungroup()

dots_nature_uniform = dots_sca %>%
  filter(grepl("nature", variable) & grepl("snack|meal|dessert|food", variable) & grepl("uniformity", variable)) %>%
  spread(variable, dotProduct_std) %>%
  unique() %>%
  ungroup()

# set na.action for dredge
options(na.action = "na.fail")

# specify number of cores
n_cores = 28

## BMI
# dots association > rest
if (file.exists("bmi_dots_rest_assoc_sca.RDS")) {
  dots_rest_assoc_sca = readRDS("bmi_dots_rest_assoc_sca.RDS")
} else {
  data = dots_rest_assoc %>%
    select(-fat) %>%
    na.omit()
  lm_predictors = paste(names(select(dots_rest_assoc, -c(subjectID, bmi, fat))), collapse = " + ")
  lm_formula = formula(paste0("bmi ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_rest_assoc_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_rest_assoc_sca, "bmi_dots_rest_assoc_sca.RDS")
}

# dots uniformity > rest
if (file.exists("bmi_dots_rest_uniform_sca.RDS")) {
  dots_rest_uniform_sca = readRDS("bmi_dots_rest_uniform_sca.RDS")
} else {
  data = dots_rest_uniform %>%
    select(-fat) %>%
    na.omit()
  lm_predictors = paste(names(select(dots_rest_uniform, -c(subjectID, bmi, fat))), collapse = " + ")
  lm_formula = formula(paste0("bmi ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_rest_uniform_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_rest_uniform_sca, "bmi_dots_rest_uniform_sca.RDS")
}

# dots association > nature
if (file.exists("bmi_dots_nature_assoc_sca.RDS")) {
  dots_nature_assoc_sca = readRDS("bmi_dots_nature_assoc_sca.RDS")
} else {
  data = dots_nature_assoc %>%
    select(-fat) %>%
    na.omit()
  lm_predictors = paste(names(select(dots_nature_assoc, -c(subjectID, bmi, fat))), collapse = " + ")
  lm_formula = formula(paste0("bmi ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_nature_assoc_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_nature_assoc_sca, "bmi_dots_nature_assoc_sca.RDS")
}

# dots uniformity > nature
if (file.exists("bmi_dots_nature_uniform_sca.RDS")) {
  dots_nature_uniform_sca = readRDS("bmi_dots_nature_uniform_sca.RDS")
} else {
  data = dots_nature_uniform %>%
    select(-fat) %>%
    na.omit()
  lm_predictors = paste(names(select(dots_nature_uniform, -c(subjectID, bmi, fat))), collapse = " + ")
  lm_formula = formula(paste0("bmi ~ ", lm_predictors, collapse = " + "))

  full_model = lm(lm_formula,
                  data = data)

  clust = parallel::makeCluster(getOption("cl.cores", n_cores))
  invisible(parallel::clusterCall(clust, "library", character.only = TRUE))
  parallel::clusterExport(clust, "data")

  dots_nature_uniform_sca = MuMIn::pdredge(full_model, cluster = clust, rank = "AIC", extra = "BIC")
  parallel::stopCluster(clust)

  saveRDS(dots_nature_uniform_sca, "bmi_dots_nature_uniform_sca.RDS")
}
