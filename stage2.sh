#!/bin/bash

domain=$1
cd;pwd;mkdir bugbounty
cd bugbounty
pwd
mkdir $domain
cd $domain
pwd
mkdir api
cd api
pwd
echo "Running subdomain scanners..."

# Use hackertarget
echo "hackertarget"
curl -s "https://api.hackertarget.com/hostsearch/?q=$domain" | tee -a hackertarget.txt &

# Use bufferover
echo "bufferover"
curl -s "https://dns.bufferover.run/dns?q=.$domain" | jq -r .FDNS_A[] | cut -d',' -f2 >>bufferover.txt &

# Use dumpster
echo "dumpster"
curl -s https://www.dumpster.io/search?q="$domain" | grep -oP 'https?://[^"]*' | sed 's/https\?:\/\///' | awk -F/ '{print $1}' | sort -u >dumpster_results.txt 

# Use crt.sh
echo "crt.sh"
curl -s "https://crt.sh/?q=%.$domain" | grep $domain | sed "s/<\/\?TD\>/ /g" | tr -d '\n' | sed 's/<\/TR>/\n/g' | awk '{print $1}' | sed "s/^CN=//" | sort -u >crtsh_results.txt 

# Use WayBackMachine
echo "webBAckmachine"
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey" | sort -u | sed -e "s/^.*$domain//" -e "s/\/.*$//" -e "s/^www\.//" >waybackmachine_results.txt

# Use Riddler
echo "riddler"
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | awk -F "\",\"" '{print $2}' | sed 's/\"//g' | sort -u >riddler_results.txt 

# Use VirusTotal
echo "virustotal"
curl -s "https://www.virustotal.com/ui/domains/$domain/subdomains " | jq '.data | .[]' | sed 's/"//g' | sort -u >virustotal_results.txt 

# Use Subbuster
echo "subbuster"
curl -s "https://subbuster.cyberxplore.com/api/search?q=$domain" | jq -r '.subdomains[]' | sort -u >subbuster_results.txt 

# Use CertSpotter
echo "certspotter"
curl -s "https://api.certspotter.com/v1/issuances?domain=example.com&include_subdomains=true&expand=dns_names" | jq -r '.data[].dns_names[]' | sed 's/\"//g' | sort -u >certspotter_results.txt 

# Use JLD
echo "JLD"
curl -s https://jldc.me/anubis/subdomains/$domain | jq -r '.subdomains[]' | sort -u >jld_results.txt 

# Use SecurityTrails
echo "securitytrails"
curl -s https://api.securitytrails.com/v1/domain/$domain/subdomains | jq -r '.subdomains[]' | sort -u >securitytrails_results.txt 

# Use Sonar
echo "sonar"
curl -s https://sonar.omnisint.io/search?q=$domain | jq -r '.results[].name' | sort -u >sonar_results.txt 

# Wait for all requests to complete
wait
# Concatenate results from all scanners
cat *.txt || sort -u >>subdomains.txt || wc -l
exit