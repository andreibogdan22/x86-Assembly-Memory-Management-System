.section .note.GNU-stack,"",@progbits

.data
hardDisk: .space 1048576
descriptor: .space 4
i: .space 4
j: .space 4
ok: .space 4
garbage: .space 4
nrOperatii: .space 4
operatie: .space 4
nrADD: .space 4
x: .space 4
printHelpVariable: .space 4
inceput1: .space 4
sfarsit1: .space 4
inceput2: .space 4
sfarsit2: .space 4
printFormatGET: .asciz "((%d, %d), (%d, %d))\n"
printFormatADD: .asciz "%d: ((%d, %d), (%d, %d))\n"
scanFormat: .asciz "%d"
debugFormat: .asciz "%d "

.text
//DELETE operation(restores %ecx)
nextFragment:
  incl %eax
  jmp printLoopFinal
DELETE:
  lea hardDisk, %esi
  push %ebp
  mov %esp, %ebp
  push %ecx
  movl 8(%ebp), %eax

  cmpl $255, %eax
  ja exitDelete
  cmpl $0, %eax
  jle exitDelete

  push $1048576
  push $0
  push %eax
  call getIntervalById
  pop garbage
  pop garbage
  pop garbage

  cmpl $-1, %eax
  je exitDelete

  movl %eax, %ecx
  xor %eax, %eax
  deleteLoop:
    movb %al, (%esi, %ecx, 1)
    incl %ecx
    cmpl %edx, %ecx
    jbe deleteLoop
  exitDelete:
    pop %ecx
    pop %ebp
    ret
//ADD operation(restores %ecx)
lineSearch:
    push %ecx
    push %ebx
//bucla cautare pe linii
  xor %ecx, %ecx
  xor %ebx, %ebx
  lineSearchIsSpaceLoop:
  movl 8(%ebp), %eax
  movl 12(%ebp), %edx
  addl $1024, %ebx
  push %ecx
  push %ebx
  push %edx
  push %eax
  call isSpace
  pop garbage
  pop garbage
  pop garbage
  pop garbage

  cmp %eax, %edx
  jne retAllMatrixAndLine

  addl $1024, %ecx
  cmpl $1048576, %ecx
  jb lineSearchIsSpaceLoop

  pop %ebx
  pop %ecx
  jmp noADD
allMatrix:
  push %ecx
  push %ebx
  //bucla cautare per total
  xor %ecx, %ecx
  allMatrixIsSpaceLoop:
  movl 8(%ebp), %eax
  movl 12(%ebp), %edx
  push %ecx
  push $1048576
  push %edx
  push %eax
  call isSpace
  pop garbage
  pop garbage
  pop garbage
  pop %ecx

  cmpl $0, %edx
  je noLineSearch

  cmp %ecx, %eax
  je retAllMatrixAndLine

  addl $1024, %ecx
  cmpl $1048576, %ecx
  jb allMatrixIsSpaceLoop
noLineSearch:
  pop %ebx
  pop %ecx
  jmp noADD
equalNoADD:
  cmpl $0, %eax
  jne retNoAdd
  jmp noADD
noADD:
  push $0
  push $0
  push $0
  push $0
  movl 8(%ebp), %eax
  push %eax
  push $printFormatADD
  call printf
  push $0
  call fflush
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  jmp exitADD
ADD:
  lea hardDisk, %esi
  push %ebp
  mov %esp, %ebp
  movl 8(%ebp), %eax
  movl 12(%ebp), %edx
  push %ecx

  cmpl $8388608, %edx
  ja noADD

  cmpl $8192, %edx //se imparte in 2 ramuri cautare pe linie sau cautare per total
  ja noADD
  jmp lineSearch

  retAllMatrixAndLine:
  pop %ebx
  pop %ecx

  cmpl %eax, %edx
  je equalNoADD
  cmpl $1048576, %edx
  ja noADD

  retNoAdd:

  movl %eax, %ecx
  addl %eax, %edx
  decl %edx
  push %eax
  movl 8(%ebp), %eax
  ADDLoop:
    movb %al, (%esi, %ecx, 1)
    incl %ecx
    cmpl %edx, %ecx
    jbe ADDLoop

    pop %eax

    push %eax
    push %edx
    push %ebx

    movl %eax, %ecx
    movl %edx, %eax
    xor %edx, %edx
    movl $1024, %ebx
    divl %ebx
    push %edx
    push %eax
    xor %edx, %edx
    movl %ecx, %eax
    divl %ebx
    push %edx
    push %eax
    movl 8(%ebp), %eax
    push %eax
    push $printFormatADD
    call printf
    push $0
    call fflush
    pop garbage
    pop garbage
    pop garbage
    pop garbage
    pop garbage
    pop garbage
    pop garbage

    pop %ebx

    pop %edx
    pop %eax

  exitADD:
    pop %ecx
    pop %ebp
    ret

