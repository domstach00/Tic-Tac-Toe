.data 
	defOne:		.word '1'
	defTwo:		.word '2'
	defThree:	.word '3'
	defFour:	.word '4'
	defFive:	.word '5'
	defSix:		.word '6'
	defSeven:	.word '7'
	defEight:	.word '8'
	defNine:	.word '9'
	one:		.word '1'
	two:		.word '2'
	three:		.word '3'
	four:		.word '4'
	five:		.word '5'
	six:		.word '6'
	seven:		.word '7'
	eight:		.word '8'
	nine:		.word '9'
	map:		.word one, two, three, four, five, six, seven, eight, nine
	iterator:	.word 0
	size:		.word 9
	space:		.asciiz " "
	nLine:		.asciiz "\n"
	startMessage:	.asciiz "\nWitaj w grze kolko i krzyzyk\nWpisz liczbe rund ile chcesz rozegrac (max rund 5):\t"
	choseSite:	.asciiz "\nWybierz swoj znak wpisujac 'X' albo 'O':\t"
	input:		.asciiz "\nWpisz numer pola od 1 do 9\t"
	winPlayer1:	.asciiz "\nGracz 1 wygral"
	winPlayer2:	.asciiz "\nGracz 2 wygral"
	playAgain:	.asciiz "\nKoniec gry, czy chcesz zagrac ponownie?\t"
	player1:	.space 4
	player2:	.space 4
	errorChose:	.asciiz "\nNiepoprawnie wybrany znak\n"
	wordX:		.ascii "X"
	wordY:		.ascii "O"
	M1:		.asciiz "Gracz 1: \t"
	M2:		.asciiz "Gracz 2: \t"
	patMessage:	.asciiz "\nSytuacja patowa\n"
	infoPlayer1:	.asciiz "\nRuch wykonuje gracz 1"
	infoPlayer2:	.asciiz "\nRuch wykonuje gracz 2"
	newRoundMessage:.asciiz "\nRozpoczecie nowej rundy!\n"
	endGameMes:	.asciiz "\nKoniec gry"
	winMes:		.asciiz "\nKoniec rundy\n"
	winnerMessageA:	.asciiz "Uzytkownik zdobywa punkt!\n"
	winnerMessageB:	.asciiz "Bot zdobywa punkt!\n"
	statsA:		.asciiz "\nPunkty Gracza:	"
	statsB:		.asciiz "\nPunkty Komputera:	"
	
