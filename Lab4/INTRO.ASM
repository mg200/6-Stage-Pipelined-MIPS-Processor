.model small      
.stack 64
.data  
x db 0
arr db 100 dup(0)
.code

main proc far ; pro
;ax,bx,cx,dx
mov ax,bx; ax=bx
add ax,bx; ax=ax+bx
xor ax,ax; ax=0
mov ax,0; ax=0
sub ax,bx; ax=ax-bx



main endp 
end main 

