import cv2
from pyzbar.pyzbar import decode
import datetime
import mysql.connector
import re
import numpy as np
from kivy.app import App
from kivy.uix.image import Image
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.widget import Widget
from kivy.clock import Clock
from kivy.graphics.texture import Texture

# Define the cutoff time for being "late" (in 24-hour format)
cutoff_time = datetime.datetime.strptime("09:30:00", "%H:%M:%S")  # 09:30:00 in 24-hour format

# Define the valid roll number ranges for different classes/sections
valid_roll_number_ranges = [
    (111001, 111030),
    (112001, 112030),
    (121001, 121030),
    (122001, 122030)
]

# Function to validate roll number format (6 digits) and check if it's within the valid range
def is_valid_roll_number(roll_number):
    pattern = re.compile(r'^\d{6}$')
    if not pattern.match(roll_number):
        return False
    
    roll_number_int = int(roll_number)
    
    # Check if the roll number falls within the valid range
    for start, end in valid_roll_number_ranges:
        if start <= roll_number_int <= end:
            return True
    
    return False

# Function to connect to the MySQL database
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",      # Replace with your MySQL server address if needed
        user="root",  # Replace with your MySQL username
        password="acadease27",  # Replace with your MySQL password
        database="day_att"   # Database name
    )

# Function to log student attendance into MySQL
def log_student_in(roll_number):
    current_time = datetime.datetime.now()
    current_time_24hr = current_time.strftime("%H:%M:%S")  # 24-hour format time
    date_str = current_time.strftime("%Y-%m-%d")  # YYYY-MM-DD format

    # Connect to the MySQL database
    conn = get_db_connection()
    cursor = conn.cursor()

    # Check if the student is already marked as present for today
    cursor.execute("SELECT * FROM day_attendance WHERE roll_number = %s AND date = %s", (roll_number, date_str))
    existing_record = cursor.fetchone()

    if existing_record:
        print(f"Student {roll_number} has already been marked as present today.")
        cursor.close()
        conn.close()
        return

    # Check if the student is late or on time
    if datetime.datetime.strptime(current_time_24hr, "%H:%M:%S") > cutoff_time:
        status = 'Late Comer'
    else:
        status = 'On Time'

    # Insert the attendance record into the database
    cursor.execute(
        "INSERT INTO day_attendance (roll_number, time, date, status) VALUES (%s, %s, %s, %s)",
        (roll_number, current_time_24hr, date_str, status)
    )

    # Commit the transaction and close the connection
    conn.commit()
    cursor.close()
    conn.close()

    print(f"Student {roll_number} logged in at {current_time} as {status}.")

# Kivy App Class
class QRScannerApp(App):
    def build(self):
        self.capture = None  # Initialize capture as None
        
        # Root layout for the app
        self.layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # Create the initial logo image widget (this will be shown initially)
        self.image = Image(source='Acadeaselogo.png')  # Show the logo initially
        self.layout.add_widget(self.image)

        # Create the Start Scanning button
        self.button = Button(text="Start Scanning", size_hint=(None, None), size=(200, 50))
        
        # Set the button color (RGBA format)
        self.button.background_color = [0.6, 0.921568627, 1, 1]  # Light blue color
        self.button.bind(on_press=self.start_scanning)

        # Create a BoxLayout for the button and align it to the right
        button_layout = BoxLayout(size_hint=(1, None), height=50, orientation='horizontal')
        button_layout.add_widget(Widget())  # Empty Widget for centering
        button_layout.add_widget(self.button)  # Add the button
        button_layout.add_widget(Widget())  # Empty Widget for centering

        # Add the button layout (aligned right) to the main layout
        self.layout.add_widget(button_layout)

        return self.layout

    def start_scanning(self, instance):
        """Start the QR code scanning process."""
        print("Scanning started...")

        # Initialize webcam capture only when the button is pressed
        self.capture = cv2.VideoCapture(0)  
        
        # Disable the button once scanning is started
        self.button.disabled = True  

        # Clear the current layout (to remove the logo image)
        self.layout.clear_widgets()

        # Add the camera feed placeholder before adding the webcam feed
        self.image = Image()  # This image widget will show the webcam feed
        self.layout.add_widget(self.image)

        # Start the OpenCV update clock
        Clock.schedule_interval(self.update_frame, 1.0 / 30.0)  # 30 FPS update

    def update_frame(self, dt):
        """Update the frame from the webcam and process QR codes."""
        ret, frame = self.capture.read()

        if ret:
            # Rotate the frame (180 degrees)
            frame = cv2.rotate(frame, cv2.ROTATE_180)

            # Decode QR codes from the rotated frame
            decoded_objects = decode(frame)
            for obj in decoded_objects:
                roll_number = obj.data.decode('utf-8')
                if is_valid_roll_number(roll_number):
                    log_student_in(roll_number)  # Log the student in based on QR code data
                    points = obj.polygon
                    if len(points) == 4:
                        pts = [tuple(point) for point in points]
                        cv2.polylines(frame, [np.array(pts, dtype=np.int32)], isClosed=True, color=(0, 255, 0), thickness=2)
                        cv2.putText(frame, roll_number, (pts[0][0], pts[0][1] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)
                else:
                    # If the roll number is invalid, print a message
                    print(f"Invalid QR code: {roll_number} (not in valid roll number range).")

            # Convert the frame to texture to display in Kivy window
            buf = frame.tostring()
            texture = Texture.create(size=(frame.shape[1], frame.shape[0]), colorfmt='bgr')
            texture.blit_buffer(buf, colorfmt='bgr', bufferfmt='ubyte')
            self.image.texture = texture

    def on_stop(self):
        """Release the capture when the application is closed."""
        if self.capture:
            self.capture.release()

if __name__ == "__main__":
    QRScannerApp().run()
