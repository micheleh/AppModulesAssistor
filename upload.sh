#!/bin/bash

# Define variables
USER='sa@nga'
PASSWORD='Welcome1'
BASE_URL="http://localhost:8080/dev"
AUTH_ENDPOINT="$BASE_URL/authentication/sign_in"
UPLOAD_ENDPOINT="$BASE_URL/api/shared_spaces/1001/external-entity-actions/general-details-in-panel/bundle"
GUID='8dc56540-157e-419b-a194-cb90fe328802'
FILE_PATH="target/AppModulesAssistor.zip"

# Sign in and get cookies
SIGNIN_RESPONSE=$(curl -s -i -c cookies.txt -X POST "$AUTH_ENDPOINT" \
  -H 'Content-Type: application/json' \
  -d '{"user":"'"$USER"'","password":"'"$PASSWORD"'"}')

# Extract HTTP status code from the sign-in response
SIGNIN_STATUS=$(echo "$SIGNIN_RESPONSE" | grep "HTTP/1.1" | awk '{print $2}')

# Check if sign-in was successful
if [[ $SIGNIN_STATUS == "200" ]]; then
  echo "Sign-In Successful."
else
  echo "Sign-In Failed. Response Code: $SIGNIN_STATUS"
  # Delete cookies file if it exists
  [ -f cookies.txt ] && rm cookies.txt
  exit 1
fi

# Execute cURL command to upload file with extracted cookies, including headers in the response (-i)
RESPONSE=$(curl -s -i -b cookies.txt "${UPLOAD_ENDPOINT}?guid=${GUID}" \
  -X 'PUT' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-GB,en;q=0.9,en-US;q=0.8,he;q=0.7' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/octet-stream' \
  --data-binary "@${FILE_PATH}")

# Extract HTTP status code from upload response
UPLOAD_STATUS=$(echo "$RESPONSE" | grep "HTTP/1.1" | awk '{print $2}')

# Check if file upload was successful
if [[ $UPLOAD_STATUS == "200" ]]; then
  echo "File Upload Successful."
else
  echo "File Upload Failed. Response Code: $UPLOAD_STATUS"
fi

# Clean up cookies file (optional)
rm cookies.txt