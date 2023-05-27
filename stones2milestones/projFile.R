library(dplyr)
library(tidyr)

# Importing Interested Users sheet from workbook
interested_user <- readxl::read_excel('../datasets/assignment_data.xlsx', 
                                      sheet = 'Interested Users') %>% 
  unique() %>% 
  mutate(`Submitted At` = lubridate::ymd_hms(`Submitted At`))

# Total interested users
nrow(interested_user)
# Variables this data frame have:
colnames(interested_user)

# Importing Booked Users sheet from workbook & selecting only unique instances for analysis
booked_user <- readxl::read_excel('../datasets/assignment_data.xlsx', 
                                  sheet = 'Booked Users') %>% 
  unique() %>% 
  mutate(`Booked Time` = lubridate::dmy_hms(`Booked Time`))


# Total Bookings made
nrow(booked_user)
# Variables this data frame have:
colnames(booked_user)

# Importing Trainers sheet from workbook
trainers <- readxl::read_excel('../datasets/assignment_data.xlsx', 
                               sheet = 'Trainers') %>% 
  unique()


# Total Trainer's Observation
nrow(trainers)
# Variables this data frame have:
colnames(trainers)


# Importing Subscription Bought sheet from workbook & filtering out only those observations where price is greater than Rs.499.
subscription_bought <- readxl::read_excel('../datasets/assignment_data.xlsx',
                                          sheet = 'Subscription Bought') %>% 
  filter(Pricing > 499) %>% 
  mutate(
    `Payment date` = lubridate::as_datetime(`Payment date`, 
                                            format="%d-%m-%Y %H:%M:%S %p"))


# Note: In the data frame, NAs exist for Payment date
subscription_bought$`Payment date` %>% is.na() %>% sum()
# Number of observation for subscription bought
nrow(subscription_bought)
# Variables this data frame have:
colnames(subscription_bought)


# Final data frame
interested_user %>% 
  # Joining Interested data frame with booked_user data frame using email-id and phone number.
  full_join(booked_user, 
            by = join_by(
              phone==Phone, 
              email_id==`Parent Email`,
              grade==Grade)) %>% 
  # Joining the existing data frame with subscription_bought data frame using phone number and email-id.
  full_join(subscription_bought,
            by = join_by(
              phone==`Registered Number`,
              email_id==`Registered Email ID`)) %>% 
  View()
 

 