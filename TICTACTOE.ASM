;/**
; * @package            Tic Tac Toe - 8086 Assembly
; * @author             TechieForFun - https://techieforfun.com
; * @license            The Unlicense - http://unlicense.org
; * @copyright          Public Domain - All Rights Reserved Forever
; * @version            1.0.0
; * @comment            Thanks to Open Source Community
; */

title Console Based Tic Tac Toe In Assembly
include io.h

prntstr macro msg; macro to print a message
	lea dx,msg
	mov ah,9
	int 21h
endm

readstr macro str,len; macro to read a string
	lea dx,str; of length len-3
	mov str,len
	mov ah,10
	int 21h
endm

cr equ 0dh; carriage return character
lf equ 10; linefeed character

mystacks segment stack
	dw 100h dup (?)
mystacks ends

mydata segment
	a db '1'
	b db '2'
	c db '3'
	d db '4'
	e db '5'
	f db '6'
	g db '7'
	h db '8'
	i db '9'
	cha db ?; Gamer character
	inpu db ?; Input 
	winner db ?
	uh db ?; Previous Moving
	help db ?; For Helping
	counter db 0
	flag db 0; Flag
	string db 4 dup (?),'$'
	
	;For print_grid macro
	grid db cr,lf,1 dup(?),'|',1 dup (?),'|',1 dup (?)
		 db cr,lf,'-----'
		 db cr,lf,1 dup(?),'|',1 dup (?),'|',1 dup (?)
		 db cr,lf,'-----'
		 db cr,lf,1 dup(?),'|',1 dup (?),'|',1 dup (?),"$"
		 
	; Messages
	msg1 db cr,lf,"What mood do you want to game's play? "
	     db cr,lf,'Human VS Human (1)'
		 db cr,lf,'Human VS CPU (2)'
		 db cr,lf,'CPU VS CPU (3):$'
	msg2 db cr,lf,'What is the character that you want to use: (X, O)$'
	msg3 db cr,lf,'Do you want play again? (yes = 1, no = 0)$'
	msg4 db cr,lf,'Human VS Human$'
	msg5 db cr,lf,'Human VS CPU$'
	msg6 db cr,lf,'CPU VS CPU$'
	msg7 db cr,lf,'Tour of gamer with character ',1 dup(?),"$"
	msg8 db cr,lf,'Please enter your choice number: $'
	msg9 db cr,lf,'The game was finished with no winner$'
	msg10 db cr,lf,'Who wants to start? (Human = 1, CPU = 2) $'
	msg11 db cr,lf,'First CPU is X and the second one is O $'
	msg12 db cr,lf,'Press enter to see next level $'
	winmsg db cr,lf,"!!!!The game was finished and the winner is:",1 dup(?),"!!!!$"
	lastmsg db cr,lf,'Bye .$'
	
	; Errors
	err1 db cr,lf,'Your choice was wrong.$'
	err2 db cr,lf,'Your choice is not available.$'
	
	about db cr,lf,'2012 - Winter ',cr,lf,"$"
	cleaner db 1000 dup(50 dup(' ')),"$"; For use in cls macro
mydata ends

;;; Application Macros
refresh macro; For refresh all variable
	mov a,'1'
	mov b,'2'
	mov c,'3'
	mov d,'4'
	mov e,'5'
	mov f,'6'
	mov g,'7'
	mov h,'8'
	mov i,'9'
	mov flag,0
	mov cha,?
	mov inpu,?
	mov winner,?
	mov uh,?
	mov counter,0
endm 

cls macro
	mov ah,02h; For set cursor
	mov dh,0; First line
	int 10h
	prntstr cleaner
	mov ah,02h
	mov dh,0
	int 10h
endm

what_mood macro; For asking question from user and choose one option to game
	local hvhl,hvcl,hvcl_,cvcl,cvcl_,while_,while__,again_
	while_:
		refresh
		prntstr msg1
		readstr string,2
		atoi string+2
		cmp ax,1
		je hvhl; Human VS Human Label
		cmp ax,2
		je hvcl_; Human VS CPU Label
		cmp ax,3
		je cvcl_; CPU VS CPU Label
		prntstr err1
		jmp again_
		hvcl_:
			jmp hvcl
		cvcl_:
			jmp cvcl
		hvhl:
			hvh; Run Human VS Human Gaming
			jmp again_
		hvcl:
			hvc; Run Human VS CPU Gaming
			jmp again_
		cvcl:
			cvc; Run CPU VS CPU Gaming
			jmp again_
		while__:
			jmp while_
		again_:
			prntstr msg3
			readstr string,2
			atoi string+2
			cmp ax,1
			je while__
	prntstr lastmsg
