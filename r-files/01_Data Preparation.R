# Data Preparation

# List all sheets in the Excel file
sheets <- excel_sheets(file_destination)
print(sheets)

# Read a specific sheet by name or by index
data_sheet1 <- read_excel(file_destination, sheet = sheets[1])  # Replace 1 with the index of the sheet you want
