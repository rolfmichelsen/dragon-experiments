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

		bsr	initscreen
		bsr	outputlegend
		bsr	getkey
		bsr	restorescreen
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
screenstate	rmb	512		; Area for storing screen state, set by initscreen

