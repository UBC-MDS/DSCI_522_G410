# author: Holly Williams
# date: 2020-01-24


"Fits linear models on the pre-processed FIFA and league data and saves the models as an rds file.

Usage: src/analysis_overpaid.r --input_file=<input_file> --out_dir_p=<out_dir_p> --out_dir_r=<out_dir_r>

Options:
--input_file=<input_file>   Path (including filename) to cleaned league and fifa file
--out_dir_p=<out_dir_p>     Path to directory where the plots should be written
--out_dir_r=<out_dir_r>     Path to directory where the results should be written
" -> doc

library(tidyverse)
library(docopt)
library(broom)
library(scales)

opt <- docopt(doc)
main <- function(input_file, out_dir_p, out_dir_r){
  # Read in data
  df <- read_csv(input_file)
  ##############################################################################################
  # Fitting models and saving results 
  ##############################################################################################
  # Fit simple linear model
  lm <- lm(Overpaid_Index ~ Domestic, data = df)
  # Fit additive and interactive models with league
  lm_add <- lm(Overpaid_Index ~ Domestic + League, data = df)
  lm_int <- lm(Overpaid_Index ~ Domestic * League, data = df)
  # check whether our more complicated models are significantly better using an anova test
  test_lm_vs_lm_add <- anova(lm, lm_add)
  test_lm_add_vs_lm_int <- anova(lm_add, lm_int)
  
  #save results to rds file
  saveRDS(lm, file = paste0(out_dir_r, "/lm.rds"))
  saveRDS(lm_int, file = paste0(out_dir_r, "/lm_int.rds"))
  saveRDS(lm_add, file = paste0(out_dir_r, "/lm_add.rds"))
  saveRDS(test_lm_vs_lm_add, file = paste0(out_dir_r, "/anova_1.rds"))
  saveRDS(test_lm_add_vs_lm_int, file = paste0(out_dir_r, "/anova_2.rds"))
  
  ##############################################################################################
  # Plots
  ##############################################################################################
  # Make combined box + jitter plot
  overpaid_plot <- ggplot(df, aes(x = Domestic, y = Overpaid_Index, group = Domestic, colour = factor(Domestic))) +
    geom_boxplot() +
    geom_jitter(width = 0.15, alpha = 0.2, size = 1.5) +
    stat_summary(fun.y = mean, colour = "black", geom = "point",
                 shape = 18, size = 6) +
    labs(x = "Player", y = "Overpaid Index - log(10) scale\n(Salary / FIFA point rating x 1000)") + 
    scale_x_continuous(breaks = c(0, 1),
                       labels = c("Foreign", "Domestic")) +
    facet_wrap(~League, ncol=5) +
    scale_y_continuous(trans='log10') +
    theme_bw() +
    theme(text = element_text(size = 18)) +
    theme(legend.position = "none")
  ggsave(paste0(out_dir_p, "/overpaid_plot.png"), width=14, height=5)
  
  ##############################################################################################
  # Summary Table
  ##############################################################################################
  #Extract p-values from models
  p_value <- tidy(lm_add)$p.value[2:6] %>% 
    scientific(digits = 3)
  p_value_df <- data.frame(p_value)
  
  # Table of means and p-values
  df_means <- df %>% 
    group_by(League, Domestic) %>% 
    summarize(avg_oi = round(mean(Overpaid_Index), 2)) %>%
    mutate(player = ifelse(Domestic == 1, 'Domestic Mean Overpaid Index', 'Foreign Mean Overpaid Index'))  %>% 
    select(-Domestic) %>% 
    spread(key = player, value=avg_oi) %>% 
    mutate(Difference = `Domestic Mean Overpaid Index` - `Foreign Mean Overpaid Index`)
  
  # combine and save output
  df_summary <- bind_cols(df_means, p_value_df)
  write.csv(df_summary, paste0(out_dir_r, "/summary_model_table.csv"))
}
main(opt[["--input_file"]], opt[["--out_dir_p"]], opt[["--out_dir_r"]])