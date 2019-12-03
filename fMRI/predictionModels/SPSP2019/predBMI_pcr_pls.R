# Load the data

#d <- read.csv("dataWide_forRegressions.csv", header=T)
d <- read.csv("dataWide_forRegressions_ex_RRV043.csv", header=T) # N=46

#dsub <- dplyr::select(d, fat, Gender, fVn_left.dlPFC,fVn_left.IPL,fVn_left.IPS,fVn_left.MFG,
#                      fVn_right.dlPFC,fVn_right.IPL,fVn_right.IPS,fVn_right.MFG,fVn_left.lOFC,
#                      fVn_left.VS,fVn_right.VS,fVn_left.vmPFC,fVn_balance,fvn_cog_dp,fvn_rew_dp,fvn_val_dp)


dsub <- dplyr::select(d, bmi, fVn_left.dlPFC,fVn_left.IPL,fVn_left.IPS,fVn_left.MFG,
                      fVn_right.dlPFC,fVn_right.IPL,fVn_right.IPS,fVn_right.MFG,fVn_left.lOFC,
                      fVn_left.VS,fVn_right.VS)



dsub <- na.omit(dsub); dim(dsub)[1] #N=41

# Split the data into training and test set
#set.seed(342)
training.samples <- dsub$bmi %>%
  createDataPartition(p = 0.75, list = FALSE)
train.data  <- dsub[training.samples, ]
test.data <- dsub[-training.samples, ]

# Build the model on training set
#set.seed(267)
model <- train(
  bmi~., data = train.data, method = "pcr",
  scale = TRUE,
  trControl = trainControl("cv", number = 12),
  tuneLength = 12
)
# Plot model RMSE vs different values of components
plot(model)
# Print the best tuning parameter ncomp that
# minimize the cross-validation error, RMSE

summary(model$finalModel)
model$bestTune


model$finalModel$loadings


######
# Make predictions
predictions <- model %>% predict(test.data)
# Model performance metrics
data.frame(
  RMSE = caret::RMSE(predictions, test.data$bmi),
  Rsquare = caret::R2(predictions, test.data$bmi)
)

