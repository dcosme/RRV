# This script concatenates participant data and adds condition information

# load packages
library(tidyverse)

# load parameter estimates
file_dir = "../roi/parameterEstimates"
file_pattern = "RRV[0-9]{3}_parameterEstimates.txt"
file_list = list.files(file_dir, pattern = file_pattern)

betas_temp = data.frame()

for (file in file_list) {
  temp = tryCatch(read.table(file.path(file_dir,file), fill = TRUE) %>%
                    rename("subjectID" = V1,
                           "con" = V2,
                           "x" = V3,
                           "y" = V4,
                           "z" = V5,
                           "meanPE" = V6,
                           "sdPE" = V7), error = function(e) message(file))

  betas_temp = rbind(betas_temp, temp)
  rm(temp)
}

# tidy parameter estimates
snack_cons3 = sprintf("con_%04d.nii", c(1:3, 19:21))
meal_cons3 = sprintf("con_%04d.nii", c(4:6, 22:24))
dessert_cons3 = sprintf("con_%04d.nii", c(7:9, 25:27))
nature_cons3 = sprintf("con_%04d.nii", c(10:12))
social_cons3 = sprintf("con_%04d.nii", c(13:15, 31:33))
food_cons3 = sprintf("con_%04d.nii", c(16:18, 28:30))

snack_cons1 = sprintf("con_%04d.nii", c(1, 7))
meal_cons1 = sprintf("con_%04d.nii", c(2, 8))
dessert_cons1 = sprintf("con_%04d.nii", c(3, 9))
nature_cons1 = sprintf("con_%04d.nii", c(4))
social_cons1 = sprintf("con_%04d.nii", c(5, 11))
food_cons1 = sprintf("con_%04d.nii", c(6, 10))

betas = betas_temp %>%
  filter(!is.na(meanPE)) %>%
  unite(xyz, x, y, z) %>%
  group_by(subjectID) %>%
  mutate(roi = ifelse(xyz == "9_3_-6", "right VS",
               ifelse(xyz == "-9_3_-6", "left VS",
               ifelse(xyz == "-30_33_-18", "left lOFC",
               ifelse(xyz == "46_28_31", "right dlPFC",
               ifelse(xyz == "-44_27_33", "left dlPFC",
               ifelse(xyz == "44_8_34", "right MFG",
               ifelse(xyz == "-42_7_36", "left MFG",
               ifelse(xyz == "54_-44_43", "right IPL",
               ifelse(xyz == "-53_-50_39", "left IPL",
               ifelse(xyz == "32_-59_41", "right IPS",
               ifelse(xyz == "-32_-58_46", "left IPS",
               ifelse(xyz == "-6_49_1", "left vmPFC", NA)))))))))))),
        condition = ifelse(n() > 132 & con %in% snack_cons3, "snack",
                    ifelse(n() > 132 & con %in% meal_cons3, "meal",
                    ifelse(n() > 132 & con %in% dessert_cons3, "dessert",
                    ifelse(n() > 132 & con %in% nature_cons3, "nature",
                    ifelse(n() > 132 & con %in% social_cons3, "social",
                    ifelse(n() > 132 & con %in% food_cons3, "food",
                    ifelse(n() == 132 & con %in% snack_cons1, "snack",
                    ifelse(n() == 132 & con %in% meal_cons1, "meal",
                    ifelse(n() == 132 & con %in% dessert_cons1, "dessert",
                    ifelse(n() == 132 & con %in% nature_cons1, "nature",
                    ifelse(n() == 132 & con %in% social_cons1, "social",
                    ifelse(n() == 132 & con %in% food_cons1, "food", NA)))))))))))),
        control = ifelse(n() > 132 & con %in% sprintf("con_%04d.nii", c(19:33)), "nature",
                  ifelse(n() == 132 & con %in% sprintf("con_%04d.nii", c(7:11)), "nature", "rest")),
        session = ifelse(n() > 132 & con %in% sprintf("con_%04d.nii", seq(1,33,3)), "1",
                  ifelse(n() > 132 & con %in% sprintf("con_%04d.nii", seq(2,33,3)), "2", "all")),
        process = ifelse(grepl("VS|OFC", roi), "reward",
                  ifelse(grepl("vmPFC", roi), "value", "cognitive_control"))) %>%
  ungroup() %>%
  select(subjectID, session, con, condition, control, xyz, roi, process, meanPE, sdPE)