//GET operation(restores %ecx)
notGet:
  push $0
  push $0
  push $0
  push $0
  push $printFormatGET
  call printf
  push $0
  call fflush
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop %ebx
  pop %ecx
  pop %ebp
  ret
GET:
  push %ebp
  mov %esp, %ebp
  movl 8(%ebp), %eax
  push %ecx
  push %ebx
  cmpl $255, %eax
  ja notGet
  cmpl $0, %eax
  jle notGet

  push $1048576
  push $0
  push %eax
  call getIntervalById
  pop garbage
  pop garbage
  pop garbage

  cmpl $-1, %eax
  je notGet

  push %ebx
  movl %eax, %ecx
  movl %edx, %eax
  xor %edx, %edx
  movl $1024, %ebx
  divl %ebx
  push %edx
  push %eax
  xor %edx, %edx
  movl %ecx, %eax
  divl %ebx
  push %edx
  push %eax
  push $printFormatGET
  call printf
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop garbage
  pop %ebx

  pop %ebx
  pop %ecx
  pop %ebp
  ret

//isSpace function(restores %ecx)
noSpace:
  pop garbage
  pop garbage
  movl $0, %eax
  movl $0, %edx
  jmp exitIsSpace
foundSpace:
  pop garbage
  movl %eax, %edx
  movl i, %eax
  jmp exitIsSpace
aprox:
  incl %eax
  jmp retAprox
isSpace:
  push %ebp
  mov %esp, %ebp
  push %ebx

  movl 16(%ebp), %ebx
  movl 12(%ebp), %eax
  push %ebx
  movl $8, %ebx
  movl $0, %edx
  divl %ebx
  pop %ebx
  cmpl $0, %edx
  jne aprox
  retAprox:

  movl %eax, %edx
  movl 8(%ebp), %eax
  push %ecx
  movl 20(%ebp), %ecx
  iterareIsSpace:
    push %eax
    push %edx

    push %ebx
    push %ecx
    push $0
    call getIntervalById
    pop garbage
    pop %ecx
    pop %ebx

    cmpl $-1, %eax
    je noSpace
    movl %edx, %ecx
    incl %ecx

    subl %eax, %edx
    incl %edx
    pop %eax
    cmpl %edx, %eax
    jbe foundSpace

    movl %eax, %edx
    pop %eax

    cmpl %ebx, %ecx
    jb iterareIsSpace

    movl $0, %eax
    movl $0, %edx

  exitIsSpace:
  pop %ecx//
  pop %ebx
  pop %ebp
  ret
//getIntervalById function used for GET, ADD, DELETE and DEFRAGMENTATION operations(restores %ecx)
setJtoI:
  movl i, %eax
  movl %eax, j
  jmp retCheck
check:
  cmpl $-1, j
  je setJtoI
  jmp retCheck
setI:
  cmpl %eax, %edx
  jne retAskOk
  movl %ecx, i
  movl $1, ok
  jmp retAskOk
setJ:
  cmpl %eax, %edx
  jne exitIntervalById
  movl %ecx, j
  jmp retAskOk
askOk:
  cmpl $0, ok
  je setI
  jmp setJ
