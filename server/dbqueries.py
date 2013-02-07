"""
    Handles all the database interaction
"""

import MySQLdb

db = MySQLdb.connect(host = "localhost",
                        user = "scheduler",
                        passwd ="password123",
                        db ="scheduleplanner")
cur = db.cursor()

def addUser(username,email,password):
    cur.execute("CALL adduser (%s,%s,%s)", (username, email, password))
    db.commit()

def verifyUserExists(username, password):
    checker = 0
    cur.execute("SELECT verifyusernamepassword(%s,SHA1(%s))",(username,password))
    checker = cur.fetchone()[0]
    return checker