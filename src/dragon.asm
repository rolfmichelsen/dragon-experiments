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


*
* ROM routines
*


* Input character from keyboard
*
* Normally returns the ASCII code corresponding to the key pressed.
* Some keys have special codes; see the KEY_* symbols defined further down.
* Returns immediately with a zero return valye if no key is pressed.
* Sets the CC.Z if no key is pressed.
*
* Outputs:  	A	Character code of keboard key pressed
* Modifies: 	A, CC
INCHAR		equ	$8006

* Blinks the cursor
BLINK		equ	$8009

* Output character to the screen
*
* Outputs a character to the screen at the current cursor position, updating
* the cursor position and scrolling the screen, if necessary.  See CURSORPOS.
*
* Inputs:	A	Character code to output
* Modifies:	CC
OUTCHAR		equ	$800c

* Output character to the printer
PRINTCHAR	equ	$800f

* Update joystick readings
*
* See JOYRIGHTX, JOYRIGHTY, JOYLEFTX and JOYLEFTY for the position of each
* joystick after calling this function.
*
* Modifies: 	all
JOYSTICK	equ	$8012


*
* Memory map
*

CURSORPOS	equ	$88		; memory address of current cusros position

* Joystick positions set by a call to JOYSTICK
JOYRIGHTX	equ	$15a		; x axis position of right joystick [0-63]
JOYRIGHTY	equ	$15b		; y axis position of right joystick [0-63]
JOYLEFTX	equ	$15c		; x axis position of left joystick [0-63]
JOYLEFTY	equ	$15d		; y axis position of left joystick [0-63]


textstart	equ	$0400		; start of text screen memory
textend		equ	$0600		; end of text screen memory


* PIA refisters
PIA0		equ	$ff00		; PIA0 base address
PIA1		equ	$ff20		; PIA1 base address

PIA0DDRA	equ	PIA0		; data direction register
PIA0PDRA	equ	PIA0		; peripheral data register
PIA0CRA		equ	(PIA0+1)	; control register
PIA0DDRB	equ	(PIA0+2)
PIA0PDRB	equ	(PIA0+2)
PIA0CRB		equ	(PIA0+3)
PIA1DDRA	equ	PIA1
PIA1PDRA	equ	PIA1
PIA1CRA		equ	(PIA1+1)
PIA1DDRB	equ	(PIA1+2)
PIA1PDRB	equ	(PIA1+2)
PIA1CRB		equ	(PIA1+3)



*
* Constants
*

* Keyboard codes returned by INCH for keys not having a corresponding
* ASCII code.
KEY_BREAK	equ	$03		; break key
KEY_CLEAR	equ	$0c		; clear key
KEY_ENTER	equ	$0d		; enter key
KEY_SHIFT_ALPH	equ	$13		; shift + @ key
KEY_SHIFT_CLEAR	equ	$5c		; shift + clear key

KEY_UP		equ	$5e		; up arrow key
KEY_DOWN	equ	$0a		; down arrow key
KEY_LEFT	equ	$08		; left arrow key
KEY_RIGHT	equ	$09		; right arrow key
KEY_SHFT_UP	equ	$5f		; shift + up arrow key
KEY_SHIFT_DOWN	equ	$5b		; shift + down arrow key
KEY_SHIFT_LEFT	equ	$15		; shift + left arrow key
KEY_SHIFT_RIGHT	equ	$5d		; shift + right arrow key
