### Bike Sales Dashboard

This repository contains an Excel-based dashboard for analyzing bike sales data. The project provides key insights into customer demographics and their purchasing behavior.

---

### Project Overview

The **Bike Sales Dashboard** is a dynamic and interactive tool built in Excel to visualize customer data and track bike purchasing trends. It provides a quick and effective way to understand the factors influencing a customer's decision to purchase a bike, such as their income, age, gender, and commute distance.

### Data Source

The primary data source is the `bike_buyers.csv` file, which contains detailed customer information. The following columns are included in the dataset:

* **ID**: Unique customer identifier.
* **Marital Status**: Marital status of the customer.
* **Gender**: Gender of the customer.
* **Income**: Annual income of the customer.
* **Children**: Number of children the customer has.
* **Education**: Customer's highest level of education.
* **Occupation**: The customer's occupation.
* **Home Owner**: Indicates if the customer owns a home.
* **Cars**: Number of cars owned by the customer.
* **Commute Distance**: The distance the customer commutes to work.
* **Region**: Geographic region of the customer.
* **Age**: The customer's age.
* **Age Brackets**: The customer's age grouped into categories (Adolescent, Middle Age, Old).
* **Purchased Bike**: Indicates whether the customer purchased a bike (Yes/No).

The `Working Sheet.csv` file is a working copy of the data, which includes the `Age Brackets` column for further analysis. The `Detail1.csv` sheet contains a filtered view of the data, showing a specific customer segment (Female customers who purchased a bike).

### Key Metrics and Insights

The dashboard is built on a series of pivot tables (`Pivot Table.csv`) that aggregate the raw data to reveal important trends. Key metrics and insights include:

* **Average Income vs. Purchase Status**: Compares the average income of customers who purchased a bike against those who didn't, broken down by gender.
* **Purchase Count by Commute Distance**: Shows the number of bike purchases based on the customer's commute distance.
* **Purchase Count by Age Bracket**: Displays the total number of bike purchases across different age groups.

These metrics allow for a data-driven understanding of the target customer base.

---

### Dashboard Components

The final dashboard (`Dashboard.csv`) is designed for ease of use and visual impact. It contains interactive charts and slicers to allow for dynamic filtering and exploration of the data based on the key metrics identified above. While the CSV export of the dashboard is empty, in its native Excel format, it would display a series of charts summarizing the insights from the pivot tables, offering a clear and concise view of the bike sales performance.
