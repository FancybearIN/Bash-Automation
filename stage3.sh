#!/bin/bash

# Use sublist3r
# echo "Running Sublist3r..."
# xterm -e "sudo sublist3r -d $domain -o subdomains.txt"
domain=$1
cd||mkdir bugbounty||cd bugbounty||mkdir $domain||cd $domain||

# Use subbrute
echo "Running Subbrute..."
xterm -e "subbrute.py $domain > subdomains.txt"

# Use amass
echo "Running Amass..."
xterm -e "amass enum -d $domain -o subdomains.txt"

# Use subfinder
echo "Running Subfinder..."
xterm -e "subfinder -d $domain -o subdomains.txt"

# Use assetfinder
echo "Running Assetfinder..."
xterm -e "assetfinder --subs-only $domain > subdomains.txt"

# Use findomain
echo "Running Findomain..."
xterm -e "findomain -t $domain -o subdomains.txt"

# Use knockpy
echo "Running Knockpy..."
xterm -e "knockpy $domain > subdomains.txt"

# Use aquatone
echo "Running Aquatone..."
xterm -e "aquatone-scan -d $domain -o subdomains.txt/"

# Remove duplicate subdomains from the lis
xterm -e "sort subdomains.txt | uniq > subdomains_final.txt"


# Sort and remove duplicates
sort subdomains.txt | uniq > finalsubdomains.txt

# Remove the temporary file
rm subdomains.txt

echo "Subdomains found and saved in finalsubdomains.txt"