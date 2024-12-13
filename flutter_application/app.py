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
    try:
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
    except:
        return jsonify({"error": "Failed to fetch students"}), 500

@app.route('/mark_absent', methods=['POST'])
def mark_absent():
    data = request.json
    absentees = data.get('absentees', [])  # List of absent students
    class_section = data.get('class')     # Selected class/section
    period = data.get('period')           # Selected period (1-6)
    
    if not class_section or not period:
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
        return jsonify({"error": "Invalid class section"}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    today_date = datetime.now().strftime('%Y-%m-%d')  # Get today's date in 'YYYY-MM-DD' format
    period_column = period              # Format period column name (e.g., period_1)

    try:
        # 1. Mark students who are not logged in as 'A' for all periods
        not_logged_in_query = f"""
        SELECT s.rollno 
        FROM {class_section} AS s
        LEFT JOIN day_attendance AS da ON s.rollno = da.rollno
        WHERE da.status NOT IN ('On Time', 'Late Comer') OR da.status IS NULL
        """
        cursor.execute(not_logged_in_query)
        not_logged_in_students = [row[0] for row in cursor.fetchall()]
        
        print(f"Not logged-in students: {not_logged_in_students}")  # Debug log
        
        if(cursor.execute(f"""
        select * from {table_name1} where {period_column} is null
        """)): 
           if not_logged_in_students:
                for roll_number in not_logged_in_students:
                     cursor.execute(f"""
                     UPDATE {table_name1}
                        SET {period_column} = 'A', date = %s
                        WHERE rollno = %s
                     """, (today_date, roll_number))

        # 2. Mark absentees selected by the teacher as 'A'
           for roll_number in absentees:
            cursor.execute(f"""
                UPDATE {table_name1}
                SET {period_column} = 'A', date = %s
                WHERE rollno = %s
            """, (today_date, roll_number))

        # 3. Mark remaining students as 'P'
           absentees_combined = not_logged_in_students + absentees
           if absentees_combined:
              absentees_placeholder = ','.join(['%s'] * len(absentees_combined))
              query = f"""
                UPDATE {table_name1} 
                SET {period_column} = 'P', date = %s
                WHERE rollno NOT IN ({absentees_placeholder})
            """
              cursor.execute(query, (today_date, *absentees_combined))
           else:
                cursor.execute(f"""
                UPDATE {table_name1}
                SET {period_column} = 'P', date = %s
                """, (today_date,))
        else:
            return jsonify({"message": "Attendance already updated successfully"})
        conn.commit()
        print(f"Attendance updated for {class_section} in {period_column}")
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "Failed to update attendance"}), 500
    finally:
        cursor.close()
        conn.close()

    return jsonify({"message": "Attendance updated successfully"})


if __name__ == '__main__':
    app.run(debug=True)
