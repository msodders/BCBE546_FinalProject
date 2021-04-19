## BCB546 Final Project


setwd("~/Desktop/BCB546_FinalProject")
library(tidyverse)

TableS1A <- read.csv("TableS1A-edited.csv", header = TRUE)
TableS1A$Category.f <- as.factor(TableS1A$Category)
TableS1A$Category.n <- as.numeric(TableS1A$Category)


CategoryCounts <- count(TableS1A, Category, wt = NULL, sort = FALSE, name = "count")
ZeroCountCategories <- data.frame(c(6, 12, 14),
                                  c(0, 0, 0))
names(ZeroCountCategories) <- c("Category", "count")

AllCategoryCounts <- rbind(CategoryCounts, ZeroCountCategories)
AllCategoryCounts$Category.f <- as.factor(AllCategoryCounts$Category)
AllCategoryCounts$Category.n <- as.numeric(AllCategoryCounts$Category)

AllSorted <- AllCategoryCounts[order(AllCategoryCounts$Category.n),]

#Renaming the categories from numbers into the name of the category
AllSorted$Category[ AllSorted$Category.f == 1] = "Quorum Sensing"
AllSorted$Category[ AllSorted$Category.f == 2] = "Adherence / Motility"
AllSorted$Category[ AllSorted$Category.f == 3] = "Energy / Metabolism"
AllSorted$Category[ AllSorted$Category.f == 4] = "Fe / Heme"
AllSorted$Category[ AllSorted$Category.f == 5] = "DNA"
AllSorted$Category[ AllSorted$Category.f == 6] = "RNA"
AllSorted$Category[ AllSorted$Category.f == 7] = "Protein"
AllSorted$Category[ AllSorted$Category.f == 8] = "Virulence"
AllSorted$Category[ AllSorted$Category.f == 9] = "Transportation"
AllSorted$Category[ AllSorted$Category.f == 10] = "Cellular Stress"
AllSorted$Category[ AllSorted$Category.f == 11] = "Fatty Acids"
AllSorted$Category[ AllSorted$Category.f == 12] = "Cell Wall / Envelope"
AllSorted$Category[ AllSorted$Category.f == 13] = "Regulation / Signal Transduction"
AllSorted$Category[ AllSorted$Category.f == 14] = "Phage"
AllSorted$Category[ AllSorted$Category.f == 15] = "Polyamines"
AllSorted$Category[ AllSorted$Category.f == 16] = "Unknown"


#R's default is to sort alphabetically, but making a list of the order I want everything to be in will override that
category_order <- c("Quorum Sensing", "Adherence / Motility", "Energy / Metabolism", 
                    "Fe / Heme", "DNA", "RNA", "Protein", "Virulence", "Transportation",
                    "Cellular Stress", "Fatty Acids", "Cell Wall / Envelope",
                    "Regulation / Signal Transduction", "Phage", "Polyamines", "Unknown")

#Figure3A in the paper color coded their bars by function. This list is each of these colors in the order the categories will be in
color_order <- c("darkgreen", "grey20", "grey20", "chocolate4", "grey20", "grey20", "grey20", 
                 "firebrick2", "grey20", "grey20", "grey20", "grey20", "grey20", "grey20", 
                 "purple", "grey60")


#The chunk of code that will form the final plot
ggplot(data = AllSorted, aes(x=factor(Category, level = category_order), y=count)) + 
         geom_col(mapping = aes(x=factor(Category, level = category_order), y=count), 
                  fill=color_order)  + 
                    xlab('Category') + ylab('Number of Genes') +
         ggtitle("Functional Categorization of Tn Insertions in the Final E3 Dataset") + 
         labs(fill = "") + 
         theme(axis.text.x = element_text(size = 12, angle = 60, vjust = 1, hjust = 1, color=color_order),
               axis.text.y = element_text(size = 12), 
               axis.title.y = element_text(size = 14), 
               axis.title.x = element_text(size = 14),
               plot.title = element_text(size =20, hjust = 0.5))
