* Copyright 2023 Rolf Michelsen
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.

* A small program to show joystick operations on the screen.

		include	"src/dragon.asm"

		org	$0c00

		lbsr	initscreen
		lbsr	outputlegend
		lbsr	main
		lbsr	restorescreen
		rts

* The main program loop.
*   1. Read joystick values
*   2. Update screen with joystick readings
*   3. Check joystick button status
*   4. Update screen with joystick button status
*   5. Check for keypress and exit
*   6. Repeat...
main		jsr	JOYSTICK			; read and dislpay joystick readings
		lda 	JOYLEFTX
		ldx	#textstart + (15*32) + 5
		bsr	outjoystick
		lda	JOYLEFTY
		ldx	#textstart + (15*32) + 8
		bsr	outjoystick
		lda	JOYRIGHTX
		ldx	#textstart + (15*32) + 23
		bsr	outjoystick
		lda	JOYRIGHTY
		ldx	#textstart + (15*32) + 26
		bsr	outjoystick

		leay	joystate,pcr
		lda	JOYLEFTX			; show graphical representation of joystick position
		ldb	JOYLEFTY
		ldx	#textstart + 4*32
		bsr	drawposition

		lda	JOYRIGHTX
		ldb	JOYRIGHTY
		ldx	#textstart + 4*32 + 16
		bsr	drawposition

		ldx	#textstart + (15*32) + 11	; check joystick buttons
		lda	PIA0DDRA
		anda	#$02
		bsr	outbutton

		ldx	#textstart + (15*32) + 29
		lda	PIA0DDRA
		anda	#$01
		bsr	outbutton

		jsr	INCHAR				; run until a key has been pressed
		beq	main

		rts

* Outputs a joystick axis reading to the screen
*
* Inputs:	A	Joystick reading [0-63]
*		X	Output memory location of first digit
* Outputs:	X	Input X incremebted by 2
* Destroyed:	D
outjoystick	bsr	bin2bcd
		tfr	b,a
		lsra
		lsra
		lsra
		lsra
		adda	#48
		sta	,x+
		andb	#$0f
		addb	#48
		stb	,x+
		rts


* Output joystick button indicator to the screen
*
* Inputs:	A	Button status (0 for button pressed)
*		X	Screen memory position for output
* Destroy:	A, X
outbutton	tsta
		beq	1f
		lda	#32			; clear button indicator
		sta	,x+
		sta	,x+
		rts
1		lda	#97			; set button indicator
		sta	,x+
		sta	,x+
		rts


* Show gfraphical representation of joystick position
*
* Inputs:	A	Joystick X axis position [0,63]
*		B	Joystick Y axis position [0,63]
*		X	Base screen position for drawing joystick position
*		Y	Area for storing last used screen position
* Outputs:	Y	Pointer to first byte following the last used screen position
* Destroys:	D, X, U
drawposition	pshs	a			; restore previous screen state
		lda	#96
		ldu	,y
		sta	,u
		puls	a

		lsra				; reduce x axis range to [0,16]
		lsra
		lsrb				; reduce y axis range to [0,8]
		lsrb
		lsrb

		pshs	a
		clr	,-s
		lda	#32
		mul
		addd	,s++
		leax	d,x
		lda	#128
		sta	,x
		stx 	,y++

		rts


* Convert a binary value to its BCD representation
*
* Inputs:	A	Binary value [0, 100)
* Outputs:	B	BCD value
bin2bcd		pshs	a
		clrb
1		cmpa	#10
		blo	2f
		addb	#$10
		suba	#10
		bra	1b
2		tsta
		beq	3f
		incb
		deca
		bra	2b
3		puls	a
		rts


* Output a string to the screen.  The string must be terminated by a
* null byte.
*
* Inputs:	X	Screen address for output
*		Y	Pointer to text string
*		B	Non-zero for reverse video
* Outputs:	X	Screen address of next output position
*		Y	Pointer to first byte after string
outstring	pshs	d
1		lda	,y+
		beq	2f
		bita	#$80		; block graphic character
		bne	3f
		bita	#$40		; alphabet
		bne	4f
		adda	#$40
4		tstb
		beq	3f
		suba	#$40
3		sta	,x+
		bra	1b
2		puls	d
		rts


* Get keypress
* Wait for a keypress and return the key code
*
* Outputs:	A	Key code of key pressed
* Modifies:	A, CC
getkey		jsr	INCHAR
		beq	getkey
		rts


* Output fixed screen text
*
* Inputs:	-
* Destroys:	X, Y
outputlegend	ldx	#textstart
		leay	legendheader,pcr
		ldb	#1
		bsr	outstring
		ldx	#textstart + (15*32)
		bsr	outstring
		rts


* Initialize screen
* Stores the current text screen content and then blanks the screen.
initscreen	ldx	#textstart
		leay	screenstate,pcr
		ldb	#96
1		lda	,x
		stb	,x+
		sta	,y+
		cmpx	#textend
		blo	1b
		rts


* Restore screen
* Restores screen content saved by initscreen.
restorescreen	ldx	#$0400
		leay	screenstate,pcr
1		ldd	,y++
		std	,x++
		cmpx	#$0600
		blo	1b
		rts


legendheader	fcc	"         JOYSTICK TEST          ",0
legendmetrics	fcc	"LEFT             RIGHT          ",0

joystate	rmb	2		; left joystick screen memory position
		rmb	2		; right joystick screen memory position

screenstate	rmb	512		; Area for storing screen state, set by initscreen

