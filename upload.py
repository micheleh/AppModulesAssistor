import requests
import json

# Define variables
ACTION_NAME = 'app-modules-assistor-panel'
ACTION_CONFIGURATION_FILE = 'src/action-configuration.json'
USER = 'sa@nga'
PASSWORD = 'Welcome1'
BASE_URL = "http://localhost:8080/dev"
AUTH_ENDPOINT = f"{BASE_URL}/authentication/sign_in"
EXTERNAL_ACTIONS_ENDPOINT = f"{BASE_URL}/api/shared_spaces/1001/external-entity-actions/"
UPLOAD_ENDPOINT_TEMPLATE_WITH_ACTION_NAME = f"{EXTERNAL_ACTIONS_ENDPOINT}{{action_name}}/bundle"
UPLOAD_ENDPOINT_TEMPLATE_NO_ACTION_NAME = f"{EXTERNAL_ACTIONS_ENDPOINT}bundle"
FILE_PATH = "target/AppModulesAssistor.zip"


# Sign in to Octane and return the cookies needed for authentication
def sign_in():
    response = requests.post(
        AUTH_ENDPOINT,
        headers={'Content-Type': 'application/json'},
        json={"user": USER, "password": PASSWORD}
    )
    if response.status_code == 200:
        print("Sign-In Successful.")
        return response.cookies
    else:
        print(f"Sign-In Failed. Response Code: {response.status_code}")
        return None


# Retrieve the name of the action from the configuration file
def get_action_name():
    try:
        with open(ACTION_CONFIGURATION_FILE, 'r') as file:
            data = json.load(file)
            # Directly return the name from the dictionary
            return data.get('name')
    except FileNotFoundError:
        print(f"File not found: {ACTION_CONFIGURATION_FILE}")
        return None
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")
        return None


# Construct the URL for uploading the external entity action based on whether an action with the same name already exists
def construct_upload_endpoint(action_name=None):
    if action_name:
        return UPLOAD_ENDPOINT_TEMPLATE_WITH_ACTION_NAME.format(action_name=action_name)
    else:
        return UPLOAD_ENDPOINT_TEMPLATE_NO_ACTION_NAME


# Check if there are any existing external entity actions with the same name as the one being uploaded
def check_existing_actions(cookies, action_name):
    response = requests.get(EXTERNAL_ACTIONS_ENDPOINT, cookies=cookies)
    if response.status_code == 200:
        actions_data = response.json().get('data', [])
        for action in actions_data:
            if action.get('name') == action_name:
                return action.get('guid')
    return None


# Upload the bundle containing the external entity action to the server
def upload_bundle(cookies, guid, action_name):
    upload_endpoint_url = construct_upload_endpoint(action_name if guid else None)

    with open(FILE_PATH, 'rb') as file:
        response_text = ""
        try:
            url = upload_endpoint_url if guid is None else f"{upload_endpoint_url}?guid={guid}"
            method = requests.post if guid is None else requests.put

            response = method(
                url,
                cookies=cookies,
                headers={
                    'Accept': '*/*',
                    'Accept-Language': 'en-GB,en;q=0.9,en-US;q=0.8,he;q=0.7',
                    'Connection': 'keep-alive'
                },
                data=file
            )
            response_text = response.text

            if response.status_code in (200, 201):
                print("File Upload Successful. ")
            else:
                print(f"File Upload Failed. Response Code : {response.status_code}\n{response_text}")

        except Exception as e:
            print(f"An error occurred while uploading the file : {str(e)}\n{response_text}")


def main():
    cookies = sign_in()
    if not cookies:
        exit(1)

    action_name = get_action_name()
    if not action_name:
        exit(1)

    guid_to_use = check_existing_actions(cookies, action_name)

    if guid_to_use:
        print(f"External Entity Action already exists with GUID: {guid_to_use}. ")
    else:
        print("No existing External Entity Action found. Proceeding fresh upload.")

    upload_bundle(cookies, guid_to_use, action_name)


if __name__ == '__main__':
    main()
