@echo off
rem
rem
rem    Licensed to the Apache Software Foundation (ASF) under one or more
rem    contributor license agreements.  See the NOTICE file distributed with
rem    this work for additional information regarding copyright ownership.
rem    The ASF licenses this file to You under the Apache License, Version 2.0
rem    (the "License"); you may not use this file except in compliance with
rem    the License.  You may obtain a copy of the License at
rem
rem       http://www.apache.org/licenses/LICENSE-2.0
rem
rem    Unless required by applicable law or agreed to in writing, software
rem    distributed under the License is distributed on an "AS IS" BASIS,
rem    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem    See the License for the specific language governing permissions and
rem    limitations under the License.
rem
rem    ------------------------------------------------------------------------
rem
rem    This script is adapted from the launcher script of the Karaf runtime:
rem    http://karaf.apache.org/
rem

if not "%ECHO%" == "" echo %ECHO%

setlocal enabledelayedexpansion
set DIRNAME=%~dp0
set PROGNAME=%~nx0
rem Code to return to launcher on failure
rem 0:success, 1:unhandled, 2:user-fixable, 3:fatal(we must fix)
set exitCode=0


title Pipeline2

if "%PIPELINE2_DATA%" == "" (
    set PIPELINE2_DATA=%appdata%/DAISY Pipeline 2
)
if not exist "%PIPELINE2_DATA%" mkdir "%PIPELINE2_DATA%"

if "%PIPELINE2_LOGDIR%" == "" (
    set PIPELINE2_LOGDIR=%appdata%/DAISY Pipeline 2\log
)
if not exist "%PIPELINE2_LOGDIR%" mkdir "%PIPELINE2_LOGDIR%"

goto BEGIN

rem # # SUBROUTINES # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:warn
    echo %PROGNAME%: %*
goto :EOF

rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:BEGIN
    call:warn %DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%

    rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

    if not "%PIPELINE2_HOME%" == "" call:warn Ignoring value for PIPELINE2_HOME

    set PIPELINE2_HOME=%DIRNAME%..
    if not exist "%PIPELINE2_HOME%" (
        call:warn PIPELINE2_HOME is not valid: !PIPELINE2_HOME!
        rem fatal
        set exitCode=3
        goto END
    )

    rem Setup the Java Virtual Machine
    call "%DIRNAME%\checkJavaVersion.bat" 11
    if errorLevel 1 (
        rem Fall back to Java 8 (or 9 or 10) because web server does not work with Java 11
        call:warn Java 11 not found; Trying Java 8
        call "%DIRNAME%\checkJavaVersion.bat" 1.8
        if errorLevel 1 (
            if errorLevel 2 (
                rem fatal
                set exitCode=3
            ) else (
                rem user-fixable
                set exitCode=2
            )
            goto END
        )
    )
    rem triggers windows firewall security notice
    rem set DEFAULT_JAVA_OPTS=-Dcom.sun.management.jmxremote
    rem if "%JAVA_OPTS%" == "" set JAVA_OPTS=%DEFAULT_JAVA_OPTS%

    set DEFAULT_JAVA_DEBUG_OPTS=-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
    if "%PIPELINE2_DEBUG%" == "" goto :PIPELINE2_DEBUG_END
    rem Use the defaults if JAVA_DEBUG_OPTS was not set
    if "%JAVA_DEBUG_OPTS%" == "" set JAVA_DEBUG_OPTS=%DEFAULT_JAVA_DEBUG_OPTS%
    set "JAVA_OPTS=%JAVA_DEBUG_OPTS% %JAVA_OPTS%"
    call:warn Enabling Java debug options: %JAVA_DEBUG_OPTS%
:PIPELINE2_DEBUG_END

    set ENABLE_OSGI=false
    set ENABLE_PERSISTENCE=false
    set ENABLE_SHELL=true
    set CLI_MODE=true

:RUN_LOOP
    if "%1" == "debug" goto :EXECUTE_DEBUG
    goto :EXECUTE_CLI

:EXECUTE_DEBUG
    if "%JAVA_DEBUG_OPTS%" == "" set JAVA_DEBUG_OPTS=%DEFAULT_JAVA_DEBUG_OPTS%
    set "JAVA_OPTS=%JAVA_DEBUG_OPTS% %JAVA_OPTS%"
    shift
goto :RUN_LOOP

:EXECUTE_CLI
    set PIPELINE2_WS_LOCALFS=true
    set PIPELINE2_WS_AUTHENTICATION=false
    set CLI_MODE=true
    set ENABLE_SHELL=true
:PARSE_CLI_ARGS
    if [%1]==[] (
        goto :EXECUTE
    ) else (
        set CLI_ARGS=%CLI_ARGS% %1
        shift
        goto :PARSE_CLI_ARGS
    )
    rem stop parsing argument
rem goto :EXECUTE