# load dot products
file_dir = "../multivariate/expression_maps/dotProducts"
file_pattern = "RRV[0-9]{3}_dotProducts.txt"
file_list = list.files(file_dir, pattern = file_pattern)

dots = data.frame()

for (file in file_list) {
  temp = tryCatch(read.table(file.path(file_dir,file), fill = TRUE, header = FALSE) %>%
                    rename("subjectID" = V1,
                           "map" = V2,
                           "con" = V3,
                           "mask" = V4,
                           "dotProduct" = V5) %>%
                    filter(!is.na(dotProduct)) %>%
                    extract(map, c("process", "test"), "(.*)_(association|uniformity)-.*", remove = FALSE) %>%
                    mutate(process = ifelse(grepl("neuralsig", map), "craving_regulation", process),
                           test = ifelse(grepl("neuralsig", map), "association", test),
                           condition = ifelse(n() > 198 & con %in% snack_cons3, "snack",
                                       ifelse(n() > 198 & con %in% meal_cons3, "meal",
                                       ifelse(n() > 198 & con %in% dessert_cons3, "dessert",
                                       ifelse(n() > 198 & con %in% nature_cons3, "nature",
                                       ifelse(n() > 198 & con %in% social_cons3, "social",
                                       ifelse(n() > 198 & con %in% food_cons3, "food",
                                       ifelse(n() <= 198 & con %in% snack_cons1, "snack",
                                       ifelse(n() <= 198 & con %in% meal_cons1, "meal",
                                       ifelse(n() <= 198 & con %in% dessert_cons1, "dessert",
                                       ifelse(n() <= 198 & con %in% nature_cons1, "nature",
                                       ifelse(n() <= 198 & con %in% social_cons1, "social",
                                       ifelse(n() <= 198 & con %in% food_cons1, "food", NA)))))))))))),
                           control = ifelse(n() > 198 & con %in% sprintf("con_%04d.nii", c(19:33)), "nature",
                                     ifelse(n() <= 198 & con %in% sprintf("con_%04d.nii", c(7:11)), "nature", "rest")),
                           session = ifelse(n() > 198 & con %in% sprintf("con_%04d.nii", seq(1,33,3)), "1",
                                     ifelse(n() > 198 & con %in% sprintf("con_%04d.nii", seq(2,33,3)), "2", "all"))), error = function(e) message(file))

  dots = rbind(dots, temp)
  rm(temp)
}


# load EMA data
ema = read.csv("EMA_data.csv") %>%
  rename("subjectID" = RRVID) %>%
  select(-c(key, SSID, subID, SAMPLE, control))

ema_enact = ema %>%
  mutate(subjectID = as.character(subjectID)) %>%
  select(subjectID, enact_prop) %>%
  unique() %>%
  filter(!is.na(subjectID))

# load outcomes
ind_diffs = read.csv("individual_diffs_outcomes.csv") %>%
  rename("subjectID" = RRV_ID_NEW,
         "age" = Age,
         "gender" = Gender,
         "sample" = Sample) %>%
  mutate(subjectID = as.character(subjectID)) %>%
  select(sample, DBIC_ID, subjectID, age, gender, bmi, fat, restraint) %>%
  left_join(., unique(select(ema, subjectID, fat)), by = "subjectID") %>%
  mutate(fat.x = ifelse(sample == "2012_FDES", fat.y, fat.x)) %>%
  select(-fat.y) %>%
  rename("fat" = fat.x)













