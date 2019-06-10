@echo off
SETLOCAL EnableDelayedExpansion
color A

::------------------------------------------
::
::					main
::
::------------------------------------------
set winnings=0

echo   _______________________________________________________________________________________________________________  
echo  /  ____________________________________________________________________________________________________________ \
echo ^|    _________                 ______      ________            _____________    ______      ________              ^|
echo ^|   ^|         \   ^|           /      \    ^|          ^|      /         ^|        /      \    ^|          ^|      /    ^|
echo ^|   ^|          ^|  ^|          /        \   ^|          ^|    /           ^|       /        \   ^|          ^|    /      ^|
echo ^|   ^|         /   ^|          ^|         ^|  ^|          ^|  /             ^|       ^|         ^|  ^|          ^|  /        ^|
echo ^|   ^|---------    ^|          ^|_________^|  ^|          ^|/               ^|       ^|_________^|  ^|          ^|/          ^|
echo ^|   ^|         \   ^|          ^|         ^|  ^|          ^|\               ^|       ^|         ^|  ^|          ^|\          ^|
echo ^|   ^|          ^|  ^|          ^|         ^|  ^|          ^|  \             ^|       ^|         ^|  ^|          ^|  \        ^|
echo ^|   ^|          ^|  ^|          ^|         ^|  ^|          ^|    \    \      ^|       ^|         ^|  ^|          ^|    \      ^|
echo ^|   ^|_________/   ^|________  ^|         ^|  ^|________  ^|      \   \_____/       ^|         ^|  ^|________  ^|      \    ^|
echo ^|  ____________________________________________________________________________________________________________   ^|
echo  \_______________________________________________________________________________________________________________/ 
echo.
set /p money=Enter how much money you'd like to start with: $
cls


:playAgain
set playerAceC=0
set dealerAceC=0
set double=1
set bet=0
echo -------------------------------------
echo Current money: $!money!
echo Current bet:   $!bet!
echo Winnings:      $!winnings!
echo -------------------------------------
echo.
if !money! LSS 1 (
	echo Sorry you don't have enough money to continue playing.
	echo Game over
	pause
	cls
	goto ending
)
echo make a bet or type "leave" to quit
echo.
set /p bet=How much would you like to bet: $
	
::determine if bet is valid
set /a money-=!bet!
if "!bet!" EQU "leave" (
	goto ending
)
if !money! LSS 0 (
	cls
	set /a money+=!bet!
	echo OH PLEASE. you don't have that much money
	echo Please enter a value less than !money!
	pause
	cls
	goto playAgain
) else if !bet! LSS 1 (
	cls
	echo Minimum bet is $1
	pause
	cls
	goto playAgain
)

set /a money+=!bet!
::determine if player has enough money to double down
set /a money-=!bet! + !bet!
if !money! LSS 0 (
	set /a double=-1	
)
set /a money+=!bet! + !bet!

cls

echo -------------------------------------
echo Current money: $!money!
echo Current bet:   $!bet!
echo Winnings:      $!winnings!
echo -------------------------------------
echo.


call :Reset
set dealerhand=0
set playerhand=0
set value=0

::------------------------------------------
::Deal hands
::------------------------------------------

::dealers hand
echo Dealer draws:
call :draw
set holder=1
call :isAce
call :drawDealerCards
set /a dealerhand+=value
set /a dealerShow=!dealerhand!

call :draw
call :isAce
set dealerCardS=!suite!
set dealerCardR=!rank!
set /a dealerhand+=!value!
echo.
echo dealer shows: !dealerShow!
pause
cls
if !dealerhand! EQU 21 (
	echo -------------------------------------
	echo Current money: $!money!
	echo Current bet:   $!bet!
	echo Winnings:      $!winnings!
	echo -------------------------------------
	echo.
	echo dealer has: !dealerhand!
	echo Dealers second card was:
	call :drawPlayingCard
	echo.
	echo Dealer has blackjack. Dealer wins.
	pause
	cls
	set /a money-=bet
	set /a winnings-=bet
	goto playAgain
)

