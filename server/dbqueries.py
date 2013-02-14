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
    cur.close()
    return checker

def getUserCourses(username):
    cur = db.cursor()
    cur.callproc('getusercourses', (username,))
    courses = cur.fetchall()
    cur.nextset()
    cur.close()
    return courses

def getUserAssignments(username):
    cur = db.cursor()
    cur.callproc('getuserassignments', (username,))
    items = cur.fetchall()
    cur.nextset()
    cur.close()
    return items

def getUserExams(username):
    cur = db.cursor()
    cur.callproc('getuserexams', (username,))
    items = cur.fetchall()
    cur.nextset()
    cur.close()
    return items

def getUserWork(username):
    cur = db.cursor()
    cur.callproc('getuserwork', (username,))
    items = cur.fetchall()
    cur.nextset()
    cur.close()
    return items

def getUserReminders(username):
    cur = db.cursor()
    cur.callproc('getuserreminders', (username,))
    items = cur.fetchall()
    cur.nextset()
    cur.close()
    return items

def getUserMeetings(username):
    cur = db.cursor()
    cur.callproc('getusermeetings', (username,))
    items = cur.fetchall()
    cur.nextset()
    cur.close()
    return items

def storeUserAssignments(username, aID, aName, aCID, aDiff, aDate):
    cur = db.cursor()
    cur.callproc('storeuserassignments',(username, aID, aName, aCID, aDiff, aDate))
    cur.close()

def storeUserExams(username, eID, eCID, eDate):
    cur = db.cursor()
    cur.callproc('storeuserexams', (username, eID, eCID, 0, eDate))
    cur.close()

def storeUserWork(username, wID, wStartTime, wEndTime):
    cur = db.cursor()
    cur.callproc('storeuserwork', (username, wID, wCID, wStartTime, wEndTime))
    cur.close()

def storeUserReminders(username, rID, rDate):
    cur = db.cursor()
    cur.callproc('storeuserreminders', (username, rID, rCID, rDate))
    cur.close()

def storeUserMeetings(username, mID, mDate):
    cur = db.cursor()
    cur.callproc('storeusermeetings', (username, mID, mCID, mDate))
    cur.close()

def getUserCourses(username):
    cur = db.cursor()
    cur.callproc('getusercourses',(username,))
    courses = cur.fetchall()
    cur.nextset()
    cur.close()
    return courses

def getAllCourses():
    cur = db.cursor()
    cur.execute("SELECT c.Name,t.Name AS 'Teacher', c.CID FROM scheduleplanner.courses c, scheduleplanner.teachers t WHERE c.TID = t.TID")
    results = cur.fetchall()
    cur.nextset()
    cur.close()
    return results;


def getUserActiveScheduleID(username):
    cur = db.cursor()
    cur.execute("SELECT Active_SID FROM users WHERE name = %s", username)
    result = cur.fetchone()
    cur.nextset()
    cur.close()
    return result


def storeUserCourses(sid, cid, diff):
    cur = db.cursor()
    cur.callproc('addcoursetoschedule', (sid,cid,diff))
    cur.close()

def removeAllCourses(sid,cid):
    cur=db.cursor()
    cur.callproc('removeallcoursesfromuserschedule', (sid, cid))
    cur.nextset()
    cur.close()