import pymysql
from flask import Flask, jsonify, request
from datetime import datetime
from flask_cors import CORS 

app = Flask(__name__)
CORS(app)

# MySQL connection function using PyMySQL
def get_db_connection():
    return pymysql.connect(
        host="localhost",         # Replace with your MySQL host
        user="root",              # Replace with your MySQL username
        password="acadease27",    # Replace with your MySQL password
        database="day_att"        # Replace with your database name
    )

# Route to fetch logged-in students for the selected class/section
@app.route('/get_logged_in_students', methods=['GET'])
def get_logged_in_students():
    class_section = request.args.get('class')  # Get class/section from query parameter
    table_name = class_section.lower()  # Convert class to lowercase to match table names (11a, 11b, etc.)

    # Validate the input class/section
    valid_classes = ['elevena', 'elevenb', 'twelvea', 'twelveb']
    if table_name not in valid_classes:  # Check if class/section is valid
        return jsonify({"error": "Invalid class section"}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    # Debug: Print the class/section being used
    print(f"Fetching students from class: {table_name}")

    # Query to fetch roll numbers of students who are logged in (status = 'logged_in')
    query = f"""
    SELECT s.rollno 
    FROM {table_name} AS s
    JOIN day_attendance AS da ON s.rollno = da.rollno
    WHERE da.status IN ('On Time', 'Late Comer')
    """
    print(f"Executing query: {query}")  # Debug: print query

    cursor.execute(query)

    students = cursor.fetchall()

    # Debug: Print the fetched students
    print(f"Fetched students: {students}")

    cursor.close()
    conn.close()

    # Returning student roll numbers as JSON
    return jsonify([{'rollNumber': student[0]} for student in students])

@app.route('/mark_absent', methods=['POST'])
def mark_absent():
    data = request.json
    absentees = data['absentees']          # List of absent students
    class_section = data['class']         # Selected class/section
    period = data['period']               # Selected period (1-6)

    if(class_section=='elevena'):
        table_name='period11a'
    elif(class_section=='elevenb'):
        table_name='period11b'
    elif(class_section=='twelvea'):
        table_name='period12a'
    elif(class_section=='twelveb'):
        table_name='period12b'
    else:
        print("Bad input")
    table_name = f"period{class_section.lower()}"    # Format table name (e.g., period11a)

    # Validate class/section and period
    if table_name not in ['period11a', 'period11b', 'period12a', 'period12b']:
        return jsonify({"error": "Invalid class section"}), 400
    if not (1 <= period <= 6):
        return jsonify({"error": "Invalid period"}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    today_date = datetime.now().strftime('%Y-%m-%d')  # Get today's date in 'YYYY-MM-DD' format
    period_column = period   # Column name for the selected period (e.g., period_1, period_2)

    try:
        # Mark absentees as 'A' for the selected period, and set the date to today's date if empty
        for roll_number in absentees:
            cursor.execute(f"""
                UPDATE {table_name}
                SET {period_column} = 'A', date = IF(date IS NULL, %s, date)
                WHERE rollno = %s
            """, (today_date, roll_number))

        # Mark remaining students as 'P', and set the date to today's date if empty
        cursor.execute(f"""
            UPDATE {table_name} 
            SET {period_column} = 'P', date = IF(date IS NULL, %s, date)
            WHERE rollno NOT IN ({','.join(['%s'] * len(absentees))}) 
        """, (*absentees, today_date))

        conn.commit()
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "Failed to update attendance"}), 500
    finally:
        cursor.close()
        conn.close()

    return jsonify({"message": "Attendance updated successfully"})

if __name__ == '__main__':
    app.run(debug=True)