.text 
	main:
		la $a0, startMessage
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move $t8, $v0 # t8 przechowywa ilosc rund
		bgt $t8, 5, main
		blt $t8, 0, main
		
	start:
		jal setDefoultValues # ustawienie wartosci domyslnych
		# wybieranie X albo O przez gracza
		la $a0, choseSite
		li $v0, 4
		syscall
		
		li $v0, 8
		la $a0, player1
		li $a1, 4
		syscall
		
		lb $s0, player1($zero)
		lb $s1, player2($zero)
		
		# przypisanie przeciwnego znaku dla bota
		beq $s0, 'X', setOtoPlayer2
		beq $s0, 'x', setOtoPlayer2
		beq $s0, 'O', setXtoPlayer2
		beq $s0, 'o', setXtoPlayer2
		
		li $v0, 4
		la $a0, errorChose
		syscall
		j start
			
	
	
	setDefoultValues: # ustawienie wartosci domyslnych na planszy
		move $t9, $zero
		move $t7, $zero
		
		lw $t5, defOne
		sb $t5, one
		
		lw $t5, defTwo
		sb $t5, two
		
		lw $t5, defThree
		sb $t5, three
		
		lw $t5, defFour
		sb $t5, four
		
		lw $t5, defFive
		sb $t5, five
		
		lw $t5, defSix
		sb $t5, six
		
		lw $t5, defSeven
		sb $t5, seven
		
		lw $t5, defEight
		sb $t5, eight
		
		lw $t5, defNine
		sb $t5, nine
		
		jr $ra
	
	
	setOtoPlayer2:	# ustawienie Y jako znaku bota
		lb $s1, wordY
		sb $s1, player2
		j showSites

	setXtoPlayer2: # ustawienie X jako znaku bota
		lb $s1, wordX
		sb $s1, player2
		j showSites
		
		
	showSites: # pokazuje kto ma jaki znak ( X O )
		li $v0, 4
		la $a0, M1
		syscall
		
		li $v0, 4
		la $a0, player1
		syscall
		
		
		li $v0, 4
		la $a0, M2
		syscall
		
		li $v0, 4
		la $a0, player2
		syscall
		
		j loadMap # pokazanie planszy
		
		
	newRound: # utawienie nowej rundy
		subi  $t8, $t8, 1 # jesli runda sie konczy to ilosc rund zmniejsza sie o 1
		beqz $t8, end
		
		la $a0, newRoundMessage
		li $v0, 4
		syscall
		j start
		
		
	pat: # pat wystepuje gdy wszystkie miejsca na planszy sa pelne
		li $v0, 4
		la $a0, patMessage
		syscall
		j newRound

	checkWin: # sprawdzanie czy gra zostala wygrana
		# przy kazdym sprawdzeniu wygranej informacja o wykonanych ruchach sie zwieksza
		addi $t9, $t9, 1
		addi $t7, $t7, 1
		
	w1:
		lw $t5, one
		bne $t5, $s3, w2
		
	w13:
		lw $t5, two
		bne $t5, $s3, w19
		lw $t5, three
		beq $t5, $s3, win
		
	w19:
		lw $t5, five
		bne $t5, $s3, w17
		lw $t5, nine
		beq $t5, $s3, win
		
	w17:
		lw $t5, four
		bne $t5, $s3, w2
		lw $t5, seven
		beq $t5, $s3, win
		
	w2:
		lw $t5, two
		bne $t5, $s3, w3
		
	w28:
		lw $t5, five
		bne $t5, $s3, w3
		lw $t5, eight
		beq $t5, $s3, win
		
	w3:
		lw $t5, three
		bne $t5, $s3, w4
		
	w39:
		lw $t5, six
		bne $t5, $s3, w4
		lw $t5, nine
		beq $t5, $s3, win
		
	w37:
		lw $t5, five
		bne $t5, $s3, w4
		lw $t5, seven
		beq $t5, $s3, win
		
	w4:
		lw $t5, four
		bne $t5, $s3, w7
		
	w46:
		lw $t5, five
		bne $t5, $s3, w7
		lw $t5, six
		beq $t5, $s3, win
		
	w7:
		lw $t5, seven
		bne $t5, $s3, makeMove1
		
	w79:
		lw $t5, eight
		bne $t5, $s3, makeMove1
		lw $t5, nine
		beq $t5, $s3, win
		
		j makeMove1
		
	
	win: # wygrana
		la $a0, winMes
		li $v0, 4
		syscall
		
		beq $s0, $s3, winnerA
		j winnerB
		
		
	winnerA: # wygrana uzytkownika
		la $a0, winnerMessageA
		li $v0, 4
		syscall
		
		addi $s5, $s5, 1
		
		j stats
	
	winnerB: # wygrana bota
		la $a0, winnerMessageB
		li $v0, 4
		syscall
		
		addi $s6 $s6, 1
		
		j stats
		
		
	stats: # statystyki
		la $a0, statsA
		li $v0, 4
		syscall
		
		move $a0, $s5
		li $v0, 1
		syscall
		
		la $a0, statsB
		li $v0, 4
		syscall
		
		move $a0, $s6
		li $v0, 1
		syscall
		
		
		j newRound
		
	
	
	makeMove1: # poczatek wykonywania ruchu
		beq $t9, 10, pat
		
		beq $t7, 1, playerMove
		beq $t7, 3, playerMove
		beq $t7, 5, playerMove
		beq $t7, 7, playerMove
		beq $t7, 9, playerMove
		
		j botMove
		
	makeMove2: #kolejna czesc wykonywania ruchu
		
		la $a0, input
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		move $t4, $v0

		beq $t4, 1, set1
		beq $t4, 2, set2
		beq $t4, 3, set3
		beq $t4, 4, set4
		beq $t4, 5, set5
		beq $t4, 6, set6
		beq $t4, 7, set7
		beq $t4, 8, set8
		beq $t4, 9, set9
		
		j errorMove
		
	errorMove: # blad podczas ruchu
		la $a0, errorChose
		li $v0, 4
		syscall
		
		j makeMove1
		
		
	botMove: # ruch bota
		move $s3, $s1
	
		la $a0, infoPlayer2
		li $v0, 4
		syscall
		
		j tactik1
		
	tactik1: # taktyka ktora bot przyjmuje
		lw $t5, eight
		lw $t6 defEight
		beq $t5, $t6, set8
		
		lw $t5, nine
		lw $t6 defNine
		beq $t5, $t6, set9
		
		lw $t5, seven
		lw $t6 defSeven
		beq $t5, $t6, set7
		
		lw $t5, five
		lw $t6 defFive
		beq $t5, $t6, set5
		
		lw $t5, one
		lw $t6 defOne
		beq $t5, $t6, set1
		
		lw $t5, two
		lw $t6 defTwo
		beq $t5, $t6, set2
		
		lw $t5, three
		lw $t6 defThree
		beq $t5, $t6, set3
		
		lw $t5, six
		lw $t6 defSix
		beq $t5, $t6, set6
		
		lw $t5, four
		lw $t6 defFour
		beq $t5, $t6, set4
		
		j makeMove2
		
		
	playerMove: # ruch gracza 
		la $a0, infoPlayer1
		li $v0, 4
		syscall
		
		move $s3, $s0
		j makeMove2
		

	set1: # sutawienie pola 1
		lw $t5, one
		lw $t6 defOne
		bne $t5, $t6, errorMove
		
		sb $s3, one
		j loadMap
		
	set2: # sutawienie pola 2
		lw $t5, two
		lw $t6 defTwo
		bne $t5, $t6, errorMove
		
		sb $s3, two	
		j loadMap
		
	set3: # sutawienie pola 3
		lw $t5, three
		lw $t6 defThree
		bne $t5, $t6, errorMove
		
		sb $s3, three
		j loadMap
		
	set4: # sutawienie pola 4
		lw $t5, four
		lw $t6 defFour
		bne $t5, $t6, errorMove
		
		sb $s3, four
		j loadMap
		
	set5: # sutawienie pola 5
		lw $t5, five
		lw $t6 defFive
		bne $t5, $t6, errorMove
		
		la $t0, map
		lb $t5, 0($t3)
		#bne $t5, 5, errorMove
		
		sb $s3, five
		j loadMap
		
	set6: # sutawienie pola 6
		lw $t5, six
		lw $t6 defSix
		bne $t5, $t6, errorMove
		
		sb $s3, six
		j loadMap
		
	set7: # sutawienie pola 7
		lw $t5, seven
		lw $t6 defSeven
		bne $t5, $t6, errorMove
		
		sb $s3, seven
		j loadMap

	set8: # sutawienie pola 8
		lw $t5, eight
		lw $t6 defEight
		bne $t5, $t6, errorMove
		
		sb $s3, eight
		j loadMap
		
	set9: # sutawienie pola 9
		lw $t5, nine
		lw $t6 defNine
		bne $t5, $t6, errorMove
		
		sb $s3, nine
		j loadMap
		
		

	loadMap: # t0 - map, t1 - iterator t2 - rozmiar	
		la $t0, map
		lw $t1, iterator
		lw $t2, size
		
		la $a0, nLine
		li $v0, 4
		syscall
		
		j conditionLoop
		
		
	conditionLoop: # sprawdzanie warunkow petli
		bge $t1, $t2, checkWin
		beq $t1, 3, newLine
		beq $t1, 6, newLine
		j loop
		
	loop: # petla ktora wyswietla plansze
		sll $t3, $t1, 2
		addu $t3, $t3, $t0
		
		li $v0, 4
		lw $a0, 0($t3)
		syscall 
		
		addi $t1, $t1, 1
		
		j addSpace
	
	
	newLine: # nowa linia przy wyswietlaniu
		la $a0, nLine
		li $v0, 4
		syscall
		
		j loop
		
	addSpace:
		la $a0, space
		li $v0, 4
		syscall
		
		j conditionLoop
		
		
	end: # koniec programu
		la $a0, endGameMes
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall
	
	