echo -------------------------------------
echo Current money: $!money!
echo Current bet:   $!bet!
echo Winnings:      $!winnings!
echo -------------------------------------
echo.
echo Dealer shows: !dealerShow!
echo.

::players hand
echo You draw:
set holder=0
call :draw
call :isAce
set cardOneS=!suite!
set cardOneR=!rank!
set /a playerhand+=value
call :draw
call :drawPLayerCards
call :isAce
set /a playerhand+=value
echo.
echo You have: !playerhand!
if !playerhand! EQU 21 (
	echo You have blackjack. You win.
	pause
	cls
	set /a money+=bet * 2
	set /a winnings+=bet * 2
	goto playAgain
)
pause
cls

::----------------------------------------------------------------------------------------------
::Menu
::----------------------------------------------------------------------------------------------

:menu
echo -------------------------------------
echo Current money: $!money!
echo Current bet:   $!bet!
echo Winnings:      $!winnings!
echo -------------------------------------
echo.
echo Dealer shows: !dealerShow!
echo You have: !playerhand!
echo.
echo What would you like to do?
echo 1) Stand
echo 2) Hit
echo 3) Double down
set /p choice=:

if "!choice!" EQU "1" (
	::stand
	if !playerhand! LEQ 21 (
		call :dealerDraw
		pause
		cls
		goto playAgain
	) else (
		echo You bust. Dealer wins
		set /a money-=bet
		set /a winnings-=bet
	)
	pause
	cls
	goto playAgain
) else if "!choice!" EQU "2" (
	::hit
	cls
	echo -------------------------------------
	echo Current money: $!money!
	echo Current bet:   $!bet!
	echo Winnings:      $!winnings!
	echo -------------------------------------
	echo.
	echo Dealer shows: !dealerShow!
	echo You have: !playerhand!
	echo.
	set double=0
	echo You draw:
	call :draw
	call :drawPlayingCard
	set holder=0
	call :isAce
	echo.
	set /a playerhand+=value
	:aceLoop2
	if !playerAceC! GTR 0 (
		if !playerhand! GTR 21 (
			echo Your ace was converted to a 1
			set /a playerhand-=10
			set /a playerAceC-=1
			goto aceLoop2
		)
	)
	echo You have: !playerhand!
	if !playerhand! GTR 21 (
		echo You bust. Dealer wins
		pause
		set /a money-=bet
		set /a winnings-=bet
		cls
		goto playAgain
	)
	pause
	cls
	goto menu
) else if "!choice!" EQU "3" (
	::double down
	if !double! EQU 0 (
		echo You cannot double down after hitting.
		pause
		cls
		goto menu
	) else if !double! EQU -1 (
		echo You don't have enough money to double down.
		pause
		cls
		goto menu
	)
	cls
	echo -------------------------------------
	echo Current money: $!money!
	echo Current bet:   $!bet!
	echo Winnings:      $!winnings!
	echo -------------------------------------
	echo.
	echo Dealer shows !dealerShow!
	echo You have: !playerhand!
	echo.
	echo You draw:
	call :draw
	call :drawPlayingCard
	call :isAce
	echo.
	set /a playerhand+=value
	set /a bet+=bet
	
	::modify player score if they have an ace and are over 21
	:aceLoop1
	if !playerAceC! GTR 0 (
		if !playerhand! GTR 21 (
			set /a playerhand-=10
			set /a playerAceC-=1
			echo Your ace was converted to a 1
			goto aceLoop1
		)
	)
	echo You have: !playerhand!
	if !playerhand! LEQ 21 (
		pause
		call :dealerDraw
	) else (
		echo You bust. Dealer wins
		set /a money-=bet
		set /a winnings-=bet
	)
	pause
	cls
	goto playAgain
) else if "!choice!" EQU "help" (
	echo help
) else (
	echo invalid option!
	pause
	cls
	goto menu
)
pause
cls
goto menu

:ending
cls

