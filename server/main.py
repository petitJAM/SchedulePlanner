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
import MySQLdb



def insertUserIntoDB(num,username,email,password):
    db = MySQLdb.connect(host = "localhost",
                        user = "root",
                        passwd ="123",
                        db ="scheduleplanner")
    cur = db.cursor()

    #cur.execute("INSERT INTO user VALUES (%s,%s, %s, sha1(%s), NULL)", (int(num), username, email, password))
    #db.commit()

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
        username = self.request.get('username')
        self.response.out.write(welcome % escape(username))


class SignupHandler(webapp2.RequestHandler):

    def get(self, error ="", username="", email =""):
        inserts = {'username_err':'', 'password_err':'', 'verify_err':'', 'email_err':'',
                    'username':'', 'email':''}
        self.response.out.write(signup_form % inserts)

    def post(self):
        # inserts is a dictionary that is used to insert values into html (signup_form) at 
        # proper place
        inserts = {'username_err':'', 'password_err':'', 'verify_err':'', 'email_err':'',
                    'username':'', 'email':''}
       

        username = self.request.get('username')
        password = self.request.get('password')
        verify = self.request.get('verify')
        email = self.request.get('email')

        # if not valid_username(username):
        #     inserts['username_err'] = "That's not a valid username." 
        # if not valid_password(password):
        #     inserts['password_err'] = "That wasn't a valid password."
        # else:
        #     if (password != verify):
        #         inserts['verify_err'] = "Your passwords didn't match."
        # if email:
        #     if not valid_email(email):
        #         inserts['email_err'] = "That's not a valid email."

    
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
            insertUserIntoDB(4,username, email, password)
            self.redirect('/signup/welcome?username='+username)
        else:
            self.response.out.write(signup_form % inserts)



class MainHandler(webapp2.RequestHandler):
    def get(self):
        self.response.out.write(homeform)

class ScheduleHandler(webapp2.RequestHandler):
    def get(self):
        self.response.out.write(scheduleform)


app = webapp2.WSGIApplication([('/signup', SignupHandler),
                                ('/signup/welcome', WelcomeHandler),
                                ('/scheduler', ScheduleHandler),
                                ('/',MainHandler)], 
                                debug=True)

