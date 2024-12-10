'''import datetime
import csv
current_time = datetime.datetime.now()
login_time = current_time.strftime("%I:%M:%S %p")
cutoff_time = datetime.datetime.strptime("06:00:00 AM", "%H:%M:%S %p")
cutoff_time1=cutoff_time.strftime("%H:%M:%S %p")
time_str = current_time.strftime("%I:%M:%S %p")
print(login_time)
print(cutoff_time1)
print(time_str)
import random'''

#rng for mobile numbers

'''
# Function to generate a list of 119 random 10-digit numbers starting with 7, 8, or 9
def generate_random_numbers():
    numbers = []
    for _ in range(30):
        first_digit = random.choice([7, 8, 9])
        rest_of_number = ''.join([str(random.randint(0, 9)) for _ in range(9)])
        numbers.append(str(first_digit) + rest_of_number)
    return numbers

random_numbers = generate_random_numbers()
for x in random_numbers:
    print(x)

#random check for what this code does
'''
'''with open('attendance.csv', 'r', newline='') as f:
            reader = csv.reader(f)
            rows = list(reader)  # Convert the reader object to a list of rows

            # Check if the roll number already exists in the attendance file
            for row in rows:
                if len(row) >= 4 and row[0] == roll_number:  # Ensure there are at least 4 columns
                    # Get the last login date and time for this roll number
                    last_login_date = row[2]'''

'''#random email generator

# List of names
names = [
   'Neha Sinha',
'Lakshmi Reddy',
'Smita Chatterjee',
'Sushila Rao',
'Meena Nair',
'Neelam Kapoor',
'Sreeja Menon',
'Rekha Iyer',
'Pooja Bhat',
'Sunita Mishra',
'Neelam Desai',
'Aarti Kulkarni',
'Priya Joshi',
'Sunita Verma',
'Preeti Gupta',
'Neelam Thakur',
'Meenal Saxena',
'Neha Kaul',
'Sunita Das',
'Simran Sharma',
'Pooja Mehta',
'Suman Tiwari',
'Priya Malhotra',
'Shilpa Choudhary',
'Geeta Pandey',
'Sunita Mahajan',
'Rekha Bansal',
'Anjali Pillai',
'Neelam Singh',
'Sushila Ahuja'


]

# Function to generate email addresses
def generate_email(names):
    domains = ["@gmail.com", "@yahoo.com", "@outlook.com", "@hotmail.com"]
    emails = []
    
    for name in names:
        first_name, last_name = name.split()
        first_initial = first_name.lower()
        last_name = last_name[0].lower()
        email = f"{first_initial}{last_name}{random.choice(domains)}"
        emails.append(email)
    
    return emails

# Generate the email addresses
email_addresses = generate_email(names)
for x in email_addresses:
    print(x)'''



'''import random

# List of 30 places in Hyderabad
places = [
    "Charminar", "Golconda Fort", "Salar Jung Museum", "Hussain Sagar Lake", 
    "Chowmahalla Palace", "Birla Mandir", "Ramoji Film City", "Qutb Shahi Tombs", 
    "Necklace Road", "Durgam Cheruvu", "Snow World", "NTR Gardens", 
    "Lumbini Park", "Shilparamam", "KBR National Park", "Falaknuma Palace", 
    "Mecca Masjid", "HITEC City", "Gachibowli", "Jubilee Hills", 
    "Banjara Hills", "Wonderla Amusement Park", "Purani Haveli", "Paigah Tombs", 
    "Ameerpet", "Begumpet", "LB Nagar", "Manikonda", "Kukatpally"
]

# Shuffle the list randomly
random.shuffle(places)

# Print the places
print("Places in Hyderabad in random order:")
for place in places:
    print(place)
'''
'''
import mysql.connector as sql
mydb=sql.connect(host="localhost",user="root",password="root",database="studentdb")
mycursor=mydb.cursor()
mycursor.execute("SELECT * FROM studentdb.12b where Name='Arnav Sinha'")
for x in mycursor:
    print(x)
'''
'''import mysql.connector
connection = mysql.connector.connect(
        host='localhost',      # Replace with your MySQL server host
        user='root',  # Replace with your MySQL username
        password='root',  # Replace with your MySQL password
        database='studentdb'   # Replace with your database name
    )
cursor = connection.cursor()

for roll_number in range(111001, 111031):

    # Query to fetch all rows for the given roll number
    query = """
        SELECT period_1, period_2, period_3, period_4, period_5, period_6 
        FROM period_11a WHERE rollno = %s
    """
    cursor.execute(query, (roll_number,))
    records = cursor.fetchall()
    print((query, (roll_number,)))

    # Calculate the number of 'P's for the given roll number
    total_present = 0
    for row in records:
        total_present += row.count('P')
    consolidated_list=[]
    consolidated_list.append(total_present)

print(consolidated_list)'''

import mysql.connector

list1=[]
def get_present_count(roll_number):
    try:
        # Connect to the MySQL database
        connection = mysql.connector.connect(
            host='localhost',      # Replace with your MySQL server host
            user='root',  # Replace with your MySQL username
            password='root',  # Replace with your MySQL password
            database='studentdb'   # Replace with your database name
        )
        
        cursor = connection.cursor()

        # Query to fetch all rows for the given roll number
        query = """
            SELECT period_1, period_2, period_3, period_4, period_5, period_6 
            FROM period_11a WHERE rollno = %s
        """
        cursor.execute(query, (roll_number,))
        records = cursor.fetchall()

        # Calculate the number of 'P's for the given roll number
        total_present = 0
        for row in records:
            total_present += row.count('P')

        print(f"Total number of 'P' for Roll Number {roll_number}: {total_present}")
        list1.append(total_present)
    except mysql.connector.Error as e:
        print("Error while connecting to MySQL:", e)
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# Example: Replace with the roll number you want to check
for i in range(111001,111031):
    get_present_count(i)
print(list1)