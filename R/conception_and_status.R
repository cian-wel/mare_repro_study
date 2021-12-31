# about ---------
# conception_and_status.R
#
# this file initialises the workspace

# clear workspace ------
rm(list = ls())

# load data ------------------
load(file = "data/data.rda")
conc_and_stat = data.frame(matrix(ncol=5, nrow=0))
colnames(conc_and_stat) <- c("status", "served_cycle_num", "d14_16_pos", "d14_16_neg", "d14_16_total")

to_add = data.frame(matrix(ncol=5, nrow=5))
colnames(to_add) <- c("status", "served_cycle_num", "d14_16_pos", "d14_16_neg", "d14_16_total")
mare_status <- c("Foaling", "Maiden", "Barren", "Barren (EPL)", "Barren(PL)", "Slipped", "Rested")

for (i in 1:length(mare_status)) {
  for (j in min(data$served_cycle_num):max(data$served_cycle_num)) {
    df <- subset(data, status==mare_status[i] & served_cycle_num==j)
    to_add$status[j] <- mare_status[i]
    to_add$served_cycle_num[j] <- j
    to_add$d14_16_pos[j] <- length(df$preg_d14_16[df$preg_d14_16 == TRUE])
    to_add$d14_16_neg[j] <- length(df$preg_d14_16[df$preg_d14_16 == FALSE])
    to_add$d14_16_total[j] <- length(df$preg_d14_16)
    print(j)
  }
  conc_and_stat <- rbind(conc_and_stat, to_add)
  print(i)
}