echo   _______________________________________________________________________________________________________________  
echo  /  ____________________________________________________________________________________________________________ \
echo ^|    _________                 ______      ________            _____________    ______      ________              ^|
echo ^|   ^|         \   ^|           /      \    ^|          ^|      /         ^|        /      \    ^|          ^|      /    ^|
echo ^|   ^|          ^|  ^|          /        \   ^|          ^|    /           ^|       /        \   ^|          ^|    /      ^|
echo ^|   ^|         /   ^|          ^|         ^|  ^|          ^|  /             ^|       ^|         ^|  ^|          ^|  /        ^|
echo ^|   ^|---------    ^|          ^|_________^|  ^|          ^|/               ^|       ^|_________^|  ^|          ^|/          ^|
echo ^|   ^|         \   ^|          ^|         ^|  ^|          ^|\               ^|       ^|         ^|  ^|          ^|\          ^|
echo ^|   ^|          ^|  ^|          ^|         ^|  ^|          ^|  \             ^|       ^|         ^|  ^|          ^|  \        ^|
echo ^|   ^|          ^|  ^|          ^|         ^|  ^|          ^|    \    \      ^|       ^|         ^|  ^|          ^|    \      ^|
echo ^|   ^|_________/   ^|________  ^|         ^|  ^|________  ^|      \   \_____/       ^|         ^|  ^|________  ^|      \    ^|
echo ^|  ____________________________________________________________________________________________________________   ^|
echo  \_______________________________________________________________________________________________________________/ 
echo.
echo                                                  You made: $!winnings!
echo                                         You walked out of here with: $!money!
echo.
pause
cls

endlocal
exit 0

::------------------------------------------
::
::					Functions
::
::------------------------------------------

::--------------------------------------
::function that draws cards for dealer and see who wins
::--------------------------------------
:dealerDraw
::reveal dealers second card
set suite=!dealerCardS!
set rank=!dealerCardR!
cls
echo -------------------------------------
echo Current money: $!money!
echo Current bet:   $!bet!
echo Winnings:      $!winnings!
echo -------------------------------------
echo.
echo Dealer shows !dealerShow!
echo You have: !playerhand!
echo.
echo Dealers second card is:
call :drawPlayingCard
echo.
echo Dealer has: !dealerhand!
pause
:redraw
cls
call :drawUI
if !dealerhand! LSS 16 (
	if !dealerhand! GTR !playerhand! (
		echo Dealer's hand is bigger. Dealer Wins. 
		pause
		set /a money-=bet
		set /a winnings-=bet
		cls
		goto playAgain
	)
	echo dealer draws:
	set holder=1
	call :draw
	call :drawPlayingCard
	call :isAce
	echo.
	set /a dealerhand+=value
	echo dealer has: !dealerhand!
	pause
	goto redraw
) else if !dealerhand! GTR 21 (
	:aceLoop4
	if !dealerAceC! GTR 0 (
		if !dealerhand! GTR 21 (
			echo.
			echo Dealer's ace was converted to a 1
			set /a dealerhand-=10
			set /a dealerAceC-=1
			goto aceLoop4
		)
	)
	if !dealerhand! LSS 22 (
		goto redraw
	)
	echo Dealer busts. You win.
	set /a money+=bet
	set /a winnings+=bet
	pause
	cls
	goto playAgain
)
		
if !playerhand! GTR !dealerhand! (
	if !dealerhand! LSS 21 (
		echo Dealer draws:
		set holder=1
		call :draw
		call :isAce
		call :drawPlayingCard
		set /a dealerhand+=value
		:aceLoop3
		if !dealerAceC! GTR 0 (
			if !dealerhand! GTR 21 (
				echo.
				echo Dealer's ace was converted to a 1
				set /a dealerhand-=10
				set /a dealerAceC-=1
				goto aceLoop3
			)
		)
		echo.
		echo Dealer has: !dealerhand!
		pause
		goto redraw
	)
	echo Your hand is bigger. You win.
	set /a money+=bet
	set /a winnings+=bet
) else if !playerhand! EQU !dealerhand! (
	echo Tie. No winners.
) else (
	echo Dealer's hand is bigger. You lose.
	set /a money-=bet
	set /a winnings-=bet
)
exit /B 0

