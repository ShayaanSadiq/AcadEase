#code to check how stripping datetime module/functions in datetime module works

'''

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
import random

'''

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

'''

#no clue what this does

'''

with open('attendance.csv', 'r', newline='') as f:
        reader = csv.reader(f)
        rows = list(reader)  # Convert the reader object to a list of rows
        # Check if the roll number already exists in the attendance file
        for row in rows:
            if len(row) >= 4 and row[0] == roll_number:  # Ensure there are at least 4 columns
                # Get the last login date and time for this roll number
                last_login_date = row[2]
                    
'''

#random email generator

'''

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
    print(x)
    
'''

#code to randomize places for address

'''

import random

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
#test code to print student details

'''

import mysql.connector as sql
mydb=sql.connect(host="localhost",user="root",password="root",database="studentdb")
mycursor=mydb.cursor()
mycursor.execute("SELECT * FROM studentdb.12b where Name='Arnav Sinha'")
for x in mycursor:
    print(x)

'''

#test code to calculate percentage of attendance

'''

import mysql.connector
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

print(consolidated_list)

'''

#MAIN code to calculate percentage from period11a, period11b etc



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

        query1="""
            SELECT date 
            FROM period11a WHERE rollno=%s
        """
        cursor.execute(query1, (roll_number,))
        date=cursor.fetchall()
        # Query to fetch all rows for the given roll number
        query = """
            SELECT period_1, period_2, period_3, period_4, period_5, period_6 
            FROM period11a WHERE rollno = %s
        """
        cursor.execute(query, (roll_number,))
        records = cursor.fetchone()

        # Calculate the number of 'P's for the given roll number
        total_present = 0
        for row in records:
            total_present += row.count('P')
        percentage=round((total_present/6)*100,2)
        if(percentage==100.0):
            percentage=int(percentage)
        list1.append(percentage)
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



#code to change date in words to date in numbers


'''

from datetime import datetime

def convert_date_format(date_str):
    # Parse the date string into a datetime object
    date_obj = datetime.strptime(date_str, "%Y-%m-%d")
    
    # Get the day, month, and year in the desired format
    day = date_obj.day
    day_suffix = 'th' if 11 <= day <= 13 else {1: 'st', 2: 'nd', 3: 'rd'}.get(day % 10, 'th')
    
    # Use the day with the suffix and format the rest of the date
    formatted_date = f"{day}{day_suffix} {date_obj.strftime('%b %Y')}"
    return formatted_date

# Example usage
date_input = "2024-12-01"
formatted_date = convert_date_format(date_input)
print(formatted_date)  # Output: 1st Dec 2024

'''

#code to rename girl1.png, girl2.png etc to 111002.png, 111004.png etc

'''

import os

j_new=122002
for i in range(46,61):
    i=str(i)
    str1="girl"+i+".png"
    str2=str(j_new)+".png"
    os.rename(str1,str2)
    j_new=j_new+2

'''

#test code to see if inserting image into mysql after changing encoding works(it didnt)

'''

import base64
import mysql.connector as sql
mydb=sql.connect(host="localhost",
                 user="root",
                 password="root",
                 database="studentdb")
cursor=mydb.cursor()
rollno=111001
query="""
    SELECT img 
    FROM image
    WHERE id=%s"""
cursor.execute(query,(rollno,))
result=cursor.fetchone()
img_base64 = base64.b64encode(result[0]).decode('utf-8')
print(img_base64)

'''

#code to insert image into mysql 

'''

import mysql.connector

# Establish connection
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    auth_plugin="mysql_native_password"
)


mycursor = mydb.cursor()

# Use the correct database
mycursor.execute("USE studentdb")

# Insert image records
try:
    query = "INSERT INTO image (id, img) VALUES (%s, %s)"
    records = [
        (str(i), f"C:\\Users\\lihas\\Documents\\Shayaan\\AcadEase\\studentimg\\main\\{i}.png")
        for i in range(122001, 122031)
    ]
    mycursor.executemany(query, records)  # Batch insertion
    mydb.commit()
    print(f"Inserted {mycursor.rowcount} records successfully.")
except mysql.connector.Error as err:
    print(f"Error: {err}")

'''

#code to load images into mysql

'''

import mysql.connector

try:
    mydb = mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="studentdb"
    )
    cursor = mydb.cursor()

    query = """
    INSERT INTO image (id, img)
    VALUES (%s, LOAD_FILE(%s));
    """

    # Loop through roll numbers 111001 to 111030
    for roll_number in range(122001, 122031):
        # Construct the file path dynamically based on the roll number
        file_path = f'C:\\ProgramData\\MySQL\\MySQL Server 9.1\\Uploads\\{roll_number}.png'
        data = (roll_number, file_path)

        try:
            cursor.execute(query, data)
            print(f"Image for Roll Number {roll_number} inserted successfully.")
        except mysql.connector.Error as err:
            print(f"Error inserting Roll Number {roll_number}: {err}")

    mydb.commit()

except mysql.connector.Error as err:
    print(f"Database Connection Error: {err}")

finally:
    cursor.close()
    mydb.close()

'''

#code to generate the below output

'''

for i in range(1,32):
    print(f"ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-{i}` `2025-01-{i}` INT NULL DEFAULT NULL;")

'''

#output from above code(to implement changes in month_att table in mysql in an easy way)

