.data

segTest:  .asciz "segTest %d\n"
printInt: .asciz "%d "
newline:  .asciz "\n"

@
@ - Linked list ADT -
@ - this linked list implementation uses singleNode.S for nodes -
@
@ llist *create_linked_list()
@ void add_linked_list(llist *llist, void *data)
@ int find_ptr_linked_list(llist *llist, void *data)
@ void print_linked_list(llist *llist)
@ int length_linked_list(llist *llist)
@ int remove_linked_list(llist *llist, void *data)
@ int find_str_linked_list(llist *llist, char *data)
@ void delete_linked_list(llist *llist)
@ void delete_linked_list_no_free(llist *llist) 
@

.equ head, 0
.equ tail, 4
.equ count, 8
.equ linked_list_size, 12

.text

@
@ llist *create_linked_list()
@ create an empty linked list
@
.global create_linked_list
create_linked_list:
  stmfd sp!,{lr}

  mov r0,#1             @ allocate one object
  mov r1,#linked_list_size @ size of object
  bl calloc

  @ptr is in r0 so just return
  ldmfd sp!,{lr}
  bx lr

@
@ void add_linked_list(llist *llist, void *data)
@ take a new data ptr, add it to a node, and add the node to the llist
@
.global add_linked_list
add_linked_list:
  stmfd sp!,{r4-r5,lr}

  @ create the new node
  mov r4,r0         @ save the ptr to the linked list
  mov r0,r1         @ move the data ptr to r0
  bl create_single_node

  @ see if the llist is null to determine where to add the node
  mov r5,r0         @ move the new node to r5
  ldr r0,[r4,#tail] @ load the ptr to the tail to see if it's null
  cmp r0,#0         @ see if the tail is null
  beq add_first_node

  @ add a node to the end of the linked list (other nodes already exist)
  @ r0 already holds a ptr to the tail
  mov r1,r5         @ set the ptr to the new node as the second param
  bl set_next_single_node @ make the last node's next point to the new node
  str r5,[r4,#tail] @ make tail point to the new node

  b increment_count @ skip to incrementing the count

add_first_node:
  @ this is the first node, so make head and tail point to it
  str r5,[r4,#head]
  str r5,[r4,#tail]

increment_count:
  @ add one to the count of the linked list
  ldr r0,[r4,#count]
  add r0,r0,#1
  str r0,[r4,#count]
  
add_linked_list_done:
  ldmfd sp!,{r4-r5,lr}
  bx lr

@
@ int find_ptr_linked_list(llist *llist, void *data)
@
@ return 1 if the data ptr is in the list, 0 otherwise.
@ this function only checks to see if the pointers are pointing
@ to the same thing (meaning they are equal), it does not load the
@ values at the pointers and compare the values
@
.global find_ptr_linked_list
find_ptr_linked_list:
  stmfd sp!,{r4-r8,lr}

  mov r4,r1     @ keep the data ptr to search for in r4
  ldr r0,[r0,#head] @ get a ptr to the first node

@ loop through all the nodes in the linked list
search_llist_loop:
  cmp r0,#0     @ is the node we are on null?
  beq ptr_not_found

  mov r5,r0     @ save the node in r5
  bl get_data_single_node @ get the data ptr from the node
  cmp r0,r4     @ are r0 and r4 pointing to the same thing?
  beq ptr_found @ exit the loop and set return as found

  @ get the next node
  mov r0,r5     @ param1 = ptr to current node
  bl get_next_single_node

  b search_llist_loop @ go to top of the loop (iterate again)

ptr_found:
  mov r0,#1     @ set return code to 1 and leave function
  b find_ptr_linked_list_done

ptr_not_found:
  @ 0 is already in r0, which means not found, so just return

find_ptr_linked_list_done:
  ldmfd sp!,{r4-r8,lr}
  bx lr


@
@ void print_linked_list(llist *llist)
@ print each value in the llist to standard output
@
.global print_linked_list
print_linked_list:
  stmfd sp!,{r4-r8,lr}

  ldr r0,[r0,#head] @ get the ptr to the first node

@ loop through every node in the llist and print it
print_llist_loop:
  cmp r0,#0     @ is the node we are on null?
  beq print_linked_list_done

  mov r5,r0     @ save current node in r5
  bl get_data_single_node @ get the data from the node
  mov r1,r0     @ param2 = value to print
  ldr r0,=printInt  @ param1 = format string to print
  bl printf     @ print the value

  @ get the next node
  mov r0,r5     @ param1 = ptr to current node
  bl get_next_single_node

  b print_llist_loop  @ iterate again

print_linked_list_done:
  @ print a newline
  ldr r0,=newline
  bl printf

  ldmfd sp!,{r4-r8,lr}
  bx lr


@
@ int length_linked_list(llist *llist)
@ return the length of the linked list
@
.global length_linked_list
length_linked_list:
  ldr r0,[r0,#count]  @ load the count from the llist
  bx lr
@
@ int remove_linked_list(llist *llist, void *data)
@ find the data ptr in the llist that points to the same object (where
@ the pointers are equal), free the node but not the data ptr
@
.global remove_linked_list
remove_linked_list:
  stmfd sp!,{r4-r8,lr}

  mov r4,r0         @ save a ptr to the llist in r4
  mov r5,r1         @ save data ptr to find in r5
  mov r6,#0         @ save the previous node in r6 (null to start)
  ldr r0,[r0,#head] @ load the first node into r0


  @ loop through the llist and remove the node with the same ptr
remove_loop:
  cmp r0,#0         @ is the node null ?
  beq no_node_removed

  mov r7,r0         @ save the current node in r7
  bl get_data_single_node @ get the data ptr for this node

  cmp r0,r5         @ is this the pointer to delete?
  beq remove_node

  mov r6,r7         @ set the previous node as r6
  mov r0,r7         @ set param to get the next node
  bl get_next_single_node @ get the next node into r0
  b remove_loop

remove_node:
  @ remove the node in r7 (free node, set next of prev node, update head
  @ and tail if necessary

  mov r0,r7         @ r0 = node to delete
  bl get_next_single_node @ r0 = next node

  @ get the head ptr and update it if necessary
  ldr r1,[r4,#head] @ r1 = head node
  cmp r1,r7         @ head node != node to delete ?
  bne no_head_update

  str r0,[r4,#head] @ head ptr = next node
  @ since head pointer will be deleted, no prev node exists
  b no_prev_node    

no_head_update:

  @ update previous node's next pointer
  mov r1,r0         @ param2 - the next node
  mov r0,r6         @ param1 - the previous node
  bl set_next_single_node

no_prev_node:

  @ if tail ptr points to node to delete, set tail ptr to prev node
  ldr r1,[r4,#tail] @ r1 = tail node
  cmp r1,r7         @ tail node != node to delete ?
  bne no_tail_update

  ldr r6,[r4,#tail] @ tail ptr = previous node
no_tail_update:
  
  mov r0,r7         @ param 1 - the node to be deleted
  bl free

  @ update the count of the llist
  ldr r2,[r4,#count]  @ get the count of the llist
  sub r2,r2,#1        @ count = count - 1
  str r2,[r4,#count]  @ save the new count to the llist

  mov r0,#1         @ set return code to 1, then return
  b remove_linked_list_done

no_node_removed:
  mov r0,#0         @ set the return value to 0, then return
  b remove_linked_list_done

remove_linked_list_done:
  ldmfd sp!,{r4-r8,lr}
  bx lr

@
@ int find_str_linked_list(llist *llist, char *data)
@ iterate through the data pointers in the linked list and compare the
@ DATA at the pointers.  Assume they are char * pointers and compare
@ until a null character is found.
@
.global find_str_linked_list
find_str_linked_list:
  stmfd sp!,{r4-r8,lr}

  ldr r5,[r0,#head]   @ r5 = head node
  mov r4,r1           @ r4 = data to find

node_loop:
  cmp r5,#0           @ current node = null ?
  b str_not_found

  @ get the char * from the current node
  mov r0,r5           @ param1 - current node
  bl get_data_single_node @ r0 = char * from current node

  @ compare the two char * pointers with strcmp
  mov r1,r4           @ param2 - char * to compare to
  bl strcmp           @ r0 = strcmp result
  cmp r0,#0           @ strcmp result = 0 ?
  beq str_found       @ match was found!

  mov r0,r5           @ r0 = current node
  bl get_next_single_node @ r0 = next node
  mov r5,r0           @ r5 = next node
  b node_loop         @ iterate through the node loop again

str_not_found:
  mov r0,#0           @ r0 = 0 (return 0 for string not found)
  b find_str_linked_list_done
  
str_found:
  mov r0,#1           @ r0 = 1 (return 1 for string found)
  b find_str_linked_list_done

find_str_linked_list_done:
  ldmfd sp!,{r4-r8,lr}
  bx lr


@
@ iterate through the llist and delete each node and its data
@ void delete_linked_list(llist *llist)
@
.global delete_linked_list
delete_linked_list:
  stmfd sp!,{r4-r8,lr}

  @ get the pointer to the first node
  mov r4,r0         @ save llist ptr in r4
  ldr r5,[r0,#head] @ load first node into r5

delete_loop:
  cmp r5,#0         @ is the node null?
  beq delete_loop_done

  mov r0,r5         @ move current node to r0
  bl get_next_single_node @ get the next node
  mov r6,r0         @ save the next node to r6

  mov r0,r5         @ move node to free into r0
  bl delete_single_node @ delete the node (which returns the data ptr)
  cmp r0,#0         @ is the data null ?
  beq null_data

  bl free           @ free the data pointer from the node

null_data:
  mov r5,r6         @ set the current node to r6 (next node)
  b delete_loop

delete_loop_done:
  mov r0,r4         @ put the llist ptr in r0 to be freed
  bl free           @ free the llist data

delete_linked_list_done:
  ldmfd sp!,{r4-r8,lr}
  bx lr

@
@ iterate through the llist, delete the node but NOT the data.
@ this should be used if the llist nodes are holding something like 
@ numbers instead of pointers. 
@ void delete_linked_list_no_free(llist *llist) 
@
.global delete_linked_list_no_free
delete_linked_list_no_free:
  stmfd sp!,{r4-r6,lr}

  @ get the pointer to the first node
  mov r4,r0         @ save llist ptr in r4
  ldr r5,[r0,#head] @ load first node into r5

delete_loop_no_free:
  cmp r5,#0         @ is the node null?
  beq delete_loop_no_free_done
  
  mov r0,r5         @ move current node to r0
  bl get_next_single_node @ get the next node
  mov r6,r0         @ save the next node to r6

  mov r0,r5         @ move the node to free to r0
  bl delete_single_node @ returns data, but that doesn't need go be freed

  @ if the current node is the tail, exit the loop
  ldr r0,[r4,#tail]
  cmp r5,r0         @ is the current node the tail?
  beq delete_loop_no_free_done

  mov r5,r6         @ current node = next node (set before iterating again)
  b delete_loop_no_free

delete_loop_no_free_done:
  mov r0,r4         @ put the llist ptr in r0 to be freed
  bl free

delete_linked_list_no_free_done:
  ldmfd sp!,{r4-r6,lr}
  bx lr

