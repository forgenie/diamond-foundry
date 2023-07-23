#!/bin/bash

# Set the source and destination folders
src_folder="src"
out_folder="out"
dest_folder="artifacts"

# Clean up the destination folder before execution
rm -rf "$dest_folder"

# Create the destination folder if it doesn't exist
mkdir -p "$dest_folder"

# Loop through the source folder and move corresponding production artifacts
find "$src_folder" -type f -name "*.sol" | while read -r contract_path; do
    contract_name=$(basename "$contract_path" .sol)

    # Exclude contracts ending with "Base.sol" or "Storage.sol"
    if [[ "$contract_name" != *"Base" && "$contract_name" != *"Storage" ]]; then
        json_file="$out_folder/$contract_name.sol/$contract_name.json"
        if [ -f "$json_file" ]; then
            cp "$json_file" "$dest_folder/$contract_name.json"
        fi
    fi
done

cp "$out_folder/IERC721.sol/IERC721.json" "$dest_folder/IERC721.json"
cp "$out_folder/IERC721Metadata.sol/IERC721Metadata.json" "$dest_folder/IERC721Metadata.json"

pnpm prettier --write ./artifacts
echo "Production artifacts moved to $dest_folder."
