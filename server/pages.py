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

scheduleView ="""
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
  <p>%(some_key)s</p>
</div>
<script src="assets/bootstrap/js/bootstrap.js"></script>
</body>
</html>
"""