*   Copyright 2022 Rolf Michelsen
*
*   Licensed under the Apache License, Version 2.0 (the "License");
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.

* Print "Hello, world!" to the screen at the current cursor position.

	INCLUDE	"src/dragon.asm"

	org	0x0c00

	leax	text,pcr
loop	lda	,x+
	beq	end
	jsr	OUTCHAR
	bra	loop
end	rts

text	fcc	"HELLO, WORLD!", 13, 0
