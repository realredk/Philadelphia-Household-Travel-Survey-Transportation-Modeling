install.packages("ggplot2")
library(dplyr)
library(ggplot2)
library(tidyr)

df <- read.csv('2_Person_Public.csv')


'q1'

max_trips <- max(df$P_TOT_TRIPS, na.rm = TRUE)
bins <- seq(0, max_trips, by = 1) 

ggplot(df, aes(x=P_TOT_TRIPS)) +
  geom_histogram(binwidth=1, boundary=0, col="black", fill="white") +
  scale_x_continuous(breaks=bins, limits=c(0, max_trips)) +
  labs(title="Adjusted Histogram of Total Trips Made by Person (P_TOT_TRIPS)",
       x="Total Trips per Person",
       y="Frequency") +
  theme_minimal()

max_mo_trips <- max(df$P_MO_TRIPS, na.rm = TRUE)
bins_mo <- seq(0, max_mo_trips, by = 1) 

ggplot(df, aes(x=P_MO_TRIPS)) +
  geom_histogram(binwidth=1, boundary=0, col="black", fill="white") +
  scale_x_continuous(breaks=bins_mo, limits=c(0, max_mo_trips)) +
  labs(title="Adjusted Histogram of Motorized Trips Made by Person (P_MO_TRIPS)",
       x="Motorized Trips per Person",
       y="Frequency") +
  theme_minimal()

max_nm_trips <- max(df$P_NM_TRIPS, na.rm = TRUE)
bins_nm <- seq(0, max_nm_trips, by = 1) 

ggplot(df, aes(x=P_NM_TRIPS)) +
  geom_histogram(binwidth=1, boundary=0, col="black", fill="white") +
  scale_x_continuous(breaks=bins_nm, limits=c(0, max_nm_trips)) +
  labs(title="Adjusted Histogram of Non-Motorized Trips Made by Person (P_NM_TRIPS)",
       x="Non-Motorized Trips per Person",
       y="Frequency") +
  theme_minimal()


'q2'

person_data <- read.csv('2_Person_Public.csv')
household_data <- read.csv('1_Household_Public.csv')

household_data <- household_data %>%
  mutate(income_midpoint = case_when(
    INCOME == 1 ~ 499.5,
    INCOME == 2 ~ 17499.5,
    INCOME == 3 ~ 29999.5,
    INCOME == 4 ~ 42499.5,
    INCOME == 5 ~ 62499.5,
    INCOME == 6 ~ 87499.5,
    INCOME == 7 ~ 124999.5,
    INCOME == 8 ~ 174999.5,
    INCOME == 9 ~ 224999.5,
    INCOME == 10 ~ 250000, # Midpoint for the highest category
    INCOME == 98 | INCOME == 99 ~ NA_real_, # Exclude 'Don't know' and 'Refused'
    TRUE ~ NA_real_
  )) %>%
  group_by(HH_ID) %>%
  summarise(Avg_Income = mean(income_midpoint, na.rm = TRUE))

person_data <- person_data %>%
  left_join(household_data, by = "HH_ID") %>%
  mutate(no_trip = ifelse(P_TOT_TRIPS == 0, 1, 0), 
         age_midpoint = case_when( 
           AGECAT == 1 ~ 2.5,
           AGECAT == 2 ~ 9,
           AGECAT == 3 ~ 14,
           AGECAT == 4 ~ 16.5,
           AGECAT == 5 ~ 21,
           AGECAT == 6 ~ 29.5,
           AGECAT == 7 ~ 39.5,
           AGECAT == 8 ~ 49.5,
           AGECAT == 9 ~ 59.5,
           AGECAT == 10 ~ 69.5,
           AGECAT == 11 ~ 80,
           AGECAT == 12 ~ 86,
           AGECAT == 98 | AGECAT == 99 ~ NA_real_, # Exclude 'Don't know' and 'Refused'
           TRUE ~ NA_real_
         )) %>%
  select(HH_ID, P_TOT_TRIPS, no_trip, RACE, AGECAT, age_midpoint, Avg_Income)

