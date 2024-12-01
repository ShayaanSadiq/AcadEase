import datetime
import csv
current_time = datetime.datetime.now()
login_time = current_time.strftime("%I:%M:%S %p")
cutoff_time = datetime.datetime.strptime("06:00:00 AM", "%H:%M:%S %p")
cutoff_time1=cutoff_time.strftime("%H:%M:%S %p")
time_str = current_time.strftime("%I:%M:%S %p")
print(login_time)
print(cutoff_time1)
print(time_str)
with open('attendance.csv', 'r', newline='') as f:
            reader = csv.reader(f)
            rows = list(reader)  # Convert the reader object to a list of rows

            # Check if the roll number already exists in the attendance file
            for row in rows:
                if len(row) >= 4 and row[0] == roll_number:  # Ensure there are at least 4 columns
                    # Get the last login date and time for this roll number
                    last_login_date = row[2]