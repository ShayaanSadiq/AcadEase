from unittest import result
import pymysql
from flask import Flask, g, jsonify, request
from datetime import datetime
from flask_cors import CORS
import logging

# Configure logging for debugging
logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)


def get_db_connection():
    try:
        logging.debug("Establishing database connection.")
        conn = pymysql.connect(
            host="localhost",
            user="root",
            password="acadease27",
            database="day_att"
        )
        logging.debug("Database connection established.")
        return conn
    except Exception as e:
        logging.error(f"Failed to connect to database: {e}")
        raise

@app.route('/login', methods=['POST'])
def login():
    g.data = request.json
    username = g.data.get('username')
    password = g.data.get('password')

    if not username or not password:
        logging.warning("Username or password missing in the request.")
        return jsonify({"error": "Username and password are required"}), 400

    try:
        logging.debug(f"Attempting login for username: {username}")
        conn = get_db_connection()
        cursor = conn.cursor()

        query = """
        SELECT * FROM parent_cred 
        WHERE TRIM(user_name) = %s COLLATE utf8mb4_general_ci 
        AND TRIM(password) = %s COLLATE utf8mb4_general_ci
        """
        cursor.execute(query, (username, password))
        result = cursor.fetchone()

        if result:
            logging.info("Login successful for username: {}".format(username))
            return jsonify({"status": "success", "message": "Login successful"}), 200
        else:
            logging.warning("Invalid username or password.")
            return jsonify({"status": "failure", "message": "Invalid username or password"}), 401
    except Exception as e:
        logging.error(f"Failed to process login: {e}")
        return jsonify({"error": f"Failed to process login: {e}"}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/student_details', methods=['POST'])
def student_details():
    data = request.json
    rollno = data.get('rollno')

    if not rollno:
        logging.warning("Roll number is missing in the request.")
        return jsonify({"error": "Roll number is required"}), 400

    try:
        # Try parsing the rollno to an integer and print the value
        logging.debug(f"Roll number received: {rollno}")

        try:
            rollno = int(rollno)  # Convert rollno to integer if it's in string format
            logging.debug(f"Converted roll number to integer: {rollno}")
        except ValueError:
            logging.warning("Invalid roll number format.")
            return jsonify({"error": "Invalid roll number format"}), 400

        conn = get_db_connection()
        cursor = conn.cursor()

        # Determine the table based on the roll number
        table_name = ''
        if 111001 <= rollno <= 111030:
            table_name = 'elevena'
        elif 112001 <= rollno <= 112030:
            table_name = 'elevenb'
        elif 121001 <= rollno <= 121030:
            table_name = 'twelvea'
        elif 122001 <= rollno <= 122030:
            table_name = 'twelveb'
        else:
            logging.warning(f"Invalid roll number: {rollno}")
            return jsonify({"error": "Invalid roll number"}), 400

        # Fetch student details
        student_query = f"""
            SELECT `rollno`, `Name`, `Class/Section`, `DOB`, `Fathers Name`, `Mothers Name`,
            `Father Email Address`, `Father Mobile Number`, `Mothers Email Address`,
            `Mothers Phone Number`, `Student Email Address`, `Student Phone Number`, `address`
            FROM {table_name}
            WHERE rollno = %s
        """
        cursor.execute(student_query, (rollno,))
        student = cursor.fetchone()
        
        if student:
            student_data = {
                "rollno": student[0],
                "name": student[1],
                "class_section": student[2],
                "dob": student[3],
                "father_name": student[4],
                "mother_name": student[5],
                "father_email": student[6],
                "father_mobile": student[7],
                "mother_email": student[8],
                "mother_mobile": student[9],
                "student_email": student[10],
                "student_mobile": student[11],
                "address": student[12],
            }
            return jsonify(student_data)
        else:
            logging.warning(f"No student found with rollno: {rollno}")
            return {"error": "Student not found."}

    except Exception as e:
        logging.error(f"Failed to fetch student details: {str(e)}")
        return jsonify({"error": "Failed to fetch student details."}), 500
    finally:
        cursor.close()
        conn.close()



@app.route('/tlogin', methods=['POST'])
def tlogin():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        logging.warning("Username or password missing in the teacher login request.")
        return jsonify({"error": "Username and password are required"}), 400

    try:
        logging.debug(f"Attempting teacher login for username: {username}")
        conn = get_db_connection()
        cursor = conn.cursor()

        # Query to match username and password
        query = """
        SELECT * FROM teacher_cred 
        WHERE TRIM(user_name) = %s COLLATE utf8mb4_general_ci 
        AND TRIM(password) = %s COLLATE utf8mb4_general_ci
        """
        cursor.execute(query, (username, password))
        result = cursor.fetchone()

        if result:
            logging.info("Teacher login successful.")
            return jsonify({"status": "success", "message": "Login successful"}), 200
        else:
            logging.warning("Invalid teacher credentials.")
            return jsonify({"status": "failure", "message": "Invalid username or password"}), 401
    except Exception as e:
        logging.error(f"Error during teacher login: {e}")
        return jsonify({"error": "Failed to process login"}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/get_logged_in_students', methods=['GET'])
def get_logged_in_students():
    class_section = request.args.get('class')  # Get class/section from query parameter
    table_name = class_section.lower()  # Convert class to lowercase to match table names (11a, 11b, etc.)

    # Validate the input class/section
    valid_classes = ['elevena', 'elevenb', 'twelvea', 'twelveb']
    if table_name not in valid_classes:  # Check if class/section is valid
        logging.warning(f"Invalid class section provided: {class_section}")
        return jsonify({"error": "Invalid class section"}), 400

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Query to fetch roll numbers of students who are logged in (status = 'logged_in')
        query = f"""
        SELECT s.rollno 
        FROM {table_name} AS s
        JOIN day_attendance AS da ON s.rollno = da.rollno
        WHERE da.status IN ('On Time', 'Late Comer')
        """
        cursor.execute(query)
        students = cursor.fetchall()

        logging.debug(f"Fetched logged-in students for class: {class_section}")
        return jsonify([{'rollNumber': student[0]} for student in students])
    except Exception as e:
        logging.error(f"Error fetching logged-in students: {e}")
        return jsonify({"error": "Failed to fetch students"}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/mark_absent', methods=['POST'])
def mark_absent():
    data = request.json
    absentees = data.get('absentees', [])  # List of absent students
    class_section = data.get('class')     # Selected class/section
    period = data.get('period')           # Selected period (1-6)
    
    if not class_section or not period:
        logging.warning("Class section or period missing in the absentee marking request.")
        return jsonify({"error": "Class section and period are required"}), 400

    # Determine table name for the class/section
    class_mapping = {
        'elevena': 'period11a',
        'elevenb': 'period11b',
        'twelvea': 'period12a',
        'twelveb': 'period12b'
    }
    table_name1 = class_mapping.get(class_section.lower())

    if not table_name1:
        logging.warning(f"Invalid class section: {class_section}")
        return jsonify({"error": "Invalid class section"}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    today_date = datetime.now().strftime('%Y-%m-%d')  # Get today's date in 'YYYY-MM-DD' format
    period_column = f"{period}"              # Format period column name (e.g., period_1)

    try:
        # Mark students who are not logged in as 'A' for all periods
        not_logged_in_query = f"""
        SELECT s.rollno 
        FROM {class_section} AS s
        LEFT JOIN day_attendance AS da ON s.rollno = da.rollno
        WHERE da.status NOT IN ('On Time', 'Late Comer') OR da.status IS NULL
        """
        cursor.execute(not_logged_in_query)
        not_logged_in_students = [row[0] for row in cursor.fetchall()]

        # Mark absentees selected by the teacher as 'A'
        for roll_number in absentees + not_logged_in_students:
            cursor.execute(f"""
                UPDATE {table_name1}
                SET {period_column} = 'A', date = %s
                WHERE rollno = %s
            """, (today_date, roll_number))

        # Mark remaining students as 'P'
        remaining_students_query = f"""
        UPDATE {table_name1}
        SET {period_column} = 'P', date = %s
        WHERE {period_column} IS NULL
        """
        cursor.execute(remaining_students_query, (today_date,))
        
        conn.commit()
        logging.debug(f"Attendance for period {period} updated successfully.")
    except Exception as e:
        logging.error(f"Error marking attendance: {e}")
        return jsonify({"error": "Failed to update attendance"}), 500
    finally:
        cursor.close()
        conn.close()

    return jsonify({"message": "Attendance updated successfully"})

@app.route('/announcements', methods=['GET'])
def get_announcements():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT subject, desc, date FROM announcements ORDER BY date DESC")
        announcements = cursor.fetchall()
        conn.close()
        if not announcements:
            return jsonify({"message": "No announcements available"})
        return jsonify(announcements)
    except Exception as e:
        return jsonify({"error": str(e)})


# Set up logging for debugging
logging.basicConfig(level=logging.DEBUG)

@app.route('/add_leave', methods=['POST'])
def add_leave():
    try:
        logging.debug("Request data: %s", request.json)
        
        # Get data from the request
        rollno = request.json.get('rollno')
        desc = request.json.get('desc')
        duration = request.json.get('duration')
        
        # Validate parameters
        if not rollno or not desc or not duration:
            return jsonify({"error": "Missing required parameters"}), 400

        # Connect to the database
        connection = get_db_connection()
        cursor = connection.cursor()

        # Insert data into leavep table
        query = "INSERT INTO leavep (rollno, `desc`, duration) VALUES (%s, %s, %s)"
        cursor.execute(query, (rollno, desc, duration))

        # Commit the transaction
        connection.commit()

        # Close the connection
        cursor.close()
        connection.close()

        return jsonify({"message": "Leave added successfully"}), 201

    except pymysql.MySQLError as e:
        logging.error(f"MySQL error: {str(e)}")
        return jsonify({"error": f"MySQL error: {str(e)}"}), 500
    except Exception as e:
        logging.error(f"An unexpected error occurred: {str(e)}")
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

@app.route('/marksheet', methods=['GET'])
def get_marksheet():
    username = request.headers.get('Username')
    if not username:
        return jsonify({"error": "Username is required"}), 400

    try:
        conn = pymysql.connect(
            host='localhost',
            user='root',
            password='acadease27',
            database='day_att',
        )

        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            query = "SELECT * FROM marksheet WHERE rollno = %s LIMIT 1"
            cursor.execute(query, (username,))
            result = cursor.fetchone()  # Fetch only one record

            if not result:
                return jsonify({"error": "No records found for the given username"}), 404

            return jsonify(result)  # Return a single record

    except pymysql.MySQLError as db_error:
        print(f"Database Error: {db_error}")
        return jsonify({"error": "Database error occurred"}), 500

    except Exception as e:
        print(f"Unexpected Error: {e}")
        return jsonify({"error": "An unexpected error occurred"}), 500

    finally:
        conn.close()


@app.route('/add_concern', methods=['POST'])
def add_concern():
    try:
        # Parse JSON data from the frontend
        data = request.json
        rollno = data.get('rollno')
        date = data.get('date')
        subject = data.get('subject')
        description = data.get('desc')

        # Validate the required fields
        if not rollno or not date or not subject or not description:
            return jsonify({'message': 'All fields are required.'}), 400

        # Connect to the MySQL database
        conn = get_db_connection()  # Reuse the `get_db_connection` function
        cursor = conn.cursor()

        # Insert data into the concerns table
        query = """
            INSERT INTO concerns (rollno, date, subject, `desc`)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query, (rollno, date, subject, description))
        conn.commit()

        # Close the database connection
        cursor.close()
        conn.close()

        return jsonify({'message': 'Concern added successfully.'}), 201

    except pymysql.MySQLError as err:
        logging.error(f"Database Error: {err}")
        return jsonify({'message': 'Database error occurred.'}), 500

    except Exception as e:
        logging.error(f"Error: {e}")
        return jsonify({'message': 'An error occurred.'}), 500


if __name__ == '__main__':
    app.run(debug=True)

