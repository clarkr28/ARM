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
llistPrintTitle:      .asciz "       llist contents: "
sizeTestZero:         .asciz "zero length on create"
findTest:             .asciz "find test"
findTestWhenEmpty:    .asciz "find test when linked list is empty"
findTestNodeFalse:    .asciz "find data that is not in linked list"
lengthTest0:          .asciz "length with 0 nodes"
lengthTest1:          .asciz "length with 1 node"
lengthTest2:          .asciz "length with 2 nodes"
lengthTest3:          .asciz "length with 3 nodes"
lengthTest4:          .asciz "length with 4 nodes"
findTest11:           .asciz "find data value 11 in linked list"
findTest12:           .asciz "find data value 12 in linked list"
findTest13:           .asciz "find data value 13 in linked list"
findTest14:           .asciz "find data value 14 in linked list"
notFoundTest11:       .asciz "data value 11 not found in linked list"
notFoundTest12:       .asciz "data value 12 not found in linked list"
notFoundTest13:       .asciz "data value 13 not found in linked list"
notFoundTest14:       .asciz "data value 14 not found in linked list"
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
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list

  @ make sure the llist finds the number 11
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = number to find = 11
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value from find
  mov r0,#1       @ param1 = expected value = 1 (number was found)
  ldr r2,=findTest11  @ param3 = message to print
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
  ldr r2,=lengthTest1  @ param3 = message to print for test
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ add a node to the llist with data value of 12
  mov r0,llist    @ param1 = llist
  mov r1,#12      @ param2 = data value for the new node
  bl add_linked_list
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list

  @ make sure the llist can find the number 12
  mov r0,llist    @ param1 = llist ptr
  mov r1,#12      @ param2 = number to find = 12
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest12  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 2
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#2       @ param1 = expected val = length of 2
  ldr r2,=lengthTest2  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ add a node to the llist with a data value of 13
  mov r0,llist    @ prarm1 = llist
  mov r1,#13      @ param2 = data value for the new node
  bl add_linked_list
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list

  @ make sure the llist can find the number 13
  mov r0,llist    @ param1 = llist ptr
  mov r1,#13      @ param2 = number to find = 13
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest13  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 12
  mov r0,llist    @ param1 = llist ptr
  mov r1,#12      @ param2 = number to find = 12
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest12  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 11
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = number to find = 11
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest11  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 3
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#3       @ param1 = expected val = length of 3
  ldr r2,=lengthTest3  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ add a node to the llist with a data value of 14
  mov r0,llist    @ prarm1 = llist
  mov r1,#14      @ param2 = data value for the new node
  bl add_linked_list
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list

  @ make sure the llist can find the number 14
  mov r0,llist    @ param1 = llist ptr
  mov r1,#14      @ param2 = number to find = 14
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest14  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 13
  mov r0,llist    @ param1 = llist ptr
  mov r1,#13      @ param2 = number to find = 13
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest13  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 12
  mov r0,llist    @ param1 = llist ptr
  mov r1,#12      @ param2 = number to find = 12
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest12  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 11
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = number to find = 11
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest11  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 4
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#4       @ param1 = expected val = length of 4
  ldr r2,=lengthTest4  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ remove 12 from the linked list (a middle node)
  mov r0,llist    @ param1 = llist ptr
  mov r1,#12      @ param2 = number to find and remove (12)
  bl remove_linked_list
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list

  @ make sure the llist can find the number 11
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = number to find = 11
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest11  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 13
  mov r0,llist    @ param1 = llist ptr
  mov r1,#13      @ param2 = number to find = 13
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest13  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 14
  mov r0,llist    @ param1 = llist ptr
  mov r1,#14      @ param2 = number to find = 14
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest14  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist CAN'T find the number 12
  mov r0,llist    @ param1 = llist ptr
  mov r1,#12      @ param2 = number to find = 12
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#0       @ param1 = expected value = 0 (number not found)
  ldr r2,=notFoundTest12  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 3
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#3       @ param1 = expected val = length of 3
  ldr r2,=lengthTest3  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ remove 11 from the linked list (head node w/ a tail)
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = number to find and remove (11)
  bl remove_linked_list
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list

  @ make sure the llist can find the number 13
  mov r0,llist    @ param1 = llist ptr
  mov r1,#13      @ param2 = number to find = 13
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest13  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist can find the number 14
  mov r0,llist    @ param1 = llist ptr
  mov r1,#14      @ param2 = number to find = 14
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest14  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist CAN'T find the number 11
  mov r0,llist    @ param1 = llist ptr
  mov r1,#11      @ param2 = number to find = 11
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#0       @ param1 = expected value = 0 (number not found)
  ldr r2,=notFoundTest11  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 2
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#2       @ param1 = expected val = length of 2
  ldr r2,=lengthTest2  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ remove 14 from the linked list (tail with nodes before it)
  mov r0,llist    @ param1 = llist ptr
  mov r1,#14      @ param2 = number to find and remove (14)
  bl remove_linked_list
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list
  
  @ make sure the llist can find the number 13
  mov r0,llist    @ param1 = llist ptr
  mov r1,#13      @ param2 = number to find = 13
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected value = 1 (number found)
  ldr r2,=findTest13  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist CAN'T find the number 14
  mov r0,llist    @ param1 = llist ptr
  mov r1,#14      @ param2 = number to find = 14
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#0       @ param1 = expected value = 0 (number not found)
  ldr r2,=notFoundTest14  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 1
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#1       @ param1 = expected val = length of 1
  ldr r2,=lengthTest1  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ remove 13 from the linked list (only one node in llist)
  mov r0,llist    @ param1 = llist ptr
  mov r1,#13      @ param2 = number to find and remove (13)
  bl remove_linked_list
  mov r0,llist    @ param1 = llist ptr
  bl llist_test_print   @ print the linked list
 
  @ make sure the llist CAN'T find the number 13
  mov r0,llist    @ param1 = llist ptr
  mov r1,#13      @ param2 = number to find = 13
  bl find_ptr_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#0       @ param1 = expected value = 0 (number not found)
  ldr r2,=notFoundTest13  @ param3 = message to print
  mov r3,testObj  @ param4 = test object ptr
  bl test_int

  @ make sure the llist has size 0
  mov r0,llist    @ param1 = llist ptr
  bl length_linked_list
  mov r1,r0       @ param2 = actual value
  mov r0,#0       @ param1 = expected val = length of 0
  ldr r2,=lengthTest0  @ param3 = message to print
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


@
@ void llist_test_print(llist *llist)
@
llist_test_print:
  stmfd sp!,{r4,lr}

  mov r4,r0     @ save the llist in r4
  
  @ print the title string
  ldr r0,=llistPrintTitle @ param1 = title string
  bl printf
  @ call the function to print the llist
  mov r0,r4     @ param1 = llist pointer
  bl print_linked_list

llist_test_print_done:
  ldmfd sp!,{r4,lr}
  bx lr
