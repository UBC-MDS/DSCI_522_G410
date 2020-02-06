# author: Holly Williams
# date: 2020-01-24


"Fits linear models on the pre-processed FIFA and league data and saves the models as an rds file.

Usage: src/analysis_overpaid.r --input_file=<input_file> --out_dir_p=<out_dir_p> --out_dir_r=<out_dir_r>

Options:
--input_file=<input_file>   Path (including filename) to cleaned league and fifa file
--out_dir_p=<out_dir_p>     Path to directory where the plots should be written
--out_dir_r=<out_dir_r>     Path to directory where the results should be written
" -> doc
#example to run: Rscript src/analysis_overpaid.r --input_file='data/cleaned/combined_league_data.csv' --out_dir_p='results/img' --out_dir_r='results'
library(tidyverse)
library(docopt)
library(broom)
library(scales)
library(tools)
library(testthat)
library(cowplot)

opt <- docopt(doc)
main <- function(input_file, out_dir_p, out_dir_r){
  
  #Testing input file format
  test_that("Error!! input_file must have .csv extension format.",{
    expect_equal(file_ext(input_file), "csv")})
  
  #Testing out_dir_p file directory format
  test_that("Warning!! out_dir_p directory address cannot contain a file extension. Please check.",{
    expect_equal(file_ext(out_dir_p), "")}) 
  
  #Testing out_dir_r file directory format
  test_that("Warning!! out_dir_r directory address cannot contain a file extension. Please check.",{
    expect_equal(file_ext(out_dir_r), "")}) 
  
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
  # Make violin plot zoomed into area of interest
  ymax=100 # this is the highest overpaid index we want to show
  zoomed_plot <- ggplot(df, aes(x = Domestic, y = Overpaid_Index, group = Domestic, colour = factor(Domestic))) +
    geom_violin() +
    stat_summary(fun.y = mean, colour = "black", geom = "point",
                 shape = 18, size = 6) +
    labs(x = "Player", y = "Overpaid Index") + 
    scale_x_continuous(breaks = c(0, 1),
                       labels = c("Foreign", "Domestic")) +
    facet_wrap(~League, ncol=5) +
    theme_bw() +
    theme(text = element_text(size = 18)) +
    theme(legend.position = "none") +
    # use cartesian coordinates instead of xlim so all data is included
    coord_cartesian(xlim = NULL, ylim = c(0, ymax), expand = TRUE,
                    default = FALSE, clip = "on")
  #create a rectangle to show where we are zooming in and plot on whole data
  rect <- data.frame(xmin=-Inf, xmax=Inf, ymin=0, ymax=ymax)
  overpaid_plot <- zoomed_plot +
    geom_rect(data=rect, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),
              color="grey20",
              alpha=0.15,
              inherit.aes = FALSE, linetype = 2) +
    coord_cartesian(xlim = NULL, ylim = NULL, expand = TRUE,
                    default = FALSE, clip = "on")
  # combine two plots together in cowplot
  combined_plot = plot_grid(overpaid_plot, zoomed_plot, 
                            labels = c('A. FULL PLOT', 'B. ZOOMED IN Y-AXIS'), 
                            label_size = 12, ncol=1, 
                            rel_heights = c(1, 2),
                            label_x = 0, label_y = 0,
                            hjust = 0, vjust = -0.5)
  
  # add title to cowplot
  title <- ggdraw() + 
    draw_label(
      "Figure 1: Overpaid Index Distributions by Player Origin (Domestic or Foreign)",
      fontface = 'bold',
      x = 0,
      hjust = 0
    ) +
    theme(
      plot.margin = margin(0, 0, 0, 7)
    )
  combined_with_title <- plot_grid(
    title, combined_plot,
    ncol = 1,
    rel_heights = c(0.1, 1)
  )
  ggsave(paste0(out_dir_p, "/overpaid_plot.png"), width=14, height=8)
  

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