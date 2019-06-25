Nov 21 12:04:33  sudo make
Nov 21 12:05:48  ls
Nov 21 12:06:26  sudo ./webserver 8080
Nov 21 12:17:44  sudo ./webserver 8081
Nov 21 12:18:06  sudo ./webserver 8080
Nov 21 12:28:22  gdb ./webserver 808
Nov 21 12:28:26  gdb ./webserver 8080
Nov 21 12:12:37  wget http://localhost:8080/index.html
Nov 21 12:14:18  wget http://localhost:8080/jens
  wget http://localhost:8080/0123456789012345678901234567890123 
  wget http://localhost:8080/01234567890123456789012345678901234
  wget http://localhost:8080/01234567890123456789012345678901234
Nov 21 12:16:36  wget http://localhost:8080/jens
  wget http://localhost:8080/01234567890123456789012345678901234
  wget http://localhost:8080/jens
Nov 21 12:17:17  sudo ./webserver 8081
  sudo ./webserver 8081
  wget http://localhost:8080/jens
Nov 21 12:17:35  sudo ./webserver 8080
  cd /usr/src/fhttpd
Nov 21 12:18:24  ls
Nov 21 12:18:39  emacs webserver.c
