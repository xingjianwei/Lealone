@REM
@REM  Licensed to the Apache Software Foundation (ASF) under one or more
@REM  contributor license agreements.  See the NOTICE file distributed with
@REM  this work for additional information regarding copyright ownership.
@REM  The ASF licenses this file to You under the Apache License, Version 2.0
@REM  (the "License"); you may not use this file except in compliance with
@REM  the License.  You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM  Unless required by applicable law or agreed to in writing, software
@REM  distributed under the License is distributed on an "AS IS" BASIS,
@REM  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM  See the License for the specific language governing permissions and
@REM  limitations under the License.

@echo off
if "%OS%" == "Windows_NT" setlocal

if NOT DEFINED JAVA_HOME goto :err

pushd %~dp0..
if NOT DEFINED LEALONE_HOME set LEALONE_HOME=%CD%
popd

if NOT DEFINED LEALONE_MAIN set LEALONE_MAIN=org.lealone.main.Lealone


REM ***** JAVA options *****
REM set JAVA_OPTS=-ea^
REM  -Xms10M^
REM  -Xmx1G^
REM  -XX:+HeapDumpOnOutOfMemoryError^
REM  -XX:+UseParNewGC^
REM  -XX:+UseConcMarkSweepGC^
REM  -XX:+CMSParallelRemarkEnabled^
REM  -XX:SurvivorRatio=8^
REM  -XX:MaxTenuringThreshold=1^
REM  -XX:CMSInitiatingOccupancyFraction=75^
REM  -XX:+UseCMSInitiatingOccupancyOnly^
REM  -Dlogback.configurationFile=logback.xml

set JAVA_OPTS=-Xms10M^
 -Dlogback.configurationFile=logback.xml

REM ***** CLASSPATH library setting *****

REM Ensure that any user defined CLASSPATH variables are not used on startup
set CLASSPATH="%LEALONE_HOME%\conf"

REM For each jar in the LEALONE_HOME lib directory call append to build the CLASSPATH variable.
for %%i in ("%LEALONE_HOME%\lib\*.jar") do call :append "%%i"
goto okClasspath

:append
set CLASSPATH=%CLASSPATH%;%1
goto :eof

:okClasspath
set LEALONE_CLASSPATH=%CLASSPATH%;
set LEALONE_PARAMS=-Dlealone.logdir="%LEALONE_HOME%\logs"
set LEALONE_PARAMS=%LEALONE_PARAMS% -Dlealone.config.loader=org.lealone.aose.config.YamlConfigurationLoader
REM set LEALONE_PARAMS=%LEALONE_PARAMS% -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=y
goto runDaemon

:runDaemon
REM echo Starting Lealone Server
"%JAVA_HOME%\bin\java" %JAVA_OPTS% %LEALONE_PARAMS% -cp %LEALONE_CLASSPATH% "%LEALONE_MAIN%"
goto finally

:err
echo JAVA_HOME environment variable must be set!
pause

:finally

ENDLOCAL