endm

character macro; Case-Sensitive
	local while_,end_,xl,ol
	while_:
		prntstr msg2
		readstr string,2
		mov si,2
		cmp string[si],'X'
		je xl
		cmp string[si],'O'
		je ol
		prntstr err1
		jmp while_
		xl:
			mov cha,'X'
			jmp end_
		ol:
			mov cha,'O'
end_:	
	endm

change_char macro; For change characteristic
	local end_,change_
	cmp cha,'O'
	jne change_
	mov cha,'X'
	jmp end_
	change_:
		mov cha,'O'
end_:
	endm

check_blank macro
	local end_,end_f,no_,no__,replacea,replaceb,replacec,replaced,replacee,replacef,replaceg,replaceh,replacei,go
	mov flag,0
	cmp inpu,'1'
	je go
	cmp inpu,'2'
	je go
	cmp inpu,'3'
	je go
	cmp inpu,'4'
	je go
	cmp inpu,'5'
	je go
	cmp inpu,'6'
	je go
	cmp inpu,'7'
	je go
	cmp inpu,'8'
	je go
	cmp inpu,'9'
	jne no__
	go:
		mov al,inpu
		cmp al,a
		je replacea
		cmp al,b
		je replaceb
		cmp al,c
		je replacec
		cmp al,d
		je replaced
		cmp al,e
		je replacee
		cmp al,f
		je replacef
		cmp al,g
		je replaceg
		cmp al,h
		je replaceh
		cmp al,i
		je replacei
		jmp end_
		no__:
			jmp no_
		replacea:
			mov al,cha
			mov a,al
			jmp end_f
		replaceb:
			mov al,cha
			mov b,al
			jmp end_f
		replacec:
			mov al,cha
			mov c,al
			jmp end_f
		replaced:
			mov al,cha
			mov d,al
			jmp end_f
		replacee:
			mov al,cha
			mov e,al
			jmp end_f
		replacef:
			mov al,cha
			mov f,al
			jmp end_f
		replaceg:
			mov al,cha
			mov g,al
			jmp end_f
		replaceh:
			mov al,cha
			mov h,al
			jmp end_f
		replacei:
			mov al,cha
			mov i,al
			jmp end_f
		no_:
			mov flag,0
			jmp end_
		end_f:
			mov flag,1
end_:
	endm
	
check_winner macro
	local two,three,four,five,six,seven,eight,end_,end_f
	mov flag,0
	;Horizontal
	mov al,a
	cmp al,b
	jne two
	cmp al,c
	jne two
	mov winner,al
	jmp end_f
	two:
		mov al,d
		cmp al,e
		jne three
		cmp al,f
		jne three
		mov winner,al
		jmp end_f
	three:
		mov al,g
		cmp al,h
		jne four
		cmp al,i
		jne four
		mov winner,al
		jmp end_f
	; Vertical
	four:
		mov al,a
		cmp al,d
		jne five
		cmp al,g
		jne five
		mov winner,al
		jmp end_f
	five:
		mov al,b
		cmp al,e
		jne six
		cmp al,h
		jne six
		mov winner,al
		jmp end_f
	six:
		mov al,c
		cmp al,f
		jne seven
		cmp al,i
		jne seven
		mov winner,al
		jmp end_f
	seven:
		mov al,a
		cmp al,e
		jne eight
		cmp al,i
		jne eight
		mov winner,al
		jmp end_f
	eight:
		mov al,c
		cmp al,e
		jne end_
		cmp al,g
		jne end_
		mov winner,al
	end_f:
		mov flag,1
end_:
	endm
	
print_grid macro
	cls
	mov al,a
	mov grid+2,al
	mov al,b
	mov grid+4,al
	mov al,c
	mov grid+6,al
	mov al,d
	mov grid+16,al
	mov al,e
	mov grid+18,al
	mov al,f
	mov grid+20,al
	mov al,g
	mov grid+30,al
	mov al,h
	mov grid+32,al
	mov al,i
	mov grid+34,al
	prntstr grid
endm

