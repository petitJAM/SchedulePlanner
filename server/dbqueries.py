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
    checker = cur.fetchone()
    return checker

def getUserAssignments(username):
    cur.callproc('getuserassignments', (username,))
    items = cur.fetchall()
    cur.nextset()
    return items

def storeUserAssignments(username, aID, aName, aCID, aDiff, aDate):
    cur.callproc('storeuserassignments',(username, aID, aName, aCID, aDiff, aDate))
    db.commit()
