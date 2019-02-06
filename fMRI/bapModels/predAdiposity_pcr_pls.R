# Load the data

#d <- read.csv("dataWide_forRegressions.csv", header=T)
d <- read.csv("dataWide_forRegressions_ex_RRV043.csv", header=T) # N=46
d <- na.omit(d)


fit <- lm(fat~Gender,d)
d$fat_resid <- fit$residuals


# To change/toggle:
#dsub <- dplyr::select(d, fat_resid, fVn_left.dlPFC,fVn_left.IPL,fVn_left.IPS,fVn_left.MFG,
#                      fVn_right.dlPFC,fVn_right.IPL,fVn_right.IPS,fVn_right.MFG,fVn_left.lOFC,
#                      fVn_left.VS,fVn_right.VS)


dselect <- dplyr::select(d, fat_resid, fVn_left.dlPFC,fVn_left.IPL,fVn_left.IPS,fVn_left.MFG,
                      fVn_right.dlPFC,fVn_right.IPL,fVn_right.IPS,fVn_right.MFG,fVn_left.lOFC,
                      fVn_left.VS,fVn_right.VS)

#dsub <- na.omit(dsub); dim(dsub) #N=41
dsub <- dselect


# Split the data into training and test set
set.seed(346)
training.samples <- dsub$fat_resid %>%
  createDataPartition(p = 0.75, list = FALSE)
train.data  <- dsub[training.samples, ]
test.data <- dsub[-training.samples, ]

# Build the model on training set
set.seed(267)
model <- train(
  fat_resid~., data = train.data, method = "pcr",
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
  RMSE = caret::RMSE(predictions, test.data$fat_resid),
  Rsquare = caret::R2(predictions, test.data$fat_resid)
)

#### PLS ###################################################################


# Build the model on training set
#set.seed(268)
model <- train(
  fat_resid~., data = train.data, method = "pls",
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
  RMSE = caret::RMSE(predictions, test.data$fat_resid),
  Rsquare = caret::R2(predictions, test.data$fat_resid)
)

