scheduleform = """
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <title>itsvismay</title>
  <!-- styles stuff -->
  <link href="stylesheet-itsvismay.css" rel="stylesheet"></link>
  <!-- knockout stuff -->
  <script type="text/javascript" src="../components/knockout-2.2.0.debug.js"></script>
  <!-- jquery stuff -->
  <link href="../components/jquery-ui-1.9.1.custom/css/start/jquery-ui-1.9.1.custom.css" rel="stylesheet">
  <script src="../components/jquery-ui-1.9.1.custom/js/jquery-1.8.2.js"></script>
  <script src="../components/jquery-ui-1.9.1.custom/js/jquery-ui-1.9.1.custom.js"></script>




</head>

<body>

  <form action='/someServerSideHandler'>
    <p>I have <span data-bind='text: categories().length'>&nbsp;</span> categories of things.</p>
    <table data-bind='visible: categories().length >= 0'>
      <thead>
        <tr>
          <th>Category name</th>
          <th>Difficulty</th>
          <th />
        </tr>
      </thead>
      <tbody data-bind='foreach: categories'>
        <tr>
          <td><input class='required' data-bind='value:ctgName, uniqueName: true' /></td>
          <td><select data-bind="options: $root.difficultyValues, value: ctgDifficulty, optionsText: 'diffName' "></select></td>
          <td><a href='#' data-bind='click: $root.removeCategory'>Delete</a></td>
        </tr>
      </tbody>
    </table>
    <button data-bind='click: addCategory'>Add Category</button>
    <button data-bind='enable: categories().length > 0' type='submit'>Submit</button>
  </form>

  <br><br><br><br>

  <form>
    <p>I have <span data-bind="text:todoList().length">&nbsp;</span> thing(s) to do.</p>
    <table data-bind="visible: todoList.length >=0">
      <thead>
        <tr>
          <th>Items Todo</th>
          <th>Category</th>
          <th>Date</th>
        </tr>
      </thead>
      <tbody data-bind="foreach:{data:todoList, as: 'todoItem'}">
        <tr>
          <td><input class="required" data-bind="value:todoItem.todoName, uniqueName:false"/></td>
          <td><select data-bind="options: $root.categories, value: todoItem.todoCtg, optionsText:'ctgName'"></select></td>
          <td><input data-bind="value: todoItem.todoDate"/></td>
          <td><a href="#" data-bind="click: $root.removeTodoItem">Remove</a></td>
        </tr>
      </tbody>
    </table>
    <button data-bind='click: addTodoItem'>Add Item</button>
  </form>
  <br><br><br><br>
  <h2>Prioritized List</h2>
  <ul data-bind="foreach:{data:prioritizedList, as: 'ptd'}">
    <li>
      <span data-bind="text: $data"></span>
    </li>
  </ul>

  <br><br><br><br>
  <pre data-bind="text:ko.toJSON($root, null, 2)"></pre>

  <!-- <h2>Prioritized Schedule</h2>
  <ul data-bind="foreach: {data:prioritizedList, as:'ptd'}">
    <li>
      <div>
        <span data-bind="text: ptd.pname"></span>
      </div>
    </li>
  </ul> -->

  <!-- import javascript for the program -->
  <script type="text/javascript" src="projectjs.js"></script>

  <script type="text/javascript">
  $(function(){

    var keywords =[
    {"word":"project", "importance":3, "timesink":5},
    {"word":"meeting", "importance":4, "timesink":0},
    {"word":"test", "importance":5, "timesink":3},
    {"word":"exam", "importance":5, "timesink":3},
    {"word":"quiz", "importance":2, "timesink":1},
    {"word":"reading", "importance":1, "timesink":2},
    {"word":"homework", "importance":3, "timesink":3},
    {"word":"hw", "importance":3, "timesink":5},
    {"word":"essay", "importance":4, "timesink":4},
    {"word":"milestone", "importance":4, "timesink":3},
    {"word":"report", "importance":4, "timesink":5},
    {"word":"!", "importance":5, "timesink":0}
    ];

    function Category(name, diff){
      var self= this;
      self.ctgName = ko.observable(name);
      self.ctgDifficulty = ko.observable(diff);
    }

    function TodoItem(name, ctg, date){
      var self = this;
      self.todoName = ko.observable(name);
      self.todoCtg = ko.observable(ctg);
      self.todoDate = ko.observable(date);

    }

    
    function CategoryViewModel(keywords){

      var self = this;

      self.difficultyValues = [
      {diffName: "ChooseOne", diff: 0},
      {diffName: "snore..zzz", diff: 1},
      {diffName: "easy stuff", diff: 2},
      {diffName: "yipes! focus now!", diff: 3},
      {diffName: "Gonna be up late :(", diff: 4},
      {diffName: "OH S**T!", diff: 5}
      ];

      self.categories = ko.observableArray([
        new Category("Personal Time", self.difficultyValues[0]),
        new Category("Databases", self.difficultyValues[3]),
        new Category("Theory Of Comp", self.difficultyValues[4]),
        new Category("pre-Algebra", self.difficultyValues[1])
        ]);


      self.addCategory = function() {
        self.categories.push( new Category("Type category name", self.difficultyValues[0]));
      };

      self.removeCategory = function(ctg) {
        self.categories.remove(ctg);
      };


      self.todoList = ko.observableArray([
        new TodoItem("DB hw", self.categories[0], "MM/DD/YYY"),
        new TodoItem("ToC project", self.categories[0], "MM/DD/YYY")
        ]);

      self.removeTodoItem = function(item){
        self.todoList.remove(item);;
      }
      self.addTodoItem = function(){
        self.todoList.push( new TodoItem("New Task", self.categories[0],"MM/DD/YYY" ));
      }
      console.log(self.todoList);
      
      self.prioritizedList = ko.computed(function(){
        var tempTodoList = self.todoList.slice();
        var pList = new Array();
        var tempPList = new Array();
        console.log(tempTodoList);
        for(var i=0; i<tempTodoList.length; i++){
          var obj ={
            name: tempTodoList[i].todoName._latestValue.toLowerCase(),
            //diff: tempTodoList[i].todoCtg._latestValue.ctgDifficulty._latestValue.diff,
            date: tempTodoList[i].todoDate._latestValue
            //ctg: tempTodoList[i].todoCtg._latestValue.ctgName._latestValue
          };
          tempPList.push(obj);
          pList.push(tempTodoList[i].todoName._latestValue);
        }
        console.log(tempPList);


        for(var i=0; i<tempPList.length;i++){
          var string = tempPList[i].name;
          var taskImpCount =0;
          for(var k=0; k<keywords.length; k++){
            var index = string.search(keywords[k].word)
            //console.log(keywords[k].word);
            if(index>=0){
              console.log(keywords[k].word);
            }
          }
        }
        
        return pList;
      })
    }

    ko.applyBindings(new CategoryViewModel(keywords));

  });
</script>

</body>

</html>

"""
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

welcome = """
        <h2>Hello. Welcome to this app. You have signed up%s</h2>
        <br>
        <br>
        <a href="/scheduler"></a>
        """
