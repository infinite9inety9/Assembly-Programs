org 100h
jmp start

title: db "Title Banner" , 0
l1: dw 12
paragraph: db "Well here I am solving this COAL assignment on a thursday night. I have not gotten much sleep since yesterday due to the early UHQ class. Next week seems to be a tough one with two Seasonals, three/four quizzes, and two/three assignments being due. Lets see." , 0
l2: dw 258
scrollN: dw 0
findString: db "three"
l3: dw 5
message: db "Total Matches Found: "
l4: dw 21
message2: db " | Viewport Status: ACTIVE"
l5: dw 26
foundC: dw 0

clrscrn:
push es
push ax
push cx
push di

mov ax, 0xb800
mov es, ax
xor di, di
mov ax, 0x0720
mov cx, 2000

cld
rep stosw

pop di
pop cx
pop ax
pop es
ret

createVP:
push bp
mov bp, sp

mov ax, 0xb800
mov es, ax

corners:
mov ax, 0x0FC9
mov di, [bp+10]
stosw
mov ax, 0x0FBB
mov di, [bp+8]
stosw
mov ax, 0x0FC8
mov di, [bp+6]
stosw
mov ax, 0x0FBC
mov di, [bp+4]
stosw

mov ax, 0x0FBA
mov di, [bp+10]
add word di, 160
mov si, [bp+6]
vertical1:
cmp di, si
jz Tvertical2
mov [es:di], ax
add di, 160
jmp vertical1

Tvertical2:
mov ax, 0x0FBA
mov di, [bp+8]
add word di, 160
mov si, [bp+4]
vertical2:
cmp di, si
jz Thorizontal1
mov [es:di], ax
add di, 160
jmp vertical2

Thorizontal1:
mov ax, 0x0FCD
mov di, [bp+10]
add word di, 2
mov si, [bp+8]
horizontal1:
cmp di, si
jz Thorizontal2
stosw
jmp horizontal1

Thorizontal2:
mov ax, 0x0FCD
mov di, [bp+6]
add word di, 2
mov si, [bp+4]
horizontal2:
cmp di, si
jz retVP
stosw
jmp horizontal2

retVP:
pop bp
ret 8

calcCoords:
push bp
mov bp, sp
push es
push bx

mov ax, [bp+10]
mov bx, 160
mul bx
mov bx, [bp+6]
shl bx, 1
add ax, bx
push ax
pop si

mov ax, [bp+10]
mov bx, 160
mul bx
mov bx, [bp+4]
shl bx, 1
add ax, bx
push ax
pop di

mov ax, [bp+8]
mov bx, 160
mul bx
mov bx, [bp+6]
shl bx, 1
add ax, bx
push ax
pop cx

mov ax, [bp+8]
mov bx, 160
mul bx
mov bx, [bp+4]
shl bx, 1
add ax, bx
push ax
pop dx

pop bx
pop es
pop bp
ret 8

titleBanner:
push bp
mov bp, sp
push si
push cx

mov ax, 0xb800
mov es, ax

mov ax, 63
mov bx, [bp+4]
sub ax, bx
shr ax, 1
add ax, 8
push ax

mov ax, 2
mov bx, 160
mul bx

pop bx
shl bx, 1
add ax, bx

mov di, ax

mov si, [bp+6]
mov cx, [bp+4]

mov ah, 0x1E

printLoop:
mov al, [ds:si]
stosw
inc si
loop printLoop

pop cx
pop si
pop bp
ret 4

textBStreaming:
push bp
mov bp, sp
push si
push di
push bx

mov ax, 0xb800
mov es, ax

mov ax, 5
mov bx, 160
mul bx
mov bx, 10
shl bx, 1
add ax, bx
mov di, ax

mov si, [bp+6]
mov cx, [bp+4]
mov ah, 0x0F
xor bx, bx

print:
mov al, [ds:si]
stosw
inc si
inc bx
cmp bx, 61
jne next
xor bx, bx
add di, 38
next:
loop print

pop bx
pop di
pop si
pop bp
ret 4

scroll_window_up:
push bp
mov bp, sp
sub sp, 6
push ax
push bx
push cx
push dx
push si
push di
push es
push ds

mov ax, 0xb800
mov es, ax
mov ds, ax

mov ax, [bp+10]
sub ax, [bp+6]
dec ax
shl ax, 1

mov [bp-2], ax
mov ax, [bp+6]
inc ax
shl ax, 1

mov [bp-4], ax
mov ax, [bp+12]
mov [bp-6], ax

