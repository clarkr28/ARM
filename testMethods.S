@
@ --- functions in this file ---
@ test_obj *start_test()
@ test_int(int expected, int actual, char *mesg, test_obj *obj)
@ end_test(test_obj *test_data_object)
@

.data
@
@ data section
@

passMesg:     .asciz "\x1b[32mPASS\x1b[0m - %s\n"
failMesg:     .asciz "\x1b[31mFAIL\x1b[0m - %s\n    expected:%d actual:%d\n"
summaryTitle: .asciz "\nTesting Summary:\n"
summaryData:  .asciz "%d Passed - %d Failed\n"

@ offests within the testing object
.equ pass_count, 0
.equ fail_count, 4
.equ test_obj_size, 8

.text
@
@ text section
@

@
@ test_obj *start_test()
@ create a testing object to store data about the tests
@
.global start_test     
start_test:     
  stmfd sp!,{lr}

  @ allocate memory with the size of the test object
  mov r0, #1      @ create one object
  mov r1, #test_obj_size  @ size of the test object
  bl calloc       @ allocate the memory

start_test_done:      
  ldmfd sp!,{lr}
  bx lr

@
@ test_int(int expected, int actual, char *mesg, test_obj *obj)
@
.global test_int
test_int:
  stmfd sp!,{r4-r8,lr}

  cmp r0,r1     @ expected = actual ?
  beq int_pass

  @ increment fail count
  ldr r4,[r3,#fail_count] @ load fail count
  add r4,r4,#1            @ increment fail count
  str r4,[r3,#fail_count] @ store fail count 

  @ print fail message
  mov r4,r0         @ save expected val in r4
  mov r3,r1         @ param4 = actual value
  ldr r0,=failMesg  @ param1 = failure format
  mov r1,r2         @ param2 = failure message
  mov r2,r4         @ param3 = expected value
  bl printf
  b test_int_done

int_pass:
  @ increnrnt pass count in test object
  ldr r0,[r3,#pass_count]   @ get pass count
  add r0,r0,#1              @ increment count
  str r0,[r3,#pass_count]   @ save pass count

  @ print pass message
  ldr r0,=passMesg  @ set the pass format
  mov r1,r2         @ use the pass message
  bl printf

test_int_done:
  ldmfd sp!,{r4-r8,lr}
  bx lr

@
@ end_test(test_obj *test_data_object)
@ print the results of the test and free the test object
@
.global end_test
end_test:
  stmfd sp!,{r4-r8,lr}
  mov r4,r0         @ save the test_obj in r4

  @ print the test summary title line
  ldr r0,=summaryTitle
  bl printf

  @ print the summary data line 
  ldr r0,=summaryData     @ param1 = printf formatted string 
  ldr r1,[r4,#pass_count] @ param2 = passed test count
  ldr r2,[r4,#fail_count] @ param3 = failed test count
  bl printf
  
  @ free the test_data
  mov r0,r4   @ param1 = test_obj
  bl free     

end_test_done:
  ldmfd sp!,{r4-r8,lr}
  bx lr
