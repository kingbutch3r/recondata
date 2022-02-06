cd $1
name=$( head -1 scope.txt )
## find subdomains and assets
python3 ~/tools/telegram-notification/notify.py --message="Recon For $name Started " --token_id="5042684872:AAGh0qqkhO6ytYdTgyDzoJmxwso_ao814Es" --chat_id="570580658"
cat scope.txt| assetfinder --subs-only | anew from-assetfinder.txt
subfinder -dL scope.txt | anew from-subfinder.txt
cat from-subfinder.txt | anew from-assetfinder.txt 
cat scope.txt |anew from-assetfinder.txt
cat from-assetfinder.txt
cat from-assetfinder.txt | httprobe | anew hosts.txt
cat hosts.txt
python3 ~/tools/telegramification/notify.py --message="subdomains enumeration for $name finished" --token_id="5042684872:AAGh0qqkhO6ytYdTgyDzoJmxwso_ao814Es" --chat_id="570580658"
cat hosts.txt | fff -d 200 -S -o roots | anew fff_report.txt
python3 ~/tools/telegram-notification/notify.py --message="content discovery $name finished" --token_id="5042684872:AAGh0qqkhO6ytYdTgyDzoJmxwso_ao814Es" --chat_id="570580658"
grep -E '429' fff_report.txt | anew badrequest.txt
cut -d " " -f 2 badrequest.txt | fff -d 1000 -S -o roots |anew fff_bad_request_report.txt
cat hosts.txt | gau --threads 10|unew  | anew waybackdata
# arjun -i waybackdata -oT arjun_result.txt
cat waybackdata | gf xss | anew possible-xss.txt
cat waybackdata | gf rce | anew possible-rce.txt
cat waybackdata | gf ssti | anew possible-ssti.txt
cat waybackdata | gf redirect | anew possible-redirect.txt
cat waybackdata | gf sqli | anew possible-sqli.txt
cat waybackdata | gf lfi | anew possible-lfi.txt

dalfox file possible-xss.txt -o xss.txt
python ~/tools/sqlmap-dev/sqlmap.py -m possible-sqli.txt --batch --random-agent --level 5 --risk 3 --dbs
python3 ~/tools/Oralyzer/oralyzer.py -l possible-redirect.txt > redirect.txt
## nginx pathh  tranvsel
##find . -type f -name *.headers |xargs grep -E nginx |cut -d "/" -f 3 | anew nginx_urls.txt
##httpx -l nginx_urls.txt -path "///////../../../../../../etc/passwd" -status-code -mc 200 -ms 'root:' 
##for URL in $(<nginx_urls.txt); do ( fuff -u "${URL}/FUZZ" -w ~/Wordlist/nginx_path_travesel.txt -mc 200 -ms 'root:' ); done
## grafana CVE-2021-43798 

## TO DO  CORS CHECK
grep -E grafana hosts.txt 

