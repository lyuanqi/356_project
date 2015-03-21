
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Doctor Referral Program</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/jumbotron-narrow.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
    <script src="js/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="container">
      <div class="header">
        <nav>
          <ul class="nav nav-pills pull-right">
            <li role="presentation" class="active"><a href="#">Home</a></li>
          </ul>
        </nav>
        <h3 class="text-muted">ECE356 Project</h3>
      </div>

      <div class="jumbotron">
        <h1>Doctor Referral Program</h1>
        <p class="lead">Project Description</p>
      </div>

      <div class="row marketing">
        <div class="col-lg-6">
          <h4>Doctor Login</h4>
          <p>Login to view your referral</p>
          <p>
            <a class="btn btn-lg btn-primary" href="doctorSignInPage.jsp" role="button"> Login »</a>
          </p>
        </div>
        <div class="col-lg-6">
          <h4>Patient Login</h4>
          <p>Login to view your referral</p>
          <p>
            <a class="btn btn-lg btn-primary" href="patientSignInPage.jsp" role="button"> Login »</a>
          </p>
        </div>
      </div>

    </div> <!-- /container -->


    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>
