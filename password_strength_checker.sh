#!/bin/bash
read -p "Enter a password: " password
if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] && "$password" =~ [^a-zA-Z0-9] ]]; then
    echo "Password is strong!"
else
    echo "Password is weak. It should be at least 8 characters long, contain uppercase, lowercase, numbers, and symbols."
fi