::--------------------------------------
::function to draw the ui
::--------------------------------------
:drawUI
echo -------------------------------------
echo Current money: $!money!
echo Current bet:   $!bet!
echo Winnings:      $!winnings!
echo -------------------------------------
echo.
echo Dealer has: !dealerhand!
echo You have: !playerhand!
echo.
exit /B 0

::--------------------------------------
::function to draw a cards
::--------------------------------------
:draw
set /a suite=%random% %% 4 
set /a rank=%random% %% 13 + 1

::determine if card has already been drawn
if !suite! EQU 0 (
	if !spades[%rank%]! EQU 1 (
		goto draw
	) else (
		set spades[!rank!]=1
	)
) else if !suite! EQU 1 (
	if !hearts[%rank%]! EQU 1 (
		goto draw
	) else (
		set hearts[!rank!]=1
	)
) else if !suite! EQU 2 (
	if !diamonds[%rank%]! EQU 1 (
		goto draw
	) else (
		set diamonds[!rank!]=1
	)
) else (
	if !clubs[%rank%]! EQU 1 (
		goto draw
	) else (
		set clubs[!rank!]=1
	)
)



if !rank! EQU 11 (
	set value=10
) else if !rank! EQU 12 (
	set value=10
) else if !rank! EQU 13 (
	set value=10
) else if !rank! EQU 1 (
	set value=11
) else (
	set value=!rank!
)	
exit /B 0

::--------------------------------------
::function to reset 2d arrays holding all cards
::--------------------------------------
:isAce
if !rank! EQU 1 (
	if !holder! EQU 0 (
		set /a playerAceC+=1
	) else (
		set /a dealerAceC+=1
	)
)
exit /B 0

::--------------------------------------
::function to reset 2d arrays holding all cards
::--------------------------------------
:Reset
::spades
for /l %%x in (1,1,13) do (
	set spades[%%x]=0
)

::hearts
for /l %%x in (1,1,13) do (
	set hearts[%%x]=0
)

::diamonds
for /l %%x in (1,1,13) do (
	set diamonds[%%x]=0
)

::clubs
for /l %%x in (1,1,13) do (
	set clubs[%%x]=0
)
exit /B 0

::------------------------------------------
::
::		Functions to draw cards to screen
::
::------------------------------------------

