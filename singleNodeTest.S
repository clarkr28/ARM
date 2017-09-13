.data
@
@ data section
@ 

.balign 4
smallString: .word 5
largeString: .word 20

smallStringData: .asciz "Hi"
largeStringData: .asciz "It's great to see you"
stringPrint:     .asciz "%s\n"
addressPrint:    .asciz "%08x\n"
constructTest:   .asciz "constructor & get data"
setDataTest:     .asciz "set data"
nextNullTest:    .asciz "next ptr null"
nextSetTest:     .asciz "next ptr set"

.text
@
@ text section
@

.global main
main:
  stmfd sp!,{r4-r10,lr}

  @ make a testing object and save it in r10
  bl start_test   @ create test obj
  mov r10,r0      @ save test obj in r10

  @ make a char* to give to the node
  mov r0, #1      @ allocate one string
  ldr r1, =smallString @ ptr to size of string
  ldr r1,[r1]     @ load actual string value 
  add r1,r1,#1    @ allocate size of string +1
  bl calloc

  @ copy the small string into the allocated space
  ldr r1,=smallStringData
  ldr r2,=smallString
  ldr r2,[r2]
  bl strncpy

  @ make a single node
  mov r0,r4       @ pass the char* as a parameter
  bl create_single_node
  mov r5,r0       @ save the first node to r5

  @ get the data from the node and test it
  bl get_data_single_node @ get data from node
  mov r1,r0       @ set actual data as second param
  mov r0,r4       @ set expected val in r0
  ldr r2,=constructTest   @ constructor test string
  mov r3,r10      @ set the test object parameter
  bl test_int

  @ make a new char* and put data in it
  mov r0,#1       @ allocate one string
  ldr r1,=largeString @ size of large string
  ldr r1,[r1]
  add r1,r1,#1    @ allocate size of string +1
  bl calloc
  mov r6,r0       @ save the new string pointer in r6
  ldr r1,=largeStringData @ prt to the large string
  ldr r2,=largeString     @ max size of characters to copy
  ldr r2,[r2]     
  bl strncpy      @ copy the string into the new char *

  @ set the data in the node to the new string
  mov r1,r6       @ set the new char* as param2
  mov r0,r5       @ set the node as param1
  bl set_data_single_node

  @ get the data from the node and print it
  mov r0,r5       @ set node as param1
  bl get_data_single_node
  mov r1,r0       @ set actual data as param2
  mov r0,r6       @ set expected data as param1
  ldr r2,=setDataTest
  mov r3,r10      @ param4 = test obj
  bl test_int

  @ test the next node data by seeing if it was initialized to 0
  @ get the next node ptr from the node and test its address
  mov r0,r5       @ param1 = single node
  bl get_next_single_node
  mov r1,r0       @ param2 = ptr to next node (actual value)
  mov r0,#0       @ param1 = expected val of 0
  ldr r2,=nextNullTest  @ param3 = test message to print
  mov r3,r10      @ param4 = test obj
  bl test_int

  @ make a second node
  mov r0,#0       @ param1 = null ptr
  bl create_single_node
  mov r7,r0       @ r7 = second node

  @ make the first node point to the second node
  mov r0,r5       @ param1 = first node
  mov r1,r7       @ param2 = second node
  bl set_next_single_node

  @ test that the first node points to the second node
  mov r0,r5       @ param1 = first node
  bl get_next_single_node
  mov r1,r0       @ param2 = actual value to test
  mov r0,r7       @ param1 = expected value (second node address)
  ldr r2,=nextSetTest @ param3 = message to print
  mov r3,r10      @ param4 = test obj
  bl test_int

  @ free the first node
  mov r0,r4       @ get ptr to the first string
  bl free

  @ delete the first node and it's data
  mov r0,r5       @ param1 = first node
  bl delete_single_node @ free the node, which returns the data poitner
  bl free         @ free the data from the node

  @ delete the second node and not it's data (the data was set to null)
  mov r0,r7       @ param1 = second node
  bl delete_single_node

  @ end the test (and delete the test obj)
  mov r0,r10      @ set test obj as param 1
  bl end_test

main_done:
  ldmfd sp!,{r4-r10,lr}
  bx lr