characteristics <- person_data %>%
  group_by(no_trip) %>%
  summarise(
    Count = n(),
    Average_Age = mean(age_midpoint, na.rm = TRUE),
    Average_Income = mean(Avg_Income, na.rm = TRUE)
  ) %>%
  pivot_wider(names_from = no_trip, values_from = c(Count, Average_Age, Average_Income),
              names_prefix = "Trip_")

characteristics$Race_Distribution <- sapply(characteristics$Race_Distribution, function(x) toString(names(x)))
write.csv(characteristics, file = "output_characteristics.csv", row.names = FALSE)

ggplot(person_data, aes(x = factor(RACE), fill = factor(no_trip))) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Took Trips", "No Trips")) +
  labs(x = "Race", y = "Count", fill = "Trip Status") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(person_data, aes(x = factor(AGECAT), fill = factor(no_trip))) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Took Trips", "No Trips")) +
  labs(x = "Age Category", y = "Count", fill = "Trip Status") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(person_data, aes(x = factor(no_trip), y = Avg_Income)) +
  geom_boxplot() +
  scale_x_discrete(labels = c("No Trips", "Took Trips")) +
  labs(x = "Trip Status", y = "Average Income") +
  theme_minimal()

print(paste("Number of people with no trips:", no_trip_count))


'q3'

person_data <- read.csv('2_Person_Public.csv')
household_data <- read.csv('1_Household_Public.csv')

household_data <- household_data %>%
  mutate(income_midpoint = case_when(
    INCOME == 1 ~ 499.5,
    INCOME == 2 ~ 17499.5,
    INCOME == 3 ~ 29999.5,
    INCOME == 4 ~ 42499.5,
    INCOME == 5 ~ 62499.5,
    INCOME == 6 ~ 87499.5,
    INCOME == 7 ~ 124999.5,
    INCOME == 8 ~ 174999.5,
    INCOME == 9 ~ 224999.5,
    INCOME == 10 ~ 250000, # Midpoint for the highest category
    INCOME == 98 | INCOME == 99 ~ NA_real_, # Exclude 'Don't know' and 'Refused'
    TRUE ~ NA_real_
  )) %>%
  group_by(HH_ID) %>%
  summarise(Avg_Income = mean(income_midpoint, na.rm = TRUE))

person_data <- person_data %>%
  left_join(household_data, by = "HH_ID") %>%
  mutate(no_trip = ifelse(P_TOT_TRIPS == 0, 1, 0), 
         age_midpoint = case_when( 
           AGECAT == 1 ~ 2.5,
           AGECAT == 2 ~ 9,
           AGECAT == 3 ~ 14,
           AGECAT == 4 ~ 16.5,
           AGECAT == 5 ~ 21,
           AGECAT == 6 ~ 29.5,
           AGECAT == 7 ~ 39.5,
           AGECAT == 8 ~ 49.5,
           AGECAT == 9 ~ 59.5,
           AGECAT == 10 ~ 69.5,
           AGECAT == 11 ~ 80,
           AGECAT == 12 ~ 86,
           AGECAT == 98 | AGECAT == 99 ~ NA_real_, # Exclude 'Don't know' and 'Refused'
           TRUE ~ NA_real_
         )) %>%
  select(HH_ID, P_TOT_TRIPS, no_trip, RACE, AGECAT, age_midpoint, Avg_Income)

characteristics <- person_data %>%
  group_by(no_trip) %>%
  summarise(
    Count = n(),
    Average_Age = mean(age_midpoint, na.rm = TRUE),
    Average_Income = mean(Avg_Income, na.rm = TRUE)
  ) %>%
  pivot_wider(names_from = no_trip, values_from = c(Count, Average_Age, Average_Income),
              names_prefix = "Trip_")

