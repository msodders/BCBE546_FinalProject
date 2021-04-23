### Trying to plot the TnSeq data from TSAS

setwd("~/Desktop/TSAS_test_analysis")
library(tidyverse)
install.packages("scales")
library(scales)


EssGenesAll <- read.delim("EssGenesAll_Merge.txt", header = TRUE, sep = "\t")


#Creating a new column to rename the groups 
EssGenesAll <- mutate(EssGenesAll, Enrichment = Library) #creating a new column identical to "Library" 
EssGenesAll$Enrichment[ EssGenesAll$Enrichment == "Ess538"] = "E3"  #Replace Ess538 in the Enrichment column with "E3"
EssGenesAll$Enrichment[ EssGenesAll$Enrichment == "Ess539"] = "E2"  #Replace Ess539 in the Enrichment column with "E2"
EssGenesAll$Enrichment[ EssGenesAll$Enrichment == "Ess540"] = "E1"  #Replace Ess540 in the Enrichment column with "E1"
EssGenesAll$Enrichment[ EssGenesAll$Enrichment == "Ess541"] = "Library"  #Replace Ess541 in the Enrichment column with "Library"

EssGenesAll$TotalNumberReads.n <- as.numeric(EssGenesAll$TotalNumberReads)

#This command orders the 4 categories so that E3 will be first and the Library at the end
EssGenesAll$Enrichment.f = factor(EssGenesAll$Enrichment, levels=c('E3','E2','E1','Library'))


#Setting the maximum number of reads to 10 (just to facilitate plotting... 
#       some of these have >1000 reads and others only ~2)
EssGenesAll$TotalNumberReads.n[EssGenesAll$TotalNumberReads.n > 10] <- 10



#The plot with plenty of modifications to make it look more similar to the paper's
ggplot(data = EssGenesAll, aes(x=start, y=TotalNumberReads.n, color = Enrichment.f)) + 
  geom_line(mapping = aes(x=start, y=TotalNumberReads.n)) +
  facet_grid(Enrichment.f ~ .) +   
  scale_color_manual(values = c("E3" = "lightpink", "E2" = "lightblue", "E1" = "deeppink4", 
                                "Library" = "grey30")) + 
  xlab('Position') + ylab('Number of Unique Hits') +
  ggtitle("Graphical Depiction of Tn Insertions in MPAO1 Library and Enrichments") + 
  theme(axis.text.x = element_text(size = 10, angle = 0, vjust = 1),
        axis.text.y = element_text(size = 8), 
        axis.title.y = element_text(size = 14), 
        axis.title.x = element_text(size = 14),
        panel.grid.major=element_blank(), panel.grid.minor=element_blank(),
        plot.title = element_text(size =15, hjust = 0.5),
        legend.position = "none", 
        axis.line = element_line(colour = "grey20", 
                                 size = 0.4, linetype = "solid")) + 
  scale_y_continuous(name="Number of Unique Hits", limits=c(0, 10), expand = c(0.01, 0),
                     breaks=c(0, 5, 10)) +
  scale_x_continuous(name="Position", limits=c(0, 6275467), labels = comma, expand = c(0.005, 0),
                     breaks=c(0,1000000, 2000000, 3000000, 4000000, 5000000, 6000000))


