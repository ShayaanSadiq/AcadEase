import cv2
from pyzbar.pyzbar import decode
import datetime
import csv
import re
import numpy as np

# Define the cutoff time for being "late" (in 24-hour format)
cutoff_time = datetime.datetime.strptime("09:30:00 AM", "%H:%M:%S %p")
cutoff_time1=cutoff_time.strftime("%H:%M:%S %p") 

# Function to validate roll number format (6 digits)
def is_valid_roll_number(roll_number):
    pattern = re.compile(r'^\d{6}$')
    return bool(pattern.match(roll_number))

def log_student_in(roll_number):
    current_time = datetime.datetime.now()
    time_str = current_time.strftime("%I:%M:%S %p")  # 24-hour format
    date_str = current_time.strftime("%Y-%m-%d")  # YYYY-MM-DD format

    # Open the CSV file to read previous logins and avoid duplicates
    try:
        with open('attendance.csv', 'r', newline='') as f:
            reader = csv.reader(f)
            rows = list(reader)  # Convert the reader object to a list of rows

            # Check if the roll number already exists in the attendance file
            for row in rows:
                if len(row) >= 4 and row[0] == roll_number:  # Ensure there are at least 4 columns
                    # Get the last login date and time for this roll number
                    last_login_date = row[2]

                    # Check if the student is trying to log in on the same day
                    if last_login_date == date_str:
                        print(f"Student {roll_number} has already been marked as present today.")
                        return  # If already logged in today, do nothing

                    # If the login is on a different day, allow it
                    print(f"Student {roll_number} logging in for a new day ({date_str}).")

    except FileNotFoundError:
        # If the file does not exist, it's the first login attempt, create the file and add headers
        with open('attendance.csv', 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['roll_number', 'time', 'date', 'status'])  # Add headers to the CSV
            pass
    
    # Log the student's roll number and timestamp if they are not already marked as present
    login_time = current_time.strftime("%H:%M:%S %p")
    
    # Check if the student is late or on time
    if time_str > cutoff_time1:
        status = 'Late Comer'
    else:
        status = 'On Time'

    with open('attendance.csv', 'a', newline='') as f:
        writer = csv.writer(f)
        # Write roll number, login time, date, and status
        writer.writerow([roll_number, login_time, date_str, status])  # Log the status immediately
    print(f"Student {roll_number} logged in at {current_time} as {status}.")

# Initialize the webcam
cap = cv2.VideoCapture(0)

while True:
    # Capture frame-by-frame
    ret, frame = cap.read()

    # Decode the QR code
    decoded_objects = decode(frame)

    # Loop through all detected QR codes
    for obj in decoded_objects:
        roll_number = obj.data.decode('utf-8')

        # Validate if the QR code contains a valid roll number (6 digits)
        if is_valid_roll_number(roll_number):
            # Log the student in if they are eligible
            log_student_in(roll_number)
            
            # Draw a rectangle around the QR code and display the roll number
            points = obj.polygon
            if len(points) == 4:
                pts = [tuple(point) for point in points]
                cv2.polylines(frame, [np.array(pts, dtype=np.int32)], isClosed=True, color=(0, 255, 0), thickness=2)
                cv2.putText(frame, roll_number, (pts[0][0], pts[0][1] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
        else:
            # If the QR code is not a valid roll number, ignore it
            print(f"Invalid QR Code detected: {roll_number}")

    # Display the resulting frame
    cv2.imshow("QR Code Scanner", frame)

    # Exit if 'q' is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the capture and close any OpenCV windows
cap.release()
cv2.destroyAllWindows()