cmp word [bp-6], 0
jle done

outerLoop:
mov bx, [bp+4]
inc bx
inc bx

copyRow:
mov ax, [bp+8]
dec ax
cmp bx, ax

ja blankLast
mov ax, bx
dec ax
mov dx, 160
mul dx
add ax, [bp-4]
mov di, ax
mov ax, bx
mov dx, 160
mul dx
add ax, [bp-4]
mov si, ax
mov cx, [bp-2]
shr cx, 1

cld
rep movsw
inc bx
jmp copyRow

blankLast:
mov ax, [bp+8]
dec ax
mov dx, 160
mul dx
add ax, [bp-4]
mov di, ax
mov cx, [bp-2]
shr cx, 1
mov ax, 0x0720
rep stosw
dec word [bp-6]
jnz outerLoop

done:
pop ds
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
mov sp, bp
pop bp
ret 10

find_and_highlight:
push bp
mov bp, sp
push ax
push bx
push cx
push dx
push si
push di
push ds
push es

mov ax, ds
mov es, ax
mov si, paragraph

searchLoop:
cmp byte [si], 0
je fhDone
cmp si, paragraph
je checkWord
mov al, [si-1]
cmp al, 'A'
jb  leadingOk
cmp al, 'Z'
jbe nextChar
cmp al, 'a'
jb  leadingOk
cmp al, 'z'
jbe nextChar
leadingOk:
jmp checkWord

checkWord:
mov di, [bp+8]
mov cx, [bp+6]
push si
repe cmpsb
pop si
jne nextChar
mov bx, si
add bx, [bp+6]
mov al, [bx]
cmp al, 'A'
jb  trailingOk
cmp al, 'Z'
jbe nextChar
cmp al, 'a'
jb  trailingOk
cmp al, 'z'
jbe nextChar
trailingOk:

foundWord:
mov bx, si
sub bx, paragraph
mov ax, bx
xor dx, dx
mov cx, 61
div cx
mov bx, dx
mov dx, ax
mov ax, 160
mul dx
push ax
mov ax, 5
sub ax, [scrollN]
mov cx, 160
mul cx
add ax, 20
pop dx
add ax, dx
add ax, bx
add ax, bx
mov di, ax
push 0xb800
pop es
mov cx, [bp+6]
hlLoop:
mov dl, [bp+4]
mov byte [es:di+1], dl
add di, 2
inc bx
cmp bx, 61
jne hlNoWrap
xor bx, bx
add di, 38
hlNoWrap:
loop hlLoop
add word [foundC], 1
mov ax, ds
mov es, ax

nextChar:
inc si
jmp searchLoop

fhDone:
pop es
pop ds
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret 6

printNum:
push bp
mov bp, sp
push ax
push bx
push cx
push dx
push si
push di
push es
push ds

mov ax, 0xb800
mov es, ax
xor di, di

mov ax, 23
mov bx, 80
mul bx
mov cx, 9
add ax, cx
shl ax, 1
mov di, ax
mov si, [bp+12]
mov cx, [bp+10]
mov ah, 0x07
cld
nextChar1:
lodsb
stosw
loop nextChar1

mov ax, [bp+4]
mov bx, 10
xor cx, cx
pnDigits:
xor dx, dx
div bx
push dx
inc cx
cmp ax, 0
jne pnDigits
pnEmit:
pop dx
add dl, '0'
mov al, dl
mov ah, 0x07
stosw
loop pnEmit

mov si, [bp+8]
mov cx, [bp+6]
mov ah, 0x07
cld
nextChar2:
lodsb
stosw
loop nextChar2

pop ds
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret 10

start:
call clrscrn

push word 3
push word 21
push word 8
push word 72
call calcCoords

push si
push di
push cx
push dx
call createVP

mov ax, title
push ax
mov ax, [l1]
push ax
call titleBanner

mov ax, paragraph
push ax
mov ax, [l2]
push ax
call textBStreaming

mov ax, [scrollN]
push ax
mov ax, 72
push ax
mov ax, 21
push ax
mov ax, 8
push ax
mov ax, 3
push ax
call scroll_window_up

mov ax, findString
push ax
mov ax, [l3]
push ax
mov ax, 0xCE
push ax
call find_and_highlight

mov ax, message
push ax
mov ax, [l4]
push ax
mov ax, message2
push ax
mov ax, [l5]
push ax
mov ax, [foundC]
push ax
call printNum

exit:
mov ax, 0x4c00
int 0x21