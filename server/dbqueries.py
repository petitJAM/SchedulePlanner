"""
    Handles all the database interaction
"""

import MySQLdb

db = MySQLdb.connect(host = "localhost",
                     user = "scheduler",
                     passwd ="password123",
                     db ="scheduleplanner",
                     cursorclass=MySQLdb.cursors.DictCursor)
cur = db.cursor()

def addUser(username,email,password):
    cur.callproc('adduser', (username, email, password))
    db.commit()

def verifyUserExists(username, password):
    checker = 0
    cur.execute("SELECT verifyusernamepassword(%s,SHA1(%s))",(username,password))
    checker = cur.fetchone()[0]
    return checker

def getUserSchedule(username):
    cur.callproc('getuseritems', (username,))
    items = cur.fetchall()
    cur.nextset()
    return items