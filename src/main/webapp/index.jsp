<html>
<head>
<title>Hello S!</title>
</head>
<body>
	<h1>Hello S!</h1>
	<p>
		It is now
		<%= new java.util.Date() %></p>
	<p>
		You are coming from 
		<%= request.getRemoteAddr()  %></p>
</body>