'''

UPDATE `studentdb`.`month_att` SET `2024-12-01` = NULL WHERE `2024-12-01` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-02` = NULL WHERE `2024-12-02` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-03` = NULL WHERE `2024-12-03` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-04` = NULL WHERE `2024-12-04` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-05` = NULL WHERE `2024-12-05` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-06` = NULL WHERE `2024-12-06` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-07` = NULL WHERE `2024-12-07` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-08` = NULL WHERE `2024-12-08` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-09` = NULL WHERE `2024-12-09` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-10` = NULL WHERE `2024-12-10` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-11` = NULL WHERE `2024-12-11` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-12` = NULL WHERE `2024-12-12` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-13` = NULL WHERE `2024-12-13` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-14` = NULL WHERE `2024-12-14` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-15` = NULL WHERE `2024-12-15` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-16` = NULL WHERE `2024-12-16` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-17` = NULL WHERE `2024-12-17` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-18` = NULL WHERE `2024-12-18` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-19` = NULL WHERE `2024-12-19` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-20` = NULL WHERE `2024-12-20` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-21` = NULL WHERE `2024-12-21` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-22` = NULL WHERE `2024-12-22` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-23` = NULL WHERE `2024-12-23` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-24` = NULL WHERE `2024-12-24` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-25` = NULL WHERE `2024-12-25` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-26` = NULL WHERE `2024-12-26` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-27` = NULL WHERE `2024-12-27` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-28` = NULL WHERE `2024-12-28` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-29` = NULL WHERE `2024-12-29` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-30` = NULL WHERE `2024-12-30` = '';
UPDATE `studentdb`.`month_att` SET `2024-12-31` = NULL WHERE `2024-12-31` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-01` = NULL WHERE `2025-01-01` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-02` = NULL WHERE `2025-01-02` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-03` = NULL WHERE `2025-01-03` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-04` = NULL WHERE `2025-01-04` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-05` = NULL WHERE `2025-01-05` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-06` = NULL WHERE `2025-01-06` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-07` = NULL WHERE `2025-01-07` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-08` = NULL WHERE `2025-01-08` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-09` = NULL WHERE `2025-01-09` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-10` = NULL WHERE `2025-01-10` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-11` = NULL WHERE `2025-01-11` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-12` = NULL WHERE `2025-01-12` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-13` = NULL WHERE `2025-01-13` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-14` = NULL WHERE `2025-01-14` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-15` = NULL WHERE `2025-01-15` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-16` = NULL WHERE `2025-01-16` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-17` = NULL WHERE `2025-01-17` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-18` = NULL WHERE `2025-01-18` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-19` = NULL WHERE `2025-01-19` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-20` = NULL WHERE `2025-01-20` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-21` = NULL WHERE `2025-01-21` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-22` = NULL WHERE `2025-01-22` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-23` = NULL WHERE `2025-01-23` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-24` = NULL WHERE `2025-01-24` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-25` = NULL WHERE `2025-01-25` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-26` = NULL WHERE `2025-01-26` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-27` = NULL WHERE `2025-01-27` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-28` = NULL WHERE `2025-01-28` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-29` = NULL WHERE `2025-01-29` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-30` = NULL WHERE `2025-01-30` = '';
UPDATE `studentdb`.`month_att` SET `2025-01-31` = NULL WHERE `2025-01-31` = '';

ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-01` `2024-12-01` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-02` `2024-12-02` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-03` `2024-12-03` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-04` `2024-12-04` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-05` `2024-12-05` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-06` `2024-12-06` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-07` `2024-12-07` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-08` `2024-12-08` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-09` `2024-12-09` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-10` `2024-12-10` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-11` `2024-12-11` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-12` `2024-12-12` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-13` `2024-12-13` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-14` `2024-12-14` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-15` `2024-12-15` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-16` `2024-12-16` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-17` `2024-12-17` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-18` `2024-12-18` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-19` `2024-12-19` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-20` `2024-12-20` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-21` `2024-12-21` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-22` `2024-12-22` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-23` `2024-12-23` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-24` `2024-12-24` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-25` `2024-12-25` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-26` `2024-12-26` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-27` `2024-12-27` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-28` `2024-12-28` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-29` `2024-12-29` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-30` `2024-12-30` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2024-12-31` `2024-12-31` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-01` `2025-01-01` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-02` `2025-01-02` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-03` `2025-01-03` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-04` `2025-01-04` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-05` `2025-01-05` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-06` `2025-01-06` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-07` `2025-01-07` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-08` `2025-01-08` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-09` `2025-01-09` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-10` `2025-01-10` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-11` `2025-01-11` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-12` `2025-01-12` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-13` `2025-01-13` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-14` `2025-01-14` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-15` `2025-01-15` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-16` `2025-01-16` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-17` `2025-01-17` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-18` `2025-01-18` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-19` `2025-01-19` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-20` `2025-01-20` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-21` `2025-01-21` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-22` `2025-01-22` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-23` `2025-01-23` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-24` `2025-01-24` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-25` `2025-01-25` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-26` `2025-01-26` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-27` `2025-01-27` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-28` `2025-01-28` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-29` `2025-01-29` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-30` `2025-01-30` INT NULL DEFAULT NULL;
ALTER TABLE `studentdb`.`month_att` CHANGE COLUMN `2025-01-31` `2025-01-31` INT NULL DEFAULT NULL;

'''