characteristics$Race_Distribution <- sapply(characteristics$Race_Distribution, function(x) toString(names(x)))
write.csv(characteristics, file = "output_characteristics.csv", row.names = FALSE)

ggplot(person_data, aes(x = factor(RACE), fill = factor(no_trip))) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Took Trips", "No Trips")) +
  labs(x = "Race", y = "Count", fill = "Trip Status") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(person_data, aes(x = factor(AGECAT), fill = factor(no_trip))) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Took Trips", "No Trips")) +
  labs(x = "Age Category", y = "Count", fill = "Trip Status") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(person_data, aes(x = factor(no_trip), y = Avg_Income)) +
  geom_boxplot() +
  scale_x_discrete(labels = c("No Trips", "Took Trips")) +
  labs(x = "Trip Status", y = "Average Income") +
  theme_minimal()

print(paste("Number of people with no trips:", no_trip_count))


library(dplyr)
library(ggplot2)

trip_data <- read.csv('4_Trip_Public.csv')

no_trip_data <- subset(trip_data, !is.na(WHYNO))

reason_table <- table(no_trip_data$WHYNO) / length(no_trip_data$WHYNO) * 100
reason_df <- as.data.frame(reason_table)
colnames(reason_df) <- c("Reason_Code", "Percentage")

reason_descriptions <- c(
  "1" = "Personally sick",
  "2" = "Vacation or personal day",
  "3" = "Caretaking sick kids",
  "4" = "Caretaking sick other",
  "5" = "Homebound elderly or disabled",
  "6" = "Worked at home for pay",
  "7" = "Not scheduled to work",
  "8" = "Worked around home (not for pay)",
  "9" = "No transportation available",
  "10" = "Out of Delaware Valley region",
  "11" = "Weather",
  "12" = "No reason to travel",
  "97" = "Other",
  "98" = "Don't know",
  "99" = "Refused"
)

reason_df$Reason <- reason_descriptions[as.character(reason_df$Reason_Code)]

write.csv(reason_df, "no_trip_reasons_percentage.csv", row.names = FALSE)

print(reason_df)

ggplot(reason_df, aes(x = Reason, y = Percentage, fill = Reason)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Reason for No Trip", y = "Percentage", fill = "Reason", title = "Percentage of No Trips by Reason")


'q4'

load("Q:/r coding/hw5/hw5/part 2/data.Rda") 

hrt_ridership <- dat$rider[dat$hrt_d == 1]

log_hrt_ridership <- log(hrt_ridership + 1)

x_min <- min(hrt_ridership)
x_max <- max(hrt_ridership)
log_x_min <- min(log_hrt_ridership)
log_x_max <- max(log_hrt_ridership)

hist(hrt_ridership, main = "Histogram of Heavy Rail Ridership", xlab = "Ridership", col = "red", xlim = c(x_min, x_max), breaks = 50)

hist(log_hrt_ridership, main = "Histogram of Log of Heavy Rail Ridership", xlab = "Log(Ridership)", col = "orange", xlim = c(log_x_min, log_x_max), breaks = 50)


'q5'

jobs_halfmile_hrt <- dat$jobs_halfmile[dat$hrt_d == 1]

ggplot(data = dat[dat$hrt_d == 1,], aes(x = jobs_halfmile, y = hrt_ridership)) +
  geom_point(alpha = 0.5, color = "blue") +
  labs(title = 'Scatter Plot of Heavy Rail Ridership vs Jobs within Half a Mile',
       x = 'Jobs within Half a Mile',
       y = 'Heavy Rail Ridership') +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) 


'q6'

heavy_rail_data <- dat[dat$hrt_d == 1, ]

heavy_rail_data$log_rider <- log(heavy_rail_data$rider + 1)
heavy_rail_data$log_pop_halfmile <- log(heavy_rail_data$pop_halfmile + 1)

