API_KEY=$VIRUS_TOTAL_API_KEY
HASH=8a468d8671ededf24e04628913acc82665f3c14ad898cda33687716a3fed1c14

#curl -vvv https://www.virustotal.com/vtapi/v2/file/report -X POST --form resource="$HASH" --form apiKey="$API_KEY"
curl https://www.virustotal.com/api/get_file_report.json -X POST --form resource="$HASH" --form key="$API_KEY" | jq .
