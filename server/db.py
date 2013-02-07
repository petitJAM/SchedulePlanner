

db = MySQLdb.connect(host = "localhost",
                        user = "scheduler",
                        passwd ="password123",
                        db ="scheduleplanner")
cur = db.cursor()

def addUser(username,email,password):
    cur.execute("CALL adduser (%s,%s,%s)", (username, email, password))
    db.commit()