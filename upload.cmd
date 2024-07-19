@echo off

:: Define variables
set "USER=sa@nga"
set "PASSWORD=Welcome1"
set "BASE_URL=http://localhost:8080/dev"
set "AUTH_ENDPOINT=%BASE_URL%/authentication/sign_in"
set "UPLOAD_ENDPOINT=%BASE_URL%/api/shared_spaces/1001/external-entity-actions/general-details-in-panel/bundle"
set "GUID=8dc56540-157e-419b-a194-cb90fe328802"
set "FILE_PATH=target/AppModulesAssistor.zip"

:: Sign in and get cookies
curl -s -i -c cookies.txt -X POST "%AUTH_ENDPOINT%" ^
  -H "Content-Type: application/json" ^
  -d "{\"user\":\"%USER%\",\"password\":\"%PASSWORD%\"}" > signin_response.txt

:: Extract HTTP status code from the sign-in response
for /f "tokens=2" %%a in ('findstr /r "^HTTP/1.1 [0-9][0-9][0-9]" signin_response.txt') do set SIGNIN_STATUS=%%a

:: Check if sign-in was successful
if "%SIGNIN_STATUS%"=="200" (
  echo Sign-In Successful.
) else (
  echo Sign-In Failed. Response Code: %SIGNIN_STATUS%
  if exist cookies.txt del cookies.txt
  exit /b 1
)

:: Execute cURL command to upload file with extracted cookies, including headers in the response (-i)
curl -s -i -b cookies.txt "%UPLOAD_ENDPOINT%?guid=%GUID%" ^
  -X PUT ^
  -H "Accept: */*" ^
  -H "Accept-Language: en-GB,en;q=0.9,en-US;q=0.8,he;q=0.7" ^
  -H "Connection: keep-alive" ^
  -H "Content-Type: application/octet-stream" ^
  --data-binary "@%FILE_PATH%" > upload_response.txt

:: Extract HTTP status code from upload response
for /f "tokens=2" %%a in ('findstr /r "^HTTP/1.1 [0-9][0-9][0-9]" upload_response.txt') do set UPLOAD_STATUS=%%a

:: Check if file upload was successful
if "%UPLOAD_STATUS%"=="200" (
  echo File Upload Successful.
) else (
  echo File Upload Failed. Response Code: %UPLOAD_STATUS%
)

:: Clean up temporary files (optional)
del signin_response.txt
del upload_response.txt
del cookies.txt