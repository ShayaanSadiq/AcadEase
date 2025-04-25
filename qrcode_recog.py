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
import pymysql
pymysql.install_as_MySQLdb()

# Define the cutoff time for being "late"
cutoff_time = datetime.datetime.strptime("09:30:00", "%H:%M:%S")

# Define valid roll number ranges
valid_roll_number_ranges = [
    (111001, 111030),
    (112001, 112030),
    (121001, 121030),
    (122001, 122030),
]

# Function to validate roll number format and range
def is_valid_roll_number(roll_number):
    pattern = re.compile(r"^\d{6}$")
    if not pattern.match(roll_number):
        return False
    roll_number_int = int(roll_number)
    for start, end in valid_roll_number_ranges:
        if start <= roll_number_int <= end:
            return True
    return False

# Function to connect to the MySQL database
def get_db_connection():
    try:
        return mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="studentdb",
        )
    except mysql.connector.Error as e:
        print(f"Database connection error: {e}")
        return None

# Function to log student attendance into MySQL
def log_student_in(roll_number):
    current_time = datetime.datetime.now()
    time_str = current_time.strftime("%H:%M:%S")
    date_str = current_time.strftime("%Y-%m-%d")

    conn = get_db_connection()
    if not conn:
        return
    cursor = conn.cursor()

    try:
        # Check if already marked
        cursor.execute(
            "SELECT * FROM day_attendance WHERE roll_number = %s AND date = %s",  # Updated column name
            (roll_number, date_str),
        )
        if cursor.fetchone():
            print(f"Student {roll_number} already marked as present.")
            return

        # Determine attendance status
        status = "Late Comer" if datetime.datetime.strptime(time_str, "%H:%M:%S") > cutoff_time else "On Time"

        # Insert attendance record
        cursor.execute(
            "INSERT INTO day_attendance (roll_number, time, date, status) VALUES (%s, %s, %s, %s)",  # Updated column name
            (roll_number, time_str, date_str, status),
        )
        conn.commit()
        print(f"Student {roll_number} logged in as {status}.")
    except mysql.connector.Error as e:
        print(f"Error logging student: {e}")
    finally:
        cursor.close()
        conn.close()

# Kivy App Class
class QRScannerApp(App):
    def build(self):
        self.capture = None

        # Main layout
        self.layout = BoxLayout(orientation="vertical", padding=10, spacing=10)

        # Logo
        self.image = Image(source="Acadeaselogo.png")
        self.layout.add_widget(self.image)

        # Start scanning button
        self.button = Button(text="Start Scanning", size_hint=(None, None), size=(200, 50))
        self.button.background_color = [0.6, 0.92, 1, 1]
        self.button.bind(on_press=self.start_scanning)

        # Button layout
        button_layout = BoxLayout(size_hint=(1, None), height=50, orientation="horizontal")
        button_layout.add_widget(Widget())
        button_layout.add_widget(self.button)
        button_layout.add_widget(Widget())
        self.layout.add_widget(button_layout)

        # Schedule attendance table cleanup
        Clock.schedule_once(self.clean_attendance_table, 86400)  # Run after 24 hours
        return self.layout

    def start_scanning(self, instance):
        print("Scanning started...")
        self.capture = cv2.VideoCapture(0)
        self.button.disabled = True
        self.layout.clear_widgets()

        # Webcam feed
        self.image = Image()
        self.layout.add_widget(self.image)
        Clock.schedule_interval(self.update_frame, 1.0 / 30.0)  # 30 FPS

    def update_frame(self, dt):
        if not self.capture:
            return
        ret, frame = self.capture.read()
        if ret:
            frame = cv2.rotate(frame, cv2.ROTATE_180)
            decoded_objects = decode(frame)
            for obj in decoded_objects:
                roll_number = obj.data.decode("utf-8")
                if is_valid_roll_number(roll_number):
                    log_student_in(roll_number)
                    points = obj.polygon
                    if len(points) == 4:
                        pts = [tuple(point) for point in points]
                        cv2.polylines(frame, [np.array(pts, dtype=np.int32)], True, (0, 255, 0), 2)
                        cv2.putText(
                            frame,
                            roll_number,
                            (pts[0][0], pts[0][1] - 10),
                            cv2.FONT_HERSHEY_SIMPLEX,
                            0.9,
                            (0, 255, 0),
                            2,
                        )
                else:
                    print(f"Invalid QR code: {roll_number}")

            buf = frame.tobytes()
            texture = Texture.create(size=(frame.shape[1], frame.shape[0]), colorfmt="bgr")
            texture.blit_buffer(buf, colorfmt="bgr", bufferfmt="ubyte")
            self.image.texture = texture

    def clean_attendance_table(self, dt=None):
        conn = get_db_connection()
        if not conn:
            return
        cursor = conn.cursor()
        try:
            cursor.execute("DELETE FROM day_attendance")
            conn.commit()
            print("Attendance table cleaned.")
        except mysql.connector.Error as e:
            print(f"Error cleaning attendance table: {e}")
        finally:
            cursor.close()
            conn.close()
        Clock.schedule_once(self.clean_attendance_table, 86400)

    def on_stop(self):
        if self.capture:
            self.capture.release()

if __name__ == "__main__":
    QRScannerApp().run()
