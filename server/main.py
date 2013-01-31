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
import os
from google.appengine.ext import ndb
from webapp2_extras import security
import time
import cgi
import re


USER_RE = re.compile(r"^[a-zA-Z0-9_-]{3,20}$")
PASSWORD_RE = re.compile(r"^.{3,20}$")
EMAIL_RE = re.compile(r"^[\S]+@[\S]+\.[\S]+$")

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

        # Boolean flag for valid form input. If it is still True after checks below
        # then the user input was valid
        is_valid = True

        # If any error message was set, then inserts[key]!=''
        # so set is_valid False and break
        for key in inserts:
            if inserts[key]:
                is_valid = False
                break

        # Add username and email into inserts dictionary
        inserts['username'] = escape(username)
        inserts['email'] = escape(email)

        if is_valid:
            self.redirect('/signup/welcome?username='+username)
        else:
            self.response.out.write(signup_form % inserts)

class WelcomeHandler(webapp2.RequestHandler):
    def get(self):
        welcome = """
        <h2>Hello %s</h2>
        """
        username = self.request.get('username')
        self.response.out.write(welcome % escape(username))

class MainHandler(webapp2.RequestHandler):
    def get(self):
        self.response.out.write(homeform)


app = webapp2.WSGIApplication([('/signup', SignupHandler),
                                ('/signup/welcome', WelcomeHandler),
                                ('/',MainHandler)], 
                                debug=True)

homeform ="""
<a href="/signup">Signup Form</a>
"""
signup_form="""
<html>
<head>
  <link type="text/css" rel="stylesheet" href="assets/bootstrap/css/bootstrap.css" media="screen">
</head>
<body style="padding-top: 60px;">
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container">
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
<script src="assets/bootstrap/js/bootstrap.js"></script>
</body>
</html>
"""
