.data

@
@ single node
@
@ void *create_single_node(void *data)
@ set_data_single_node(void *node, void *data)
@ void *get_data_single_node(void *node)
@ set_next_single_node(void *node, void *next_node)
@ node *get_next_single_node(void *node)
@ void *delete_single_node(void *single_node)
@
.equ single_node_data, 0
.equ single_node_next, 4
.equ single_node_size, 8

.text

.global create_single_node
@
@ Create a single node
@ void *create_single_node(void *data)
@
create_single_node:
  push {r4, lr}

  @ allocate memory for the node
  mov r4, r0      @ save the ptr to data
  mov r0, #1      @ make one object
  mov r1, #single_node_size @ size of a single node
  bl calloc

  @ save the data to the node 
  str r4,[r0,#single_node_data]

create_single_node_done:
  pop {r4, lr}
  bx lr


@
@ set the data ptr
@ set_data_single_node(void *node, void *data)
@
.global set_data_single_node
set_data_single_node:

  @ save the data ptr to the node
  str r1,[r0,#single_node_data]

set_data_single_node_done:
  bx lr


@
@ get the data ptr
@ void *get_data_single_node(void *node)
@
.global get_data_single_node
get_data_single_node:

  @ load the ptr to the node
  ldr r0,[r0,#single_node_data]

get_data_single_node_done:
  bx lr


@
@ set what node comes next
@ set_next_single_node(void *node, void *next_node)
@
.global set_next_single_node
set_next_single_node:
  
  str r1,[r0,#single_node_next]
 
set_next_single_node_done:
  bx lr


@
@ get ptr to the next node
@ node *get_next_single_node(void *node)
@
.global get_next_single_node
get_next_single_node:
  
  @ load the ptr to the next node
  ldr r0,[r0,#single_node_next]

get_next_single_node_done:
  bx lr


@
@ delete/free the node and return the data ptr
@ void *delete_single_node(void *single_node)
@
.global delete_single_node
delete_single_node:
  push {r4, lr}

  ldr r4,[r0,#single_node_data] @ save data ptr to r4
  bl free           @ free the node

  mov r0, r4        @ restore the data ptr

delete_single_node_done:
  pop {r4, lr}
  bx lr

