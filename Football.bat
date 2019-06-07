@echo off
setlocal EnableDelayedExpansion
set /a playerscore=0
set /a compscore=0
set /a plays=100
set quarter=1st
set down=1st
set ballLocation=0
set firstDown=10

::debug menu skip
::set playerTeam=Player Team
::set compName=CPU Team
::goto debug


:mainMenu
cls
echo.
echo.
echo.
echo --------------------------------------------------------------------------------
echo.
echo                             -----FOOTBALL GAME-----
echo.
echo --------------------------------------------------------------------------------
echo.
echo                                 version 0.0.5
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set /p enter=-----------------------------Press enter to begin-------------------------------
cls

echo ------------------------------------Main Menu-----------------------------------
echo.
echo 1: Start a new game
echo.
echo 2: help
echo.
echo 3: Exit
echo.
echo.
echo.
set /p menu= :

:nameteam
cls
if %menu%==1 (
	echo Please enter the name of your team
	set /p playerTeam= :
	cls
	echo are you sure you want your team name to be The !playerTeam!? You will not be 
	echo able to change this later. (y/n^)
	set /p ready= :
	if "%ready%"=="n" (
		goto nameteam
	) else if "!ready!"=="no" (
		goto nameteam
	) else (
		goto coinFlip
	)
) else if %menu%==2 (
	goto help
) else if %menu%==3 (
	endlocal
	exit 0
) else (
	echo defense
)

:help
echo dis gunna be da rule page
pause
goto mainMenu

:coinFlip
::
::set computer team name
::
set /a comp=%random% %% 10
if %comp%==0 (
	set compName= Minnesota Vikings
) else if %comp%==1 (
	set compName=Chicago Bears
) else if %comp%==2 (
	set compName=Baltimore Ravens
) else if %comp%==3 (
	set compName=Green Bay Packers
) else if %comp%==4 (
	set compName=Cincinnati Bengals
) else if %comp%==4 (
	set compName=Detroit Lions
) else if %comp%==5 (
	set compName=Atlanta Falcons
) else if %comp%==6 (
	set compName=Houston Texans
) else if %comp%==7 (
	set compName=Indianapolis Colts
) else if %comp%==8 (
	set compName=Carolina Panthers
) else if %comp%==9 (
	set compName=Houston Texans
) else if %comp%==10 (
	set compName=DIDNT KNOW THIS COULD HAPPEN
)

:debug

:headsTails
cls
echo Todays game is against the %playerTeam% and the !compName!
echo.
echo.
echo                            It's time for the coin toss^!
echo.
echo %playerTeam% would you heads or tails?
set /p coin=:
if "%coin%"=="heads" (
	set /a flip=1
) else if "%coin%"=="tails" (
	set /a flip=2
) else (
	cls
	echo I'm sorry please enter "heads" or "tails"
	goto headstails
)

set /a cointoss= %random% %% 2 + 1
cls
:cointosswin
if "%flip%"=="%cointoss%" (
	echo The %playerTeam% have won the coin toss^!
	echo.
	echo What would you like to do?
	echo.
	echo 1: Kick
	echo.
	echo 2: Recieve
	echo.
	set /p coinWin=:
	if !coinWin!==1 (
		set /a kickoff=1
	) else if !coinWin!==2 (
		set /a kickoff=2
	) else (
		echo invalid answer^! please try again...
		pause
		cls
		goto cointosswin
	)
) else (
	echo The !compName! have won the coin toss.
	echo.
	set /a cputoss=%random% %% 2 + 1
	if !cputoss!==1 (
		set /a kickoff=2
		echo They have chosen to Kickoff
	) else (
		set /a kickoff=1
		echo They have chosen to Recieve
	)
	pause
)
goto kickoff

:kickoff
cls
echo --------------------------------------------------------------------------------
echo %playerTeam%:!playerscore! ^| !compName!:!compscore! ^| 
echo -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   
echo !quarter! quarter ^| Plays remaining: !plays! ^| ball on !ballLocation! ^| !down! and !firstDown!
echo --------------------------------------------------------------------------------
if !kickoff!==1 (
	echo                    --Pick a Play--
	echo.
	echo 1: normal kickoff
	echo 2: onside kickoff
	echo 3: help
	echo.
	set /p choice=:
	if !choice!==1 (
		echo normal kickoff
		pause
	) else if !choice!==2 (
		echo onside kickoff
		pause
	) else if !choice!==3 (
		cls
		echo help 
		pause
	) else (
		echo Invalid answer...
		pause
		goto kickoff
	)
) else (
	echo recieve
)

:offense


:defense


:fieldGoal


:endgame


endlocal
echo -end of file-
pause
exit 0

::Header template
echo --------------------------------------------------------------------------------
echo %playerTeam%:!playerscore! ^| !compName!:!compscore! ^| 
echo -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   
echo !quarter! quarter ^| Plays remaining: !plays! ^| ball on !ballLocation! ^| !down! and !firstDown!
echo --------------------------------------------------------------------------------
