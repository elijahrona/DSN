library(tidyverse)
library(patchwork)
library(ggcorrplot)

data()
help(iris)

aa <- iris

colnames(aa)
summary(aa)

grouped_aa <- aa %>%
  group_by(Species) %>%
  summarize(Sepal.Length = mean(Sepal.Length), Sepal.Width = mean(Sepal.Width),
            Petal.Length = mean(Petal.Length), Petal.Width = mean(Petal.Width))

p1 <- grouped_aa %>%  
  ggplot(aes(x = Species, y = Sepal.Width, fill = Species)) + 
  geom_bar(color = 'black', stat = "identity") +
  ggtitle("Sepal Width of Different Irises") +
  theme(panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        size = 0.5, linetype = "solid")) +
  guides(fill="none")

#Change color of bars. The number of colors must match the number of bars
p1 <- p1 +
  scale_fill_manual(values=c("#0008e6", "#e60017","#06ba12"))

aa_cor <- cor(aa[,-5], method = "pearson", use='pairwise.complete.obs')

p2 <- ggcorrplot(aa_cor, colors = c("#e60017", "#0008e6", "#06ba12"),
           outline.color = "black", lab = TRUE)+
  ggtitle("Correlation Plot for Iris Plants")

p1+p2

(p1+p2)/(p2+p1)

p1+p2 + 
  plot_layout(widths = c(1,1))

p1+p2 + 
  plot_layout(widths = c(1,1)) + plot_annotation(
    title = "Basic (Static) Dashboard for DSN",
    caption = "Data: Iris"
  )