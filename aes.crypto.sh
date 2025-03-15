#!/bin/bash

# Function to encrypt a file
encrypt_file() {
    echo "Enter the file you want to encrypt:"
    read file
    echo "Enter the password for encryption:"
    read -s password

    # Encrypt using AES-256-CBC and store it in a .enc file
    openssl enc -aes-256-cbc -salt -in "$file" -out "$file.txt" -pass pass:"$password"
    echo "File encrypted successfully. Encrypted file is: $file.enc"
}

# Function to decrypt a file
decrypt_file() {
    echo "Enter the encrypted file you want to decrypt (e.g., file.enc):"
    read file
    echo "Enter the password for decryption:"
    read -s password

    # Decrypt using AES-256-CBC and output to a .dec file
    openssl enc -d -aes-256-cbc -in "$file" -out "$file.dec" -pass pass:"$password"
    echo "File decrypted successfully. Decrypted file is: $file.txt"
}

# Main menu
echo "AES File Encryption/Decryption Script"
echo "1. Encrypt a file"
echo "2. Decrypt a file"
echo "3. Exit"
read -p "Choose an option (1-3): " option

case $option in
    1)
        encrypt_file
        ;;
    2)
        decrypt_file
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Please choose 1, 2, or 3."
        exit 1
        ;;
esac
