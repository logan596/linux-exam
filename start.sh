#!/bin/bash

create_user() {
# Create a user to SSH into as.
useradd exam
SSH_USERPASS=12345678
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin exam)
echo ssh exam password: $SSH_USERPASS
}

# Call all functions
create_user
