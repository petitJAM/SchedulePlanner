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
    cur = db.cursor()
    cur.callproc('adduser', (username, email, password))
    cur.close()
    db.commit()

def verifyUserExists(username, password):
    cur = db.cursor()
    checker = 0
    cur.execute("SELECT verifyusernamepassword(%s,SHA1(%s))",(username,password))
    checker = cur.fetchone()
    cur = db.cursor()
    return checker

def getUserAssignments(username):
    cur = db.cursor()
    cur.callproc('getuserassignments', (username,))
    items = cur.fetchall()
    cur.nextset()
    cur.close()
    return items

def storeUserAssignments(username, aID, aName, aCID, aDiff, aDate):
    cur = db.cursor()
    cur.callproc('storeuserassignments',(username, aID, aName, aCID, aDiff, aDate))
    cur.close()