:drawPLayerCards
echo   ______________     ______________
echo  ^|              ^|   ^|              ^|
if !rank! EQU 1 (
	if !cardOneR! EQU 1 (
		echo  ^| A            ^|   ^| A            ^|
	) else if !cardOneR! EQU 10 (
		echo  ^| A            ^|   ^| 10           ^|
	) else if !cardOneR! EQU 11 (
		echo  ^| A            ^|   ^| J            ^|
	) else if !cardOneR! EQU 12 (
		echo  ^| A            ^|   ^| Q            ^|
	) else if !cardOneR! EQU 13 (
		echo  ^| A            ^|   ^| K            ^|
	) else (
		echo  ^| A            ^|   ^| !cardOneR!            ^|
	)
) else if !rank! EQU 10 (
	if !cardOneR! EQU 1 (
		echo  ^| 10           ^|   ^| A            ^|
	) else if !cardOneR! EQU 10 (
		echo  ^| 10           ^|   ^| 10           ^|
	) else if !cardOneR! EQU 11 (
		echo  ^| 10           ^|   ^| J            ^|
	) else if !cardOneR! EQU 12 (
		echo  ^| 10           ^|   ^| Q            ^|
	) else if !cardOneR! EQU 13 (
		echo  ^| 10           ^|   ^| K            ^|
	) else (
		echo  ^| 10           ^|   ^| !cardOneR!            ^|
	)
) else if !rank! EQU 11 (
	if !cardOneR! EQU 1 (
		echo  ^| J            ^|   ^| A            ^|
	) else if !cardOneR! EQU 10 (
		echo  ^| J            ^|   ^| 10           ^|
	) else if !cardOneR! EQU 11 (
		echo  ^| J            ^|   ^| J            ^|
	) else if !cardOneR! EQU 12 (
		echo  ^| J            ^|   ^| Q            ^|
	) else if !cardOneR! EQU 13 (
		echo  ^| J            ^|   ^| K            ^|
	) else (
		echo  ^| J            ^|   ^| !cardOneR!            ^|
	)
) else if !rank! EQU 12 (
	if !cardOneR! EQU 1 (
		echo  ^| Q            ^|   ^| A            ^|
	) else if !cardOneR! EQU 10 (
		echo  ^| Q            ^|   ^| 10           ^|
	) else if !cardOneR! EQU 11 (
		echo  ^| Q            ^|   ^| J            ^|
	) else if !cardOneR! EQU 12 (
		echo  ^| Q            ^|   ^| Q            ^|
	) else if !cardOneR! EQU 13 (
		echo  ^| Q            ^|   ^| K            ^|
	) else (
		echo  ^| Q            ^|   ^| !cardOneR!            ^|
	)
) else if !rank! EQU 13 (
	if !cardOneR! EQU 1 (
		echo  ^| K            ^|   ^| A            ^|
	) else if !cardOneR! EQU 10 (
		echo  ^| K            ^|   ^| 10           ^|
	) else if !cardOneR! EQU 11 (
		echo  ^| K            ^|   ^| J            ^|
	) else if !cardOneR! EQU 12 (
		echo  ^| K            ^|   ^| Q            ^|
	) else if !cardOneR! EQU 13 (
		echo  ^| K            ^|   ^| K            ^|
	) else (
		echo  ^| K            ^|   ^| !cardOneR!            ^|
	)
) else (
	if !cardOneR! EQU 1 (
		echo  ^| !rank!            ^|   ^| A            ^|
	) else if !cardOneR! EQU 10 (
		echo  ^| !rank!            ^|   ^| 10           ^|
	) else if !cardOneR! EQU 11 (
		echo  ^| !rank!            ^|   ^| J            ^|
	) else if !cardOneR! EQU 12 (
		echo  ^| !rank!            ^|   ^| Q            ^|
	) else if !cardOneR! EQU 13 (
		echo  ^| !rank!            ^|   ^| K            ^|
	) else (
		echo  ^| !rank!            ^|   ^| !cardOneR!            ^|
	)
)
echo  ^|              ^|   ^|              ^|
echo  ^|              ^|   ^|              ^|
echo  ^|              ^|   ^|              ^|
if !suite! EQU 0 (
	if !cardOneS! EQU 0 (
		echo  ^|    Spades    ^|   ^|    Spades    ^|
	) else if !cardOneS! EQU 1 (
		echo  ^|    Spades    ^|   ^|    Hearts    ^|
	) else if !cardOneS! EQU 2 (
		echo  ^|    Spades    ^|   ^|   Diamonds   ^|
	) else (
		echo  ^|    Spades    ^|   ^|    Clubs     ^|
	)
) else if !suite! EQU 1 (
	if !cardOneS! EQU 0 (
		echo  ^|    Hearts    ^|   ^|    Spades    ^|
	) else if !cardOneS! EQU 1 (
		echo  ^|    Hearts    ^|   ^|    Hearts    ^|
	) else if !cardOneS! EQU 2 (
		echo  ^|    Hearts    ^|   ^|   Diamonds   ^|
	) else (
		echo  ^|    Hearts    ^|   ^|    Clubs     ^|
	)
) else if !suite! EQU 2 (
	if !cardOneS! EQU 0 (
		echo  ^|   Diamonds   ^|   ^|    Spades    ^|
	) else if !cardOneS! EQU 1 (
		echo  ^|   Diamonds   ^|   ^|    Hearts    ^|
	) else if !cardOneS! EQU 2 (
		echo  ^|   Diamonds   ^|   ^|   Diamonds   ^|
	) else (
		echo  ^|   Diamonds   ^|   ^|    Clubs     ^|
	)
) else (
	if !cardOneS! EQU 0 (
		echo  ^|    Clubs     ^|   ^|    Spades    ^|
	) else if !cardOneS! EQU 1 (
		echo  ^|    Clubs     ^|   ^|    Hearts    ^|
	) else if !cardOneS! EQU 2 (
		echo  ^|    Clubs     ^|   ^|   Diamonds   ^|
	) else (
		echo  ^|    Clubs     ^|   ^|    Clubs     ^|
	)
)
echo  ^|              ^|   ^|              ^|
echo  ^|              ^|   ^|              ^|
echo  ^|              ^|   ^|              ^|
if !rank! EQU 1 (
	if !cardOneR! EQU 1 (
		echo  ^|            A ^|   ^|            A ^|
	) else if !cardOneR! EQU 10 (
		echo  ^|            A ^|   ^|            J ^|
	) else if !cardOneR! EQU 11 (
		echo  ^|            A ^|   ^|           10 ^|
	) else if !cardOneR! EQU 12 (
		echo  ^|            A ^|   ^|            Q ^|
	) else if !cardOneR! EQU 13 (
		echo  ^|            A ^|   ^|            K ^|
	) else (
		echo  ^|            A ^|   ^|            !cardOneR! ^|
	)
) else if !rank! EQU 10 (
	if !cardOneR! EQU 1 (
		echo  ^|           10 ^|   ^|            A ^|
	) else if !cardOneR! EQU 10 (
		echo  ^|           10 ^|   ^|            J ^|
	) else if !cardOneR! EQU 11 (
		echo  ^|           10 ^|   ^|           10 ^|
	) else if !cardOneR! EQU 12 (
		echo  ^|           10 ^|   ^|            Q ^|
	) else if !cardOneR! EQU 13 (
		echo  ^|           10 ^|   ^|            K ^|
	) else (
		echo  ^|           10 ^|   ^|            !cardOneR! ^|
	)
) else if !rank! EQU 11 (
	if !cardOneR! EQU 1 (
		echo  ^|            J ^|   ^|            A ^|
	) else if !cardOneR! EQU 10 (
		echo  ^|            J ^|   ^|            J ^|
	) else if !cardOneR! EQU 11 (
		echo  ^|            J ^|   ^|           10 ^|
	) else if !cardOneR! EQU 12 (
		echo  ^|            J ^|   ^|            Q ^|
	) else if !cardOneR! EQU 13 (
		echo  ^|            J ^|   ^|            K ^|
	) else (
		echo  ^|            J ^|   ^|            !cardOneR! ^|
	)
) else if !rank! EQU 12 (
	if !cardOneR! EQU 1 (
		echo  ^|            Q ^|   ^|            A ^|
	) else if !cardOneR! EQU 10 (
		echo  ^|            Q ^|   ^|            J ^|
	) else if !cardOneR! EQU 11 (
		echo  ^|            Q ^|   ^|           10 ^|
	) else if !cardOneR! EQU 12 (
		echo  ^|            Q ^|   ^|            Q ^|
	) else if !cardOneR! EQU 13 (
		echo  ^|            Q ^|   ^|            K ^|
	) else (
		echo  ^|            Q ^|   ^|            !cardOneR! ^|
	)
) else if !rank! EQU 13 (
	if !cardOneR! EQU 1 (
		echo  ^|            K ^|   ^|            A ^|
	) else if !cardOneR! EQU 10 (
		echo  ^|            K ^|   ^|            J ^|
	) else if !cardOneR! EQU 11 (
		echo  ^|            K ^|   ^|           10 ^|
	) else if !cardOneR! EQU 12 (
		echo  ^|            K ^|   ^|            Q ^|
	) else if !cardOneR! EQU 13 (
		echo  ^|            K ^|   ^|            K ^|
	) else (
		echo  ^|            K ^|   ^|            !cardOneR! ^|
	)
) else (
	if !cardOneR! EQU 1 (
		echo  ^|            !rank! ^|   ^|            A ^|
	) else if !cardOneR! EQU 10 (
		echo  ^|            !rank! ^|   ^|            J ^|
	) else if !cardOneR! EQU 11 (
		echo  ^|            !rank! ^|   ^|           10 ^|
	) else if !cardOneR! EQU 12 (
		echo  ^|            !rank! ^|   ^|            Q ^|
	) else if !cardOneR! EQU 13 (
		echo  ^|            !rank! ^|   ^|            K ^|
	) else (
		echo  ^|            !rank! ^|   ^|            !cardOneR! ^|
	)
)
echo  ^|______________^|   ^|______________^|
exit /B 0


