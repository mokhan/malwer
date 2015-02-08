API_KEY=$VIRUS_TOTAL_API_KEY
CLEAN_SHA=8c4d49445d0050884e0703571f187338b10c7836b08ed822cc5fc6cf15ac76b0
MAL_SHA=000c78b44246fe6a0016dd3bb67802abb200509d943a1ea3d749b0b11d768cf4

#curl https://www.virustotal.com/api/get_file_report.json -X POST --form resource="$MAL_SHA" --form key="$API_KEY" | jq .
curl https://www.virustotal.com/vtapi/v2/file/report --form apikey=$API_KEY --form resource=$MAL_SHA | jq .