ggplot(heavy_rail_data, aes(x = log_pop_halfmile, y = log_rider)) +
  geom_point(alpha = 0.5, color = "blue") +
  labs(title = 'Scatter Plot of Log of Heavy Rail Ridership vs Log of Population within Half a Mile',
       x = 'Log of Population within Half a Mile',
       y = 'Log of Heavy Rail Ridership') +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


'q7'

hrt_ridership <- dat$rider[dat$hrt_d == 1]
jobs_halfmile_hrt <- dat$jobs_halfmile[dat$hrt_d == 1]
pop_halfmile_hrt <- dat$pop_halfmile[dat$hrt_d == 1]
terminal_hrt <- dat$terminal_d[dat$hrt_d == 1]
airport_hrt <- dat$airport_d[dat$hrt_d == 1]

heavy_rail_data <- dat[dat$hrt_d == 1, c('rider', 'jobs_halfmile', 'pop_halfmile', 'terminal_d', 'airport_d')]

heavy_rail_data$log_rider <- log(heavy_rail_data$rider + 1)
heavy_rail_data$log_jobs_halfmile <- log(heavy_rail_data$jobs_halfmile + 1)
heavy_rail_data$log_pop_halfmile <- log(heavy_rail_data$pop_halfmile + 1)

model <- lm(log_rider ~ log_jobs_halfmile + log_pop_halfmile + terminal_d + airport_d, data = heavy_rail_data)

model_summary <- summary(model)
print(model_summary)

sink("model_summary.txt")
print(model_summary)
sink()


'q8'

par(mfrow=c(2,2)) 
plot(model) 

png("model_diagnostic_plots.png")
plot(model)
dev.off()

model_residuals <- residuals(model)

qqnorm(model_residuals)
qqline(model_residuals, col = "steelblue", lwd = 2)

png("residuals_qqplot.png")
qqnorm(model_residuals)
qqline(model_residuals, col = "steelblue", lwd = 2)
dev.off()


'q9'

predicted_values <- predict(model, heavy_rail_data) 
residuals <- heavy_rail_data$log_rider - predicted_values 

residuals_df <- data.frame(Predicted = predicted_values, Residuals = residuals)

p <- ggplot(residuals_df, aes(x = Predicted, y = Residuals)) +
  geom_point(alpha = 0.5) + 
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Predicted", x = "Predicted Log-Ridership", y = "Residuals") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

print(p)

ggsave("residuals_vs_predicted.png", plot = p, width = 10, height = 6)


'q10'

heavy_rail_data <- dat[dat$hrt_d == 1, c('rider', 'jobs_halfmile', 'pop_halfmile', 'terminal_d', 'airport_d', 'hrt_d')]

heavy_rail_data$log_rider <- log(heavy_rail_data$rider + 1)
heavy_rail_data$log_jobs_halfmile <- log(heavy_rail_data$jobs_halfmile + 1)
heavy_rail_data$log_pop_halfmile <- log(heavy_rail_data$pop_halfmile + 1)

updated_model <- lm(log_rider ~ log_jobs_halfmile + log_pop_halfmile + terminal_d + airport_d + hrt_d, data = heavy_rail_data)

updated_model_summary <- summary(updated_model)
print(updated_model_summary)

old_adj_r_squared <- model_summary$adj.r.squared
new_adj_r_squared <- updated_model_summary$adj.r.squared

cat("Old Model - Adjusted R-squared:", old_adj_r_squared, "\n")
cat("Updated Model - Adjusted R-squared:", new_adj_r_squared, "\n")

if (new_adj_r_squared > old_adj_r_squared) {
  cat("Adding the heavy rail dummy variable (hrt_d) improved the model.\n")
} else {
  cat("Adding the heavy rail dummy variable (hrt_d) did not improve the model.\n")
}

sink("updated_model_summary.txt")
print(updated_model_summary)
sink()



