#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

import webapp2

import cgi
import re
import MySQLdb


USER_RE = re.compile(r"^[a-zA-Z0-9_-]{3,20}$")
PASSWORD_RE = re.compile(r"^.{3,20}$")
EMAIL_RE = re.compile(r"^[\S]+@[\S]+\.[\S]+$")

db = MySQLdb.connect(host = "localhost",
                        user = "root",
                        passwd ="123",
                        db ="scheduleplanner")
cur = db.cursor()

def InsertUserIntoDB(username,email,password):

  cur.execute("CALL adduser (%s,%s,%s)", (username, email, password))
  db.commit()

def VerifyExistingUser(username, password):

  checker =0
  cur.execute("SELECT verifyusernamepassword(%s,SHA1(%s))",(username,password))
  checker = cur.fetchone()[0]
  return checker

def escape(txt):
    """Escape out special HTML characters in string"""
    return cgi.escape(txt, quote=True);

def valid_username(username):
    return username and USER_RE.match(username)

def valid_password(password):
    return password and PASSWORD_RE.match(password)

def valid_email(email):
    return email and EMAIL_RE.match(email)

class SignupHandler(webapp2.RequestHandler):

    def get(self):
        inserts = {'username_err':'', 'password_err':'', 'verify_err':'', 'email_err':'',
                    'username':'', 'email':''}
        self.response.out.write(signup_form % inserts)

    def post(self):

        is_valid = True
    
        inserts = {'username_err':'', 'password_err':'', 'verify_err':'', 'email_err':'',
                    'username':'', 'email':''}

        # Extract parameters from the post to the server
        username = self.request.get('username')
        password = self.request.get('password')
        verify = self.request.get('verify')
        email = self.request.get('email')

        # Tests below set the error message in inserts appropriately
        if not valid_username(username):
            inserts['username_err'] = "That's not a valid username." 
        if not valid_password(password):
            inserts['password_err'] = "That wasn't a valid password."
        else:
            if (password != verify):
                inserts['verify_err'] = "Your passwords didn't match."
        if email:
            if not valid_email(email):
                inserts['email_err'] = "That's not a valid email."


        # If any error message was set, then inserts[key]!=''
        # so set is_valid False and break
        for key in inserts:
            if inserts[key]:
                is_valid = False
                break

        inserts['username'] = escape(username)
        inserts['email'] = escape(email)

        if is_valid:
            InsertUserIntoDB(inserts['username'], inserts['email'], password)
            self.redirect('/login/welcome?username='+username)
        else:
            self.response.out.write(signup_form % inserts)


class LoginHandler (webapp2.RequestHandler):
    def get(self):
        inserts = {'username_err':'', 'username':''}
        self.response.out.write(login_form % inserts)

    def post(self):
    
        is_valid = True

        inserts = {'username_err':'', 'username':''}

        # Extract parameters from the post to the server
        username = self.request.get('username')
        password = self.request.get('password')
        verify = self.request.get('verify')
        email = self.request.get('email')

        # Tests below set the error message in inserts appropriately
        if not VerifyExistingUser(username, password):
            inserts['username_err'] = "Username and Password do not match" 

        # If any error message was set, then inserts[key]!=''
        # so set is_valid False and break
        for key in inserts:
            if inserts[key]:
                is_valid = False
                break

        inserts['username'] = escape(username)
        inserts['email'] = escape(email)

        if is_valid:
            self.redirect('/login/welcome?username='+username)
        else:
            self.response.out.write(login_form % inserts)

class WelcomeHandler(webapp2.RequestHandler):
    def get(self):
        username = self.request.get('username')
        self.response.out.write(welcomeUser % escape(username))

class MainHandler(webapp2.RequestHandler):
    def get(self):
        self.response.out.write(homeform)


app = webapp2.WSGIApplication([('/signup', SignupHandler),
                                ('/login',LoginHandler),
                                ('/login/welcome', WelcomeHandler),
                                ('/',MainHandler)], 
                                debug=True)

homeform ="""
<html>
<head>
  <link type="text/css" rel="stylesheet" href="assets/bootstrap/css/bootstrap.css" media="screen">
</head>
<body style="padding-top: 60px;">
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container" style="margin-left:20px;">
      <a class="brand" href="/">Schedule Planner</a>
      <div class="nav-collapse collapse">
        <ul class="nav">
          <li class="active"><a href="/">Home</a></li>
          <li><a href="/users">Users</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="container content">
 <div style="width:800px; margin:0 auto;">
  <a href="/signup">Signup Form</a>
  <a href="/login">Login Form</a>
 </div>
</div>
<script src="assets/bootstrap/js/bootstrap.js"></script>
</body>
</html>
"""
signup_form="""
<html>
<head>
  <link type="text/css" rel="stylesheet" href="assets/bootstrap/css/bootstrap.css" media="screen">
</head>
<body style="padding-top: 60px;">
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container" style="margin-left:20px;">
      <a class="brand" href="/">Schedule Planner</a>
      <div class="nav-collapse collapse">
        <ul class="nav">
          <li class="active"><a href="/">Home</a></li>
          <li><a href="/users">Users</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="container content">
 <div style="width:800px; margin:0 auto;">
  <div class="row">
    <h2>Signup Form</h2>
  </div>
  <div class="row">
    <div class="container">
      <form method="post">
        <fieldset>
          <label>Username</label>
          <input type="text" name="username" value="%(username)s">
          <span style="color: red">%(username_err)s</span>

          <label>Password</label>
          <input type="password" name="password" value="">
          <span style="color: red">%(password_err)s</span>

          <label>Verify Password</label>
          <input type="password" name="verify" value="">
          <span style="color: red">%(verify_err)s</span>

          <label>Email (optional)</label>
          <input type="text" name="email" value="%(email)s">
          <span style="color: red">%(email_err)s</span>

          <br/>
          <input class="btn" type="submit">
      </form>
    </div>
  </div>
 </div>
</div>
<script src="assets/bootstrap/js/bootstrap.js"></script>
</body>
</html>
"""

login_form ="""
<html>
<head>
  <link type="text/css" rel="stylesheet" href="assets/bootstrap/css/bootstrap.css" media="screen">
</head>
<body style="padding-top: 60px;">
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container" style="margin-left:20px;">
      <a class="brand" href="/">Schedule Planner</a>
      <div class="nav-collapse collapse">
        <ul class="nav">
          <li class="active"><a href="/">Home</a></li>
          <li><a href="/users">Users</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="container content">
 <div style="width:800px; margin:0 auto;">
  <div class="row">
    <h2>Login Form</h2>
  </div>
  <div class="row">
    <div class="container">
      <form method="post">
        <fieldset>
          <label>Username</label>
          <input type="text" name="username" value="%(username)s">
          <span style="color: red">%(username_err)s</span>

          <label>Password</label>
          <input type="password" name="password" value="">
          <br/>
          <input class="btn" type="submit">
      </form>
    </div>
  </div>
 </div>
</div>
<script src="assets/bootstrap/js/bootstrap.js"></script>
</body>
</html>

"""
welcomeUser ="""
<html>
<head>
  <link type="text/css" rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css" media="screen">
</head>
<body style="padding-top: 60px;">
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container" style="margin-left:20px;">
      <a class="brand" href="/">Schedule Planner</a>
      <div class="nav-collapse collapse">
        <ul class="nav">
          <li class="active"><a href="/">Home</a></li>
          <li><a href="/users">Users</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class="container content">
 <div style="width:800px; margin:0 auto;">
  <h2>Hello %s</h2>
 </div>
</div>
<script src="assets/bootstrap/js/bootstrap.js"></script>
</body>
</html>

"""
