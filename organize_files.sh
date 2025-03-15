#!/bin/bash

# Function to create directories for different file types
organize_files() {
    # Prompt user to specify the directory to organize (default is the current directory)
    echo "Enter the directory to organize (leave empty for the current directory):"
    read target_directory
    target_directory="${target_directory:-.}"

    # Make sure the target directory exists
    if [ ! -d "$target_directory" ]; then
        echo "The directory '$target_directory' does not exist!"
        exit 1
    fi

    # Loop through all files in the specified directory
    for file in "$target_directory"/*; do
        # Skip directories
        if [ -d "$file" ]; then
            continue
        fi
        
        # Extract file extension
        extension="${file##*.}"
        
        # Convert extension to lowercase
        extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
        
        # Define the folder for this type of file
        case "$extension" in
            jpg|jpeg|png|gif|bmp)
                folder="Images"
                ;;
            mp4|mkv|avi|mov)
                folder="Videos"
                ;;
            mp3|wav|flac)
                folder="Audio"
                ;;
            pdf|txt|docx|xlsx)
                folder="Documents"
                ;;
            zip|tar|gz|rar)
                folder="Archives"
                ;;
            *)
                folder="Others"
                ;;
        esac
        
        # Create the folder if it doesn't exist
        if [ ! -d "$target_directory/$folder" ]; then
            mkdir "$target_directory/$folder"
        fi
        
        # Move the file to its appropriate folder
        mv "$file" "$target_directory/$folder/"
        echo "Moved '$file' to '$target_directory/$folder/'"
    done

    echo "File organization complete!"
}

# Main function to start the file organization
echo "File Organizer Script"
echo "======================"
organize_files
