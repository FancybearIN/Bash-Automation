#!/bin/bash

# Optimized Bash program for searching for subdomains

# Define the domain variable
domain=$1
cd;mkdir bugbounty;cd bugbounty;pwd;mkdir $domain;cd $domain;pwd

# Use google to search for subdomains
echo "Running on google...."
curl -s "https://www.google.com/search?q=site:$domain" | grep -oP '(?<=href=")[^"]*' | grep -E "^http.*$domain" >> temp_subdomains.txt

# Use Bing to search for subdomains
echo "Running on bing..."
curl -s "https://www.bing.com/search?q=site:$domain" | grep -oP '(?<=href=")[^"]*' | grep -E "^http.*$domain" >> temp_subdomains.txt

# Use Yahoo to search for subdomains
echo "Running on yahoo...."
curl -s "https://search.yahoo.com/search?p=site:$domain" | grep -oP '(?<=href=")[^"]*' | grep -E "^http.*$domain" >> temp_subdomains.txt

# Use DuckDuckGo to search for subdomains
echo "Running on DuckDuckGO...."
curl -s "https://duckduckgo.com/?q=site:$domain" | grep -oP '(?<=href=")[^"]*' | grep -E "^http.*$domain" >> temp_subdomains.txt

# Use shodan to search for subdomains
# echo "Running on shodan..."
# shodan host "$domain3" >> temp_subdomains.txt

# Use baidu
echo "Running Baidu..."
curl -s "https://www.baidu.com/s?wd=$domain&pn=0&oq=$domain&ie=utf-8" -A "Mozilla/5.0 (Windows NT 10.0;Win64) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36" | grep -o ">\w*.$domain<" | sed "s/>//" | sed "s/<//" >> temp_subdomains.txt

# Sort and remove duplicates
sort temp_subdomains.txt | uniq > finalsubdomains.txt

# Remove the temporary file
rm temp_subdomains.txt

echo "Subdomains found and saved in finalsubdomains.txt"
exit
# Brute_Tools(){
# using brute frocing tools
# echo "Running the Brute-Frocing..."

# # Use ffuf to brute-force subdomains
# xterm -e ""ffuf -w /usr/share/wordlists/dirb/common.txt -u https://"$domain" -H "Host: FUZZ.$domain" -fs 4242 -o ffuf_results.txt -v=false" " &

# # Use gobuster to brute-force subdomains
# xterm -e ""gobuster dns -d "$domain" -w /usr/share/wordlists/dirb/common.txt -t 50 -o gobuster_results.txt""


# # Extract subdomains from ffuf and gobuster output
# grep "$domain" ffuf_output.txt || cut -d'/' -f3 || sort -u >> subdomains.txt &
# grep "$domain" gobuster_output.txt || cut -d',' -f1 || sort -u >> subdomains.txt;


# # }
# # Brute_Tools

# # Sort and remove duplicates
# sort subdomains.txt | uniq > finalsubdomains.txt

# # Remove the temporary file
# rm subdomains.txt

# echo "Subdomains found and saved in finalsubdomains.txt"
