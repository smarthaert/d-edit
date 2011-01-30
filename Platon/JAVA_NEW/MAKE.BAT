path C:\JBuilder3\java\bin
del !errlist.txt
del *.class
javac platon.java > !errlist.txt
appletviewer.exe platon.html