hvh macro; Human VS Human
	local while_,while__,go1,go2,msg9_,end_,end__,rest_,next
	prntstr msg4
	character; Call character macro
	print_grid; Call print_grid macro
	while_:
		cmp counter,9
		jge end__
		mov al,cha
		mov msg7+31,al
		prntstr msg7
		prntstr msg8
		readstr string,2
		mov si,2
		mov cl,string[si]
		mov inpu,cl
		jmp next
		end__:
			jmp end_
		next:
			check_blank; Call check_blank macro
			cmp flag,0
			jne go1
			prntstr err2
			jmp while_
			go1:
				inc counter
				change_char; Call change_char macro
				print_grid; Call print_grid macro
				check_winner; Call check_winner macro
				cmp flag,0
				jmp rest_
				while__:
					jmp while_
				rest_:
					jne go2
					cmp counter,9
					jne while__
					msg9_:
						prntstr msg9
						jmp end_
				go2:
					mov al,winner
					mov winmsg+46,al
					prntstr winmsg
end_:
	endm

cpu_gaming macro; CPU Gaming
	local end_,c01,c02,c03,c10,c11,c12,c13,c20,c21,c22,c23,c30,c31,c32,c33,c40,c41,c42,c43,c50,c51,c52,c53,c60,c61,c62,c63,c70,c71,c72,c73,cgdd,g01,g02,g03,g11,g12,g13,g21,g22,g23,g31,g32,g33,g41,g42,g43,g51,g52,g53,g61,g62,g63,g71,g72,g73,cgds
	mov flag,0
	; Attack
	; Horizontal
	mov al,cha
	cmp al,a
	je c01
	cmp al,b
	je c01
	cmp al,c
	je c01
	jmp c10
	c01:
		mov bl,a
		cmp bl,b
		je g01
		jmp c02
		g01:
			mov cl,c
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c02
			jmp end_
	c02:
		mov bl,a
		cmp bl,c
		je g02
		jmp c03
		g02:
			mov cl,b
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c03
			jmp end_
	c03:
		mov bl,b
		cmp bl,c
		je g03
		jmp c10
		g03:
			mov cl,a
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c10
			jmp end_
	c10:
		mov al,cha
		cmp al,d
		je c11
		cmp al,e
		je c11
		cmp al,f
		je c11
		jmp c20
	c11:
		mov bl,d
		cmp bl,e
		je g11
		jmp c12
		g11:
			mov cl,f
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c12
			jmp end_
	c12:
		mov bl,d
		cmp bl,f
		je g12
		jmp c13
		g12:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c13
			jmp end_
	c13:
		mov bl,e
		cmp bl,f
		je g13
		jmp c20
		g13:
			mov cl,d
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c20
			jmp end_
	c20:
		mov al,cha
		cmp al,g
		je c21
		cmp al,h
		je c21
		cmp al,i
		je c21
		jmp c30
	c21:
		mov bl,g
		cmp bl,h
		je g21
		jmp c22
		g21:
			mov cl,i
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c22
			jmp end_
	c22:
		mov bl,g
		cmp bl,i
		je g22
		jmp c23
		g22:
			mov cl,h
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c23
			jmp end_
	c23:
		mov bl,h
		cmp bl,i
		je g23
		jmp c30
		g23:
			mov cl,g
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c30
			jmp end_
	; Vertical
	c30:
		mov al,cha
		cmp al,a
		je c31
		cmp al,d
		je c31
		cmp al,g
		je c31
		jmp c40
	c31:
		mov bl,a
		cmp bl,d
		je g31
		jmp c32
		g31:
			mov cl,g
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c32
			jmp end_
	c32:
		mov bl,a
		cmp bl,g
		je g32
		jmp c33
		g32:
			mov cl,d
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c33
			jmp end_
	c33:
		mov bl,d
		cmp bl,g
		je g33
		jmp c40
		g33:
			mov cl,a
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c40
			jmp end_
	c40:
		mov al,cha
		cmp al,b
		je c41
		cmp al,e
		je c41
		cmp al,h
		je c41
		jmp c50
	c41:
		mov bl,b
		cmp bl,e
		je g41
		jmp c42
		g41:
			mov cl,h
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c42
			jmp end_
	c42:
		mov bl,b
		cmp bl,h
		je g42
		jmp c43
		g42:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c43
			jmp end_
	c43:
		mov bl,e
		cmp bl,h
		je g43
		jmp c50
		g43:
			mov cl,b
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c50
			jmp end_
	c50:
		mov al,cha
		cmp al,c
		je c51
		cmp al,f
		je c51
		cmp al,i
		je c51
		jmp c60
	c51:
		mov bl,c
		cmp bl,f
		je g51
		jmp c52
		g51:
			mov cl,i
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c52
			jmp end_
	c52:
		mov bl,c
		cmp bl,i
		je g52
		jmp c53
		g52:
			mov cl,f
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c53
			jmp end_
	c53:
		mov bl,f
		cmp bl,i
		je g53
		jmp c60
		g53:
			mov cl,c
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c60
			jmp end_
	; Left - Up to Right - Down Digonal
	c60:
		mov al,cha
		cmp al,a
		je c61
		cmp al,e
		je c61
		cmp al,i
		je c61
		jmp c70
	c61:
		mov bl,a
		cmp bl,e
		je g61
		jmp c62
		g61:
			mov cl,i
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c62
			jmp end_
	c62:
		mov bl,a
		cmp bl,i
		je g62
		jmp c63
		g62:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c63
			jmp end_
	c63:
		mov bl,e
		cmp bl,i
		je g63
		jmp c70
		g63:
			mov cl,a
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c70
			jmp end_
	; Right - Up to Left - Down Digonal
	c70:
		mov al,cha
		cmp al,c
		je c71
		cmp al,e
		je c71
		cmp al,g
		je c71
		jmp cgdd; CPU Gaming Defense for Double Chance
	c71:
		mov bl,c
		cmp bl,e
		je g71
		jmp c72
		g71:
			mov cl,g
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c72
			jmp end_
	c72:
		mov bl,c
		cmp bl,g
		je g72
		jmp c73
		g72:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c73
			jmp end_
	c73:
		mov bl,e
		cmp bl,g
		je g73
		jmp cgdd
		g73:
			mov cl,c
			mov inpu,cl
			check_blank
			cmp flag,1
			jne cgdd
			jmp end_
	cgdd:
		cpu_gaming_dd; Call CPU Gaming Defense for Double Chance Macro
		cmp flag,1
		jne cgds
		jmp end_
	cgds:
		cpu_gaming_ds; Call CPU Gaming Defense for Single Chance Macro
