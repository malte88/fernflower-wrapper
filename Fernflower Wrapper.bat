@echo off
if not exist "./out" mkdir "./out"
if not exist "./apache-maven-3.8.8" goto :dlMaven
:haveMaven
if not exist "./fernflower.jar" goto :download

:askdownload
set /p shouldDownload=Fernflower already found. Want to redownload? (y/N) 
if /I "%shouldDownload%" == "y" goto :download
if /I "%shouldDownload%" == "n" goto :shouldNotDownload
if /I "%shouldDownload%" == "" goto :shouldNotDownload
goto :askdownload

:shouldNotDownload
echo Not downloading Fernflower.
goto :decompile

:dlMaven
echo Downloading Maven 3.8.8
powershell Invoke-WebRequest https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.zip -OutFile maven.zip
powershell Expand-Archive maven.zip -DestinationPath .
del maven.zip
echo Finished downloading Maven.
pause
cls
goto :haveMaven

:download
echo Downloading latest Fernflower.
call "./apache-maven-3.8.8/bin/mvn.cmd" dependency:get -DrepoUrl=https://www.jetbrains.com/intellij-repository/releases/ -Dartifact=com.jetbrains.intellij.java:java-decompiler-engine:LATEST -Ddest=./fernflower.jar
if not exist "./fernflower.jar" (
  echo Failed to download Fernflower
  pause
  exit
)
echo Finished downloading Fernflower.
pause

:decompile
cls
if not exist "./fernflower.jar" (
  echo Failed to download Fernflower.
)
set /p file=Enter full Filename to decompile: 
java -jar fernflower.jar ./%file% ./out
pause