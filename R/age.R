# about ---------
# age.R
#
# this file looks at age and conception status

# clear workspace ------
rm(list = ls())

# load data ------------------
load(file = "data/data.rda")

# manipulate --------------
age = data.frame(matrix(ncol=4, nrow=0))
colnames(age) <- c("age", "d14_16_pos", "d14_16_neg", "d14_16_total")

to_add = data.frame(matrix(ncol=4, nrow=1))
colnames(to_add) <- colnames(age)

# main body -------------
for (i in min(data$mare_age):max(data$mare_age)) {
  df <- subset(data, mare_age==i)
  to_add$age <- i
  to_add$d14_16_pos <- length(df$preg_d14_16[df$preg_d14_16 == TRUE])
  to_add$d14_16_neg <- length(df$preg_d14_16[df$preg_d14_16 == FALSE])
  to_add$d14_16_total <- length(df$preg_d14_16)
  age <- rbind(age, to_add)
}

age$preg_rate <- format(round(age$d14_16_pos / age$d14_16_total, 4), nsmall = 4)

# end ------
save(age, file = "output/age.rda")