end_:
	endm

cpu_gaming_dd macro; CPU Gaming Defense for Double Chance
	local end_,c01,c02,c03,c10,c11,c12,c13,c20,c21,c22,c23,c30,c31,c32,c33,c40,c41,c42,c43,c50,c51,c52,c53,c60,c61,c62,c63,c70,c71,c72,c73,g01,g02,g03,g11,g12,g13,g21,g22,g23,g31,g32,g33,g41,g42,g43,g51,g52,g53,g61,g62,g63,g71,g72,g73
	mov flag,0
	; Defense For Double Chance
    ; Right - Up to Left - Down Digonal
	mov al,uh
	cmp al,c
	je c01
	cmp al,e
	je c01
	cmp al,g
	je c01
	jmp c10
	c01:
		mov bl,c
		cmp bl,g
		je g01
		jmp c02
		g01:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c02
			jmp end_
	c02:
		mov bl,c
		cmp bl,e
		je g02
		jmp c03
		g02:
			mov cl,g
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c03
			jmp end_
	c03:
		mov bl,e
		cmp bl,g
		je g03
		jmp c10
		g03:
			mov cl,c
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c10
			jmp end_
	; Left - UP to Right - Down Digonal
	c10:
		mov al,uh
		cmp al,a
		je c11
		cmp al,e
		je c11
		cmp al,i
		je c11
		jmp c20
	c11:
		mov bl,a
		cmp bl,i
		je g11
		jmp c12
		g11:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c12
			jmp end_
	c12:
		mov bl,a
		cmp bl,e
		je g12
		jmp c13
		g12:
			mov cl,i
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c13
			jmp end_
	c13:
		mov bl,e
		cmp bl,i
		je g13
		jmp c20
		g13:
			mov cl,a
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c20
			jmp end_
	; Vertical
	c20:
		mov al,uh
		cmp al,a
		je c21
		cmp al,d
		je c21
		cmp al,g
		je c21
		jmp c30
	c21:
		mov bl,a
		cmp bl,d
		je g21
		jmp c22
		g21:
			mov cl,g
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c22
			jmp end_
	c22:
		mov bl,a
		cmp bl,g
		je g22
		jmp c23
		g22:
			mov cl,d
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c23
			jmp end_
	c23:
		mov bl,d
		cmp bl,g
		je g23
		jmp c30
		g23:
			mov cl,a
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c30
			jmp end_
	c30:
		mov al,uh
		cmp al,b
		je c31
		cmp al,e
		je c31
		cmp al,h
		je c31
		jmp c40
	c31:
		mov bl,b
		cmp bl,h
		je g31
		jmp c32
		g31:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c32
			jmp end_
	c32:
		mov bl,b
		cmp bl,e
		je g32
		jmp c33
		g32:
			mov cl,h
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c33
			jmp end_
	c33:
		mov bl,e
		cmp bl,h
		je g33
		jmp c40
		g33:
			mov cl,b
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c40
			jmp end_
	c40:
		mov al,uh
		cmp al,c
		je c41
		cmp al,f
		je c41
		cmp al,i
		je c41
		jmp c50
	c41:
		mov bl,c
		cmp bl,f
		je g41
		jmp c42
		g41:
			mov cl,i
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c42
			jmp end_
	c42:
		mov bl,c
		cmp bl,i
		je g42
		jmp c43
		g42:
			mov cl,f
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c43
			jmp end_
	c43:
		mov bl,f
		cmp bl,i
		je g43
		jmp c50
		g43:
			mov cl,c
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c50
			jmp end_
	; Horizontal
	c50:
		mov al,uh
		cmp al,a
		je c51
		cmp al,b
		je c51
		cmp al,c
		je c51
		jmp c60
	c51:
		mov bl,a
		cmp bl,b
		je g51
		jmp c52
		g51:
			mov cl,c
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c52
			jmp end_
	c52:
		mov bl,a
		cmp bl,c
		je g52
		jmp c53
		g52:
			mov inpu,'2'
			check_blank
			cmp flag,1
			jne c53
			jmp end_
	c53:
		mov bl,b
		cmp bl,c
		je g53
		jmp c60
		g53:
			mov cl,a
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c60
			jmp end_
	c60:
		mov al,uh
		cmp al,d
		je c61
		cmp al,e
		je c61
		cmp al,f
		je c61
		jmp c70
	c61:
		mov bl,d
		cmp bl,f
		je g61
		jmp c62
		g61:
			mov cl,e
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c62
			jmp end_
	c62:
		mov bl,d
		cmp bl,e
		je g62
		jmp c63
		g62:
			mov inpu,'6'
			check_blank
			cmp flag,1
			jne c63
			jmp end_
	c63:
		mov bl,e
		cmp bl,f
		je g63
		jmp c70
		g63:
			mov cl,d
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c70
			jmp end_
	c70:
		mov al,uh
		cmp al,g
		je c71
		cmp al,h
		je c71
		cmp al,i
		je c71
		jmp end_
	c71:
		mov bl,g
		cmp bl,h
		je g71
		jmp c72
		g71:
			mov cl,i
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c72
			jmp end_
	c72:
		mov bl,g
		cmp bl,i
		je g72
		jmp c73
		g72:
			mov cl,h
			mov inpu,cl
			check_blank
			cmp flag,1
			jne c73
			jmp end_
	c73:
		mov bl,h
		cmp bl,i
		je g73
		jmp end_
		g73:
			mov cl,g
			mov inpu,cl
			check_blank
