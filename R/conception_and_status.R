# about ---------
# conception_and_status.R
#
# this file initialises the workspace

# clear workspace ------
rm(list = ls())

# load data ------------------
load(file = "data/data.rda")

# manipulate -----------------------
conc_and_stat = data.frame(matrix(ncol=5, nrow=0))
colnames(conc_and_stat) <- c("status", "served_cycle_num", "d14_16_pos", "d14_16_neg", "d14_16_total")

data$adj_status[data$begin_status == "Foaling" | data$begin_status == "Maiden" | data$begin_status == "Barren"] <- data$begin_status[data$begin_status == "Foaling" | data$begin_status == "Maiden" | data$begin_status == "Barren"]
data$adj_status[data$begin_status == "Barren (EPL)" | data$begin_status == "Barren(PL)" | data$begin_status == "Slipped"] <- "Barren(PL)/Slipped"
data$adj_status[data$begin_status == "Rested"] <- "Rested"

to_add = data.frame(matrix(ncol=5, nrow=5))
colnames(to_add) <- c("status", "served_cycle_num", "d14_16_pos", "d14_16_neg", "d14_16_total")
statuses <- unique(data$adj_status)

# main statuses -----------------
for (i in 1:length(statuses)) {
  for (j in min(data$served_cycle_num):max(data$served_cycle_num)) {
    df <- subset(data, adj_status==statuses[i] & served_cycle_num==j)
    to_add$status[j] <- statuses[i]
    to_add$served_cycle_num[j] <- j
    to_add$d14_16_pos[j] <- length(df$preg_d14_16[df$preg_d14_16 == TRUE])
    to_add$d14_16_neg[j] <- length(df$preg_d14_16[df$preg_d14_16 == FALSE])
    to_add$d14_16_total[j] <- length(df$preg_d14_16)
    #print(j)
  }
  conc_and_stat <- rbind(conc_and_stat, to_add)
  #print(i)
}

# non-foaling ---------------------
non_foaling_status <- statuses[statuses != "Foaling"]

for (j in min(data$served_cycle_num):max(data$served_cycle_num)) {
  df <- subset(data, adj_status %in% non_foaling_status & served_cycle_num==j)
  to_add$status[j] <- "Non-Foaling"
  to_add$served_cycle_num[j] <- j
  to_add$d14_16_pos[j] <- length(df$preg_d14_16[df$preg_d14_16 == TRUE])
  to_add$d14_16_neg[j] <- length(df$preg_d14_16[df$preg_d14_16 == FALSE])
  to_add$d14_16_total[j] <- length(df$preg_d14_16)
  #print(j)
}
conc_and_stat <- rbind(conc_and_stat, to_add)

conc_and_stat$preg_rate <- format(round(conc_and_stat$d14_16_pos / conc_and_stat$d14_16_total, 4), nsmall = 4)

# end ------
save(conc_and_stat, file = "output/conc_and_stat.rda")