:drawDealerCards
echo   ______________     ______________
echo  ^|              ^|   ^|  __________  ^|
if !rank! EQU 1 (
	echo  ^| A            ^|   ^| ^|          ^| ^|
) else if !rank! EQU 10 (
	echo  ^| 10           ^|   ^| ^|          ^| ^|
) else if !rank! EQU 11 (
	echo  ^| J            ^|   ^| ^|          ^| ^|
) else if !rank! EQU 12 (
	echo  ^| Q            ^|   ^| ^|          ^| ^|
) else if !rank! EQU 13 (
	echo  ^| K            ^|   ^| ^|          ^| ^|
) else (
	echo  ^| !rank!            ^|   ^| ^|          ^| ^|
)
echo  ^|              ^|   ^| ^| ^* ^* ^* ^* ^*^| ^|
echo  ^|              ^|   ^| ^|^* ^* ^* ^* ^* ^| ^|
echo  ^|              ^|   ^| ^| ^* ^* ^* ^* ^*^| ^|
if !suite! EQU 0 (
	echo  ^|    Spades    ^|   ^| ^|^* ^* ^* ^* ^* ^| ^|
) else if !suite! EQU 1 (
	echo  ^|    Hearts    ^|   ^| ^|^* ^* ^* ^* ^* ^| ^|
) else if !suite! EQU 2 (
	echo  ^|   Diamonds   ^|   ^| ^|^* ^* ^* ^* ^* ^| ^|
) else (
	echo  ^|    Clubs     ^|   ^| ^|^* ^* ^* ^* ^* ^| ^|
)
echo  ^|              ^|   ^| ^| ^* ^* ^* ^* ^*^| ^|
echo  ^|              ^|   ^| ^|^* ^* ^* ^* ^* ^| ^|
echo  ^|              ^|   ^| ^| ^* ^* ^* ^* ^*^| ^|
if !rank! EQU 1 (
	echo  ^|            A ^|   ^| ^|__________^| ^|
) else if !rank! EQU 10 (
	echo  ^|           10 ^|   ^| ^|__________^| ^|
) else if !rank! EQU 11 (
	echo  ^|            J ^|   ^| ^|__________^| ^|
) else if !rank! EQU 12 (
	echo  ^|            Q ^|   ^| ^|__________^| ^|
) else if !rank! EQU 13 (
	echo  ^|            K ^|   ^| ^|__________^| ^|
) else (
	echo  ^|            !rank! ^|   ^| ^|__________^| ^|
)
echo  ^|______________^|   ^|______________^|
exit /B 0