end_:		
	endm

cpu_gaming_ds macro; CPU Gaming Defense for Single Chance
	local end_,c1,c2,g1,g2,g3,g4,g5,g6,g7,g8,g9,c_
	; Defense For Single Chance
	mov flag,0
	cmp e,'5'
	je c_
	mov al,cha
	cmp al,e
	jne c1
	c_:
		jmp c2
	c1:
		mov inpu,'1'
		check_blank
		cmp flag,1
		jne g1
		jmp end_
		g1:
			mov inpu,'4'
			check_blank
			cmp flag,1
			jne g2
			jmp end_
		g2:
			mov inpu,'7'
			check_blank
			cmp flag,1
			jne g3
			jmp end_
		g3:	
			mov inpu,'8'
			check_blank
			cmp flag,1
			jne g4
			jmp end_
		g4:	
			mov inpu,'9'
			check_blank
			cmp flag,1
			jne g5
			jmp end_
		g5:	
			mov inpu,'6'
			check_blank
			cmp flag,1
			jne g6
			jmp end_
		g6:
			mov inpu,'3'
			check_blank
			cmp flag,1
			jne g7
			jmp end_
		g7:
			mov inpu,'2'
			check_blank
			jmp end_
		c2:
			mov inpu,'5'
			check_blank
			cmp flag,1
			jne g8
			jmp end_
			g8:	
				mov inpu,'2'
				check_blank
				cmp flag,1
				jne g9
				jmp end_
			g9:
				jmp c1
