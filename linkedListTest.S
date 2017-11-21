@
@ data section
@
.data

.balign 4
smallString: .word 5
largeString: .word 20

stringPrint:          .asciz "%s\n"
addressPrint:         .asciz "%08x\n"
numPrint:             .asciz "%d\n"
sizeTestZero:         .asciz "zero length on create"
findTest:             .asciz "find test"
findTestWhenEmpty:    .asciz "find test when linked list is empty"
findTestNewNode:      .asciz "find data from new node"
findTestNodeFalse:    .asciz "find data that is not in linked list"
lengthTestFirstNode:  .asciz "length with 1 node"
lengthTestSecondNode: .asciz "length with 2 nodes"
findTestTwoNodes:     .asciz "find data with 2 nodes in linked list"
segTest:              .asciz "seg test %d\n"

@
@ text section
@
.text

.global main
main:
  stmfd sp!,{r4-r10,lr}

  @ setup the register names
  testObj .req r4
  llist .req r5

  @ make a test object and store it it testObj
  bl start_test
  mov testObj,r0

  @ make a linked list and store it in llist
  bl create_linked_list
  mov llist,r0

  @ make sure the number of items in the llist is 0
  mov r0,llist    @ param1 = llist pointer
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#0       @ param1 = expected val of 0
  ldr r2,=sizeTestZero  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ test finding something when the list is 0 (try to find 11)
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = value to find
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#0       @ param1 = expected value = 0 (not found)
  ldr r2,=findTestWhenEmpty  @ param3 = message to print
  mov r3,testObj  @ param4 = test object pointer
  bl test_int

  @ add a number to the linked list (add number 11)                       
  mov r0,llist    @ param1 = llist pointer 
  mov r1,#11      @ param2 = data val of 11
  bl add_linked_list

  @ make sure the llist finds the number 11
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = number to find = 11
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value from find
  mov r0,#1       @ param1 = expected value = 1 (number was found)
  ldr r2,=findTestNewNode  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ try finding a number that isn't in the llist (12 in this case)
  mov r0,llist    @ param1 = llist ptr
  mov r1,#12      @ param2 = number to find = 12
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value from find
  mov r0,#0       @ param1 = expected value = 0 (not found)
  ldr r2,=findTestNodeFalse  @ param3 = message to print
  mov r3,testObj  @param4 = test object ptr
  bl test_int

  @ check to see if the length of the list is 1
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value from find
  mov r0,#1       @ param1 = expected value = 1
  ldr r2,=lengthTestFirstNode  @ param3 = message to print for test
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ add a node to the llist with data value of 12
  mov r0,llist    @ param1 = llist
  mov r1,#12      @ param2 = data value for the new node
  bl add_linked_list

  @ make sure the llist can find the number 12
  mov r0,llist    @ param1 = llist ptr
  mov r1,#12      @ param2 = number to find = 12
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTestTwoNodes  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 2
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#2       @ param1 = expected val = length of 2
  ldr r2,=lengthTestSecondNode  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ delete the llist
  mov r0,llist    @ param1 = llist ptr
  bl delete_linked_list_no_free

  @ end the test
  mov r0,testObj  @ param1 = test object ptr
  bl end_test

main_done:
  ldmfd sp!,{r4-r10,lr}
  bx lr

  .unreq testObj
  .unreq llist
