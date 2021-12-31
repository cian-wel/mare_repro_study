# about ---------
# initialise.R
#
# this file initialises the workspace

# clear workspace ------
rm(list = ls())

# set working directory -------
working_directory <- dirname(rstudioapi::getSourceEditorContext()$path)
working_directory <- paste(working_directory, "/..", sep = "")
setwd(working_directory)

# load library programs ---------------
library(tidyverse)
library(readxl)
library(data.table)

# import and clean excel data ----------
data <- data.frame(read_excel("data/data.xlsx"))

data$year <- as.character(data$year)
data$date <- paste(data$year, data$month, "01", sep="-")
data$date <- as.Date(data$date, "%Y-%b-%d")
drops <- c("year", "month")
data <- data[, !(names(data) %in% drops)]
data <- data %>% select(date, everything())
data <- data[order(data$date),]

data$prev_preg_loss[data$prev_preg_loss == "N"] <- 0
data$prev_preg_loss[data$prev_preg_loss == "Y"] <- 1
data$prev_preg_loss[data$prev_preg_loss == "N/A"] <- NA

data$preg_d14_16[data$preg_d14_16 == "Y"] <- TRUE
data$preg_d14_16[data$preg_d14_16 == "N"] <- FALSE

# end ------
save(data, file = "data/data.rda")
#rm(list = ls())