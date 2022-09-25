* Copyright 2022 Rolf Michelsen
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

		include	"src/dragon.asm"

		org	$0c00

		bsr	initscreen
		bsr	charactermap
		bsr	getkey
		bsr	restorescreen
		rts

* Output character map
* Output the complete character map as 8 lines starting at the 3rd screen line.
charactermap	ldx	#$0440
		clra
1		sta	,x+
		inca
		bne	1b
		rts

* Initialize screen
* Stores the current text screen content and then blanks the screen.
initscreen	ldx	#$0400
		leay	screenstate,pcr
		ldb	#96
1		lda	,x
		stb	,x+
		sta	,y+
		cmpx	#$0600
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

* Get keypress
* Wait for a keypress and return the key code
*
* Outputs:	A	Key code of key pressed
* Modifies:	A, CC
getkey		jsr	INCHAR
		beq	getkey
		rts

screenstate	rmb	512		; Area for storing screen state, set by initscreen