:drawPlayingCard
echo   ______________
echo  ^|              ^|
if !rank! EQU 1 (
	echo  ^| A            ^|
) else if !rank! EQU 10 (
	echo  ^| 10           ^|
) else if !rank! EQU 11 (
	echo  ^| J            ^|
) else if !rank! EQU 12 (
	echo  ^| Q            ^|
) else if !rank! EQU 13 (
	echo  ^| K            ^|
) else (
	echo  ^| !rank!            ^|
)
echo  ^|              ^|
echo  ^|              ^|
echo  ^|              ^|
if !suite! EQU 0 (
	echo  ^|    Spades    ^|
) else if !suite! EQU 1 (
	echo  ^|    Hearts    ^|
) else if !suite! EQU 2 (
	echo  ^|   Diamonds   ^|
) else (
	echo  ^|    Clubs     ^|
)
echo  ^|              ^|
echo  ^|              ^|
echo  ^|              ^|
if !rank! EQU 1 (
	echo  ^|            A ^|
) else if !rank! EQU 10 (
	echo  ^|           10 ^|
) else if !rank! EQU 11 (
	echo  ^|            J ^|
) else if !rank! EQU 12 (
	echo  ^|            Q ^|
) else if !rank! EQU 13 (
	echo  ^|            K ^|
) else (
	echo  ^|            !rank! ^|
)
echo  ^|______________^|
exit /B 0