:EXECUTE
    if not exist "%PIPELINE2_HOME%\system\simple-api" (
        rem fatal
        set exitCode=3
        goto END
    )

    rem set PATHS=!PATHS! system\simple-api
    set MAIN=SimpleAPI %CLI_ARGS%
    set PATHS=!PATHS! system\no-osgi

    for %%D in (system\common !PATHS! modules) do (
        if exist "%PIPELINE2_HOME%\%%D" (
            rem Using wildcard to avoid "The input line is too long" error
            set CLASSPATH=!CLASSPATH!;%%D\*
            rem for /f %%F in ('dir /b "%PIPELINE2_HOME%\%%D\*.jar"') do (
            rem     set CLASSPATH=!CLASSPATH!;%%D\%%F
            rem )
        )
    )
    set CLASSPATH=!CLASSPATH!;system\simple-api\api;system\simple-api

    rem Execute the Java Virtual Machine
    cd "%PIPELINE2_HOME%"

    rem Logback configuration file
    set SYSTEM_PROPS=%SYSTEM_PROPS% -Dlogback.configurationFile="file:%PIPELINE2_HOME:\=/%/etc/logback.xml"
    set SYSTEM_PROPS=%SYSTEM_PROPS% -Djava.util.logging.config.file="%PIPELINE2_HOME:\=/%/etc/logging.properties"

    rem to make ${org.daisy.pipeline.logdir} available in logback.xml
    set SYSTEM_PROPS=%SYSTEM_PROPS% -Dorg.daisy.pipeline.logdir="%PIPELINE2_LOGDIR%"

    call "%DIRNAME%\checkJavaVersion.bat" _ :compare_versions %JAVA_VER% 9
    if %ERRORLEVEL% geq 0 (
        if errorLevel 3 (
            rem unexpected error
            call:warn Failed to compare versions: "%JAVA_VER%" with "9"
            set exitCode=3
            goto END
        )
        rem at least version 9
        SET COMMAND="%JAVA%" %JAVA_OPTS% ^
            --add-opens java.base/java.security=ALL-UNNAMED ^
            --add-opens java.base/java.net=ALL-UNNAMED ^
            --add-opens java.base/java.lang=ALL-UNNAMED ^
            --add-opens java.base/java.util=ALL-UNNAMED ^
            --add-opens java.naming/javax.naming.spi=ALL-UNNAMED ^
            --add-opens java.rmi/sun.rmi.transport.tcp=ALL-UNNAMED ^
            --add-exports=java.base/sun.net.www.protocol.http=ALL-UNNAMED ^
            --add-exports=java.base/sun.net.www.protocol.https=ALL-UNNAMED ^
            --add-exports=java.base/sun.net.www.protocol.jar=ALL-UNNAMED ^
            --add-exports=jdk.xml.dom/org.w3c.dom.html=ALL-UNNAMED ^
            --add-exports=jdk.naming.rmi/com.sun.jndi.url.rmi=ALL-UNNAMED ^
            %OSGI_OPTS% ^
            -Dorg.daisy.pipeline.properties="%PIPELINE2_HOME%\etc\pipeline.properties" ^
            %SYSTEM_PROPS% ^
            -classpath "%CLASSPATH%" ^
            %MAIN%
    ) else (
        rem version 8
        SET COMMAND="%JAVA%" %JAVA_OPTS% ^
            %OSGI_OPTS% ^
            -Dorg.daisy.pipeline.properties="%PIPELINE2_HOME%\etc\pipeline.properties" ^
            %SYSTEM_PROPS% ^
            -classpath "%CLASSPATH%" ^
            %MAIN%
            rem skipping java.endorsed.dirs and java.ext.dirs because this requires JAVA_HOME which is not always available
            rem -Djava.endorsed.dirs="%JAVA_HOME%\jre\lib\endorsed;%JAVA_HOME%\lib\endorsed;%PIPELINE2_HOME%\lib\endorsed" ^
            rem -Djava.ext.dirs="%JAVA_HOME%\jre\lib\ext;%JAVA_HOME%\lib\ext;%PIPELINE2_HOME%\lib\ext" ^
    )
    rem call:warn Starting java: %COMMAND%

    rem endlocal & (
    rem     set "PIPELINE2_HOME=%PIPELINE2_HOME%"
    rem     set "PIPELINE2_DATA=%PIPELINE2_DATA%"
    rem     set "PIPELINE2_LOGDIR=%PIPELINE2_LOGDIR%"
    rem     set "PIPELINE2_WS_LOCALFS=%PIPELINE2_WS_LOCALFS%"
    rem     set "PIPELINE2_WS_AUTHENTICATION=%PIPELINE2_WS_AUTHENTICATION%"
    %COMMAND%
    rem )
    

rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:END
    call:warn Exiting with value %exitCode%
    if not "%PAUSE%" == "" pause
    exit /b %exitCode%
