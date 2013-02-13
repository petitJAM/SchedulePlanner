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

import cgi, os, re
import MySQLdb
import jinja2
import datetime
import json
import urllib2
dthandler = lambda obj: obj.isoformat() if isinstance(obj, datetime.datetime) else None

from dbqueries import *

from google.appengine.ext import db

template_dir = os.path.join(os.path.dirname(__file__), 'pages')
jinja_env = jinja2.Environment(loader = jinja2.FileSystemLoader(template_dir),
                               autoescape = True)

def render_str(template, **params):
    t = jinja_env.get_template(template)
    return t.render(params)

class TemplateHandler(webapp2.RequestHandler):

    def renderFile(self, template, **kw):
        self.response.out.write(render_str(template, **kw))

    def writeFile(self, *a, **kw):
        self.response.out.write(*a, **kw)


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

class CoursesHandler(TemplateHandler):
    def get(self):
        username = self.request.get('username')
        usercourses = getUserCourses(username)
        allcourses = getAllCourses()
        jsonUserCourses = json.dumps(usercourses,default =dthandler)
        jsonAllCourses = json.dumps(allcourses, default=dthandler)
        inserts ={'username': username, 'usercourses':jsonUserCourses, 'allcourses':jsonAllCourses}
        self.renderFile("usercourses.html", **inserts)

    def post(self):
        username = self.request.get('username')
        data = self.request.get('bunchesofdata')
        data = json.loads(data)
        sid =getUserActiveScheduleID(username)
        removeAllCourses(sid['Active_SID'],data['courseslist'][0]['cID'])
        for i in range(0, len(data['courseslist'])):
             storeUserCourses(sid['Active_SID'],
                data['courseslist'][i]['cID'],
                 data['courseslist'][i]['diff'])
        usercourses = getUserCourses(username)
        allcourses = getAllCourses()
        jsonUserCourses = json.dumps(usercourses,default =dthandler)
        jsonAllCourses = json.dumps(allcourses, default=dthandler)
        inserts ={'username': username, 'usercourses':jsonUserCourses, 'allcourses':jsonAllCourses, 'data': jsonUserCourses}
        self.renderFile("usercourses.html", **inserts)    

class AssignmentsHandler(TemplateHandler):
    def get(self):
        username = self.request.get('username')
        schedule = getUserAssignments(username)
        courses = getUserCourses(username)
        jsonschedule = json.dumps(schedule, default=dthandler)
        jsoncourses = json.dumps(courses, default=dthandler)
        inserts={'username': username, 'items':jsonschedule, 'courses':jsoncourses}
        self.renderFile("assignments.html", **inserts)

    def post(self):
        username = self.request.get('username')
        data = self.request.get('bunchesofdata')
        data = json.loads(data)
        for i in range(0, len(data['itemslist'])):
            storeUserAssignments(username, data['itemslist'][i]['itemID'], data['itemslist'][i]['itemName'], data['itemslist'][i]['itemCourse']['courseID'], data['itemslist'][i]['itemDiff']['diff'], data['itemslist'][i]['itemDate'])
            
        # update
        print self.request.get('courses')

        schedule = getUserAssignments(username)
        jsonschedule = json.dumps(schedule, default=dthandler)
        inserts = {'username': username, 'items':jsonschedule}
        self.renderFile("assignments.html", **inserts)

class ExamHandler(TemplateHandler):
    def get(self):
        username = self.request.get('username')
        exams = getUserExams(username)
        jsonexams = json.dumps(exams, default=dthandler)
        usercourses = getUserCourses(username)
        jsonUserCourses = json.dumps(usercourses,default =dthandler)
        inserts={'username': username, 'items':jsonexams, 'usercourses':jsonUserCourses}
        self.renderFile("exams.html", **inserts)

class WorkHandler(TemplateHandler):
    def get(self):
        username = self.request.get('username')
        schedule = getUserWork(username)
        jsonschedule = json.dumps(schedule, default=dthandler)
        inserts={'username': username, 'items':jsonschedule}
        self.renderFile("work.html", **inserts)

class ReminderHandler(TemplateHandler):
    def get(self):
        username = self.request.get('username')
        reminder = getUserReminders(username)
        jsonreminder = json.dumps(reminder, default=dthandler)
        inserts={'username': username, 'items':jsonreminder}
        self.renderFile("reminders.html", **inserts)




class MeetingHandler(TemplateHandler):
    def get(self):
        username = self.request.get('username')
        meetings =  getUserMeetings(username)
        jsonmeetings = json.dumps(meetings, default=dthandler)
        usercourses = getUserCourses(username)
        jsonUserCourses = json.dumps(usercourses,default =dthandler)
        inserts = {'username': username, 'items':jsonmeetings, 'usercourses': jsonUserCourses}
        self.renderFile("meetings.html", **inserts)


class SignupHandler(TemplateHandler):
    def get(self):
        inserts = {'username_err':'', 'password_err':'', 'verify_err':'', 'email_err':'',
                    'username':'', 'email':''}
        self.renderFile("signUpForm.html", **inserts)

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

        is_valid = True
        # If any error message was set, then inserts[key]!=''
        # so set is_valid False and break
        for key in inserts:
            if inserts[key]:
                is_valid = False
                break

        inserts['username'] = escape(username)
        inserts['email'] = escape(email)

        if is_valid:
            addUser(inserts['username'], inserts['email'], password)
            self.redirect('/login/welcome?username='+username)
        else:
            self.renderFile("signUpForm.html", **inserts)

class LoginHandler (TemplateHandler):
    def get(self):
        inserts = {'username_err':'', 'username':''}
        self.renderFile("loginForm.html", **inserts)

    def post(self):
    
        is_valid = True

        inserts = {'username_err':'', 'username':''}

        # Extract parameters from the post to the server
        username = self.request.get('username')
        password = self.request.get('password')
        verify = self.request.get('verify')
        email = self.request.get('email')

        # Tests below set the error message in inserts appropriately
        if not verifyUserExists(username, password):
            inserts['username_err'] = "Your Username and Password do not match" 

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
            self.renderFile("loginForm.html", **inserts)

class WelcomeHandler(TemplateHandler):
    def get(self):
        username = self.request.get('username')
        inserts = {'username': username}
        self.renderFile("welcomeUser.html", **inserts)

    def post(self):
        username = self.request.get('username')
        username = str(username)
        self.redirect('scheduler/assignments?username='+username)

class MainHandler(TemplateHandler):
    def get(self):
        self.renderFile("index.html")

class ContactHandler(TemplateHandler):
    def get(self):
        self.renderFile("contact.html")

class PrioritytHandler(TemplateHandler):
    def get(self):
        self.renderFile("priority.html")

app = webapp2.WSGIApplication([('/signup', SignupHandler),
                                ('/login', LoginHandler),
                                ('/login/welcome', WelcomeHandler),
                                ('/login/scheduler/assignments', AssignmentsHandler),
                                ('/login/scheduler/exams', ExamHandler),
                                ('/login/scheduler/work', WorkHandler),
                                ('/login/scheduler/reminders', ReminderHandler),
                                ('/login/scheduler/meetings', MeetingHandler),
                                ('/login/courses', CoursesHandler),
                                ('/', MainHandler),
                                ('/contact', ContactHandler),
                                ('/priority', PrioritytHandler)], 
                                debug=True)

