org 0x7c00
jmp 0x0000:start

data:
string db 0

video: ; Modo de video
    mov ah, 00h
    mov al, 01h
    int 10h

    mov ah, 0xb
    mov bh, 0
    mov bl, 0
    int 10h
ret

tam:
    mov bl, 0
    loop:
        lodsb
        cmp al, 0
        je .endtam
        inc bl
        mov al, bl
        add al, 48
        jmp loop
    .endtam:
    mov al, bl
    add al, 48
    ret

    getChar: ; Ler um caractere
        mov ah, 0x00
        int 16h
    ret

putchar:
    mov ah, 0eh ;modo de imprmir na tela
    int 10h ;imprime o que tá em al
    ret

    delChar:
        mov al, 0x08 ; Coloca backspace em al
        call putchar
        mov al, ' '  ; Coloca caractere em branco em al
        call putchar
        mov al, 0x08
        call putchar
    ret

    endl:
        mov al, 0x0a ; Coloca o caractere de quebra de linha em al
        call putchar
        mov al, 0x0d ; Coloca o cursor na próxima linha
        call putchar
    ret


getString:
    xor cx, cx  ; Iguala o contador do tamanho da string a 0

    .loop1:
        call getChar
        cmp al, 0x08 ; Verifica se o caractere backspace foi pressionado
        je .delete    ; Se sim, vai para a funcao delete 
        cmp al, 0x0d ; Verifica se o caractere enter foi pressionado
        je .enter     ; Se sim, vai para a funcao enter
        cmp cl, 100   ; Tamanho maximo da palavra
        je .loop1

        stosb        ; Guarda o caractere
        inc cl  
        call putchar
        jmp .loop1

        .delete:
            cmp cl, 0   ; Se cl estiver limpo, volta para o loop de pegar a string
            je .loop1
            dec di
            dec cl 
            mov byte[di], 0
            call delChar
            jmp .loop1

        .enter:
            mov al, 0  ;seta al como 0
            stosb
            call endl
        ret

start:

    call video
    mov di, string
    call getString

    mov si, string
    call tam
    call putchar

    call ._fim

._fim:
    jmp $

times 510-($-$$) db 0
dw 0xaa55