getIntervalById:
  lea hardDisk, %esi
  push %ebp
  mov %esp, %ebp
  movl 16(%ebp), %ebx
  movl 8(%ebp), %eax
  push %ecx
  movl $-1, i
  movl $-1, j

  movl 12(%ebp), %ecx
  cmp %ebx, %ecx
  jae retCheck
  movb $0, ok
  movl $0, %edx
  iterareIntervalId:
    movb (%esi, %ecx, 1), %dl
    jmp askOk
    retAskOk:

    incl %ecx
    cmpl %ebx, %ecx
    jb iterareIntervalId

  exitIntervalById:
    movl i, %eax
    cmpl j, %eax
    jne check
    retCheck:
    movl i, %eax
    movl j, %edx
    pop %ecx
    pop %ebp
    ret

//handle input
handleADD:
  push %ecx
  push $nrADD
  push $scanFormat
  call scanf
  pop garbage
  pop garbage
  xor %ecx, %ecx
  loopHandleADD:
  push %ecx


  push $descriptor
  push $scanFormat
  call scanf
  pop garbage
  pop garbage

  push $x
  push $scanFormat
  call scanf
  pop garbage
  pop garbage

  movl descriptor, %ecx
  cmpl $255, %ecx
  ja skip
  cmpl $1, %ecx
  jl skip
  movl x, %ecx
  cmpl $8, %ecx
  jbe skip

  push $1048576
  push $0
  push descriptor
  call getIntervalById
  pop garbage
  pop garbage
  pop garbage

  cmpl $-1, %eax
  jne skip

  push x
  push descriptor
  call ADD
  pop garbage
  pop garbage

  skip:
  pop %ecx

  incl %ecx
  cmpl nrADD, %ecx
  jb loopHandleADD
  pop %ecx

  jmp retSkipPrint

handleGET:
  push %ecx
  push $descriptor
  push $scanFormat
  call scanf
  pop garbage
  pop garbage

  push descriptor
  call GET
  pop garbage

  pop %ecx
  jmp retSkipPrint

handleDELETE:
  push %ecx
  push $descriptor
  push $scanFormat
  call scanf
  pop garbage
  pop garbage

  movl descriptor, %ecx
  cmpl $255, %ecx
  ja skipDelete
  cmpl $1, %ecx
  jl skipDelete

  push descriptor
  call DELETE
  pop garbage

  skipDelete:
  pop %ecx
  jmp retET

.global main
main:
  movl $0, %ecx
  lea hardDisk, %esi
  initializare:
    movb $0, (%esi, %ecx, 1)
    incl %ecx
    cmpl $1048576, %ecx
    jb initializare
//preluare input
  push $nrOperatii
  push $scanFormat
  call scanf
  pop garbage
  pop garbage

  xor %ecx, %ecx
  etLoop:
    push %ecx

    push $operatie
    push $scanFormat
    call scanf
    pop garbage
    pop garbage

    cmpl $1, operatie
    je handleADD
    cmpl $2, operatie
    je handleGET
    cmpl $3, operatie
    je handleDELETE

    retET:

    xor %eax, %eax
    push %ebx

    printLoopFinal:
    cmpl $1048576, %eax
    jae exitPrint
    xor %ebx, %ebx
    movb (%esi, %eax, 1), %bl
    cmpl $0, %ebx
    je nextFragment

    movl %ebx, printHelpVariable

    push $1048576
    push %eax
    push %ebx
    call getIntervalById
    pop garbage
    pop garbage
    pop garbage

    push %eax
    push %edx
etDebug:
    push %ebx

    movl %eax, %ecx
    movl %edx, %eax
    xor %edx, %edx
    movl $1024, %ebx
    divl %ebx
    push %edx
    push %eax
    xor %edx, %edx
    movl %ecx, %eax
    divl %ebx
    push %edx
    push %eax
    movl printHelpVariable, %eax
    push %eax
    push $printFormatADD
    call printf
    push $0
    call fflush
    pop garbage
    pop garbage
    pop garbage
    pop garbage
    pop garbage
    pop garbage
    pop garbage

    pop %ebx

    pop %edx
    pop %eax

    movl %edx, %eax
    incl %eax

    jmp printLoopFinal
    exitPrint:
    pop %ebx

    retSkipPrint:
    pop %ecx

    incl %ecx
    cmpl nrOperatii, %ecx
    jb etLoop

exit:
  push $0
  call fflush
  pop garbage

  movl $1, %eax
  xor %ebx, %ebx
  int $0x80