end_:
	endm

random macro; For generate random number
	local end_,c1,c2,c3,c4,c5,c6,c7,c8,go
	mov ah,2ch
	int 21h
	mov al,dl
	cbw
	mov cl,10
	div cl; Single Digit Random Number is in AH
	cmp ah,0
	jne go
	inc ah
	go:
		cmp ah,1
		je c1
		cmp ah,2
		je c2
		cmp ah,3
		je c3
		cmp ah,4
		je c4
		cmp ah,5
		je c5
		cmp ah,6
		je c6
		cmp ah,7
		je c7
		cmp ah,8
		je c8
		mov ah,'9'
		jmp end_
		c1:
			mov ah,'1'
			jmp end_
		c2:
			mov ah,'2'
			jmp end_
		c3:
			mov ah,'3'
			jmp end_
		c4:
			mov ah,'4'
			jmp end_
		c5:
			mov ah,'5'
			jmp end_	
		c6:
			mov ah,'6'
			jmp end_
		c7:
			mov ah,'7'
			jmp end_
		c8:
			mov ah,'8'
end_:
	endm

hvc macro; Human VS CPU
	local while_,while__,while___,c1,go1,go2,go3,msg9_,end_,end__,rest_,next,cpu_tour,g1,g2
	prntstr msg5
	character
	while___:
		prntstr msg10
		readstr string,2
		atoi string+2
		mov bl,1
		idiv bl
		mov help,al
		cmp help,1
		jne g1
		print_grid; Call print_grid macro
		jmp while_
		g1:
			cmp help,2
			je c1; CPU First Random Moving
			prntstr err1
			jmp while___
		c1:
			change_char
			random; Call random macro
			mov inpu,ah
			check_blank
			change_char
			mov help,1
			inc counter
			print_grid; Call print_grid macro
	while_:
		cmp counter,9
		jge end__
		mov al,cha
		mov msg7+31,al
		prntstr msg7
		cmp help,1
		je g2
		jmp cpu_tour
		g2:
			mov bl,1
			prntstr msg8
			readstr string,2
			mov si,2
			mov cl,string[si]
			mov inpu,cl
			jmp next
			end__:
				jmp end_
			next:
				check_blank; Call check_blank macro
				cmp flag,0
				jne go1
				prntstr err2
				jmp while_
			go1:
				mov al,cha
				mov uh,al
				inc counter
				change_char; Call change_char macro
				print_grid; Call print_grid macro
				cmp help,1
				je ch_
				mov help,1
				jmp go3
				ch_:
					mov help,2
				go3:
					check_winner; Call check_winner macro
					cmp flag,0
					jmp rest_
					while__:
						jmp while_
					rest_:
						jne go2
						cmp counter,9
						jne while__
						msg9_:
							prntstr msg9
							jmp end_
					go2:
						mov al,winner
						mov winmsg+46,al
						prntstr winmsg
						jmp end_
			cpu_tour:
				cpu_gaming; Call cpu_gaming macro
				jmp go1
end_:
	endm

cvc macro
	local while_,while__,go1,go2,msg9_,end_,end__,rest_
	prntstr msg6
	prntstr msg11
	mov cha,'X'
	; First Moving
	random; Call random macro
	mov inpu,ah
	check_blank
	mov al,cha
	mov msg7+31,al
	prntstr msg7
	inc counter
	print_grid
	while_:
		cmp counter,9
		jl go1
		jmp end_
		go1:
			change_char
			mov al,cha
			mov msg7+31,al
			prntstr msg7
			cpu_gaming
			mov al,cha
			mov uh,al
			prntstr msg12
			readstr string,2
			inc counter
			print_grid
			check_winner; Call check_winner macro
			cmp flag,0
			jmp rest_
			while__:
				jmp while_
			rest_:
				jne go2
				cmp counter,9
				jne while__
				msg9_:
					prntstr msg9
					jmp end_
				go2:
					mov al,winner
					mov winmsg+46,al
					prntstr winmsg
end_:
	endm

mycode segment 
	assume cs:mycode,ds:mydata

	start:
		mov ax,seg mydata
		mov ds,ax
		
		prntstr about
		what_mood
	
	quit:
		mov al,0; return code 0
		mov ah,4ch; dos function to return
		int 21h; interrupt for dos services
mycode ends
	end start; start execution
