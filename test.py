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
