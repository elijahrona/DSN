library(tidyverse)
library(ggcorrplot)
library(patchwork)
#For the first plot, we will use the iris dataset.
aa <- iris

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

#For the seconf plot, we will use the orange dataset
aa1 <- txhousing

aa1 <- aa1 %>% #Filter the data
  filter(year == c("2000","2001","2003","2004","2005"), 
         city == c("Abilene","Arlington","Bay Area"))

p2 <- ggplot(data=aa1, aes(x=year, y=sales, group=city, colour=city)) +
  geom_line(size = 1.0) +
  geom_point() +
  theme(
    panel.background = element_rect(fill = "white",
                                    colour = "white",
                                    size = 0.5, linetype = "solid")) +
  ggtitle("Line Chart")

#For the first plot, we will correlate the iris dataset
aa_cor <- cor(aa[,-5], method = "pearson", use='pairwise.complete.obs')
p3 <- ggcorrplot(aa_cor, colors = c("#e60017", "#0008e6", "#06ba12"),
                 outline.color = "black", lab = TRUE)+
  ggtitle("Correlation Plot")

(p1+p3)/p2
