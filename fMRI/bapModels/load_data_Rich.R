# This script concatenates participant data and adds condition information

# load packages
library(tidyverse)

# load parameter estimates
file_dir = "/Users/richardlopez/Documents/GitHub/RRV_scripts/fMRI/roi/parameterEstimates"
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
snack_cons = sprintf("con_%04d.nii", c(1:3, 19:21))
meal_cons = sprintf("con_%04d.nii", c(4:6, 22:24))
dessert_cons = sprintf("con_%04d.nii", c(7:9, 25:27))
nature_cons = sprintf("con_%04d.nii", c(10:12))
social_cons = sprintf("con_%04d.nii", c(13:15))
food_cons = sprintf("con_%04d.nii", c(16:18, 28:30))

betas = betas_temp %>%
  unite(xyz, x, y, z) %>%
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
        condition = ifelse(con %in% snack_cons, "snack",
                    ifelse(con %in% meal_cons, "meal",
                    ifelse(con %in% dessert_cons, "dessert",
                    ifelse(con %in% nature_cons, "nature",
                    ifelse(con %in% social_cons, "social",
                    ifelse(con %in% food_cons, "food", NA)))))),
         control = ifelse(con %in% sprintf("con_%04d.nii", c(19:30)), "nature", "rest"),
         session = ifelse(con %in% sprintf("con_%04d.nii", seq(1,30,3)), "1",
                   ifelse(con %in% sprintf("con_%04d.nii", seq(2,30,3)), "2", "all")),
        process = ifelse(grepl("VS|OFC", roi), "reward",
                  ifelse(grepl("vmPFC", roi), "value", "cognitive_control"))) %>%
  select(subjectID, session, con, condition, control, xyz, roi, process, meanPE, sdPE)

# load dot products
file_dir = "/Users/richardlopez/Documents/GitHub/RRV_scripts/fMRI/multivariate/expression_maps/dotProducts"
file_pattern = "RRV[0-9]{3}_dotProducts.txt"
file_list = list.files(file_dir, pattern = file_pattern)

dots = data.frame()

for (file in file_list) {
  temp = tryCatch(read.table(file.path(file_dir,file), fill = TRUE) %>%
                    rename("subjectID" = V1,
                           "map" = V2,
                           "con" = V3,
                           "dotProduct" = V4) %>%
                    extract(map, c("process", "test"), "(.*)_(association|uniformity)-.*", remove = FALSE), error = function(e) message(file))
  
  dots = rbind(dots, temp)
  rm(temp)
}

# join data frames
dataset = full_join(betas, dots, by = c("subjectID", "con", "process"))
