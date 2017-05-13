
.data
y: .byte 35
z: .byte 16
x: .byte 0

.text
#load y and z
la $t1, z
lb $t0, -1($t1)
lb $t3, 0($t1)

#add y and z
add $t4, $t0, $t3
sb $t4, x

#overwrite y and z
add $t1, $t4, $zero
add $t3, $t4, $zero



