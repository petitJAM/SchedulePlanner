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



def escape(txt):
    #Escape out special HTML characters in string
    #do this to prevent HTML injection
    return cgi.escape(txt, quote=True);

def valid_username(username):
    return true

def valid_password(password):
    return true
def valid_email(email):
    return true

class WelcomeHandler(webapp2.RequestHandler):
    def get(self):
        welcome = """
        <h2>Hello. Welcome to this app. You have signed up%s</h2>
        """
        username = self.request.get('username')
        self.response.out.write(welcome % escape(username))

class SignupHandler(webapp2.RequestHandler):

    def get(self):
        inserts = {'username_err':'', 'password_err':'', 'verify_err':'', 'email_err':'',
                    'username':'', 'email':''}
        self.response.out.write(signup_form % inserts)


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
signup_form = """
<h2>Signup Form</h2>
<form method="post">
  <table>
    <tr>
      <td class="label">
        Username
      </td>
      <td>
        <input type="text" name="username" value="%(username)s">
      </td>
      <td class="error">
        <span style="color: red">%(username_err)s</span>
      </td>
    </tr>

    <tr>
      <td class="label">
        Password
      </td>
      <td>
        <input type="password" name="password" value="">
      </td>
      <td class="error">
        <span style="color: red">%(password_err)s</span>
      </td>
    </tr>

    <tr>
      <td class="label">
        Verify Password
      </td>
      <td>
        <input type="password" name="verify" value="">
      </td>
      <td class="error">
        <span style="color: red">%(verify_err)s</span>
      </td>
    </tr>

    <tr>
      <td class="label">
        Email (optional)
      </td>
      <td>
        <input type="text" name="email" value="%(email)s">
      </td>
      <td class="error">
        <span style="color: red">%(email_err)s</span>
      </td>
    </tr>
  </table>

  <input type="submit">
</form>
"""