*** Settings ***
Resource             resource.robot
Variables            ../variables/status_codes.py

*** Variables ***
${non_existing_email}  non-existing-mail@test.com
${invalid_token}       abc

*** Test Cases ***
Delete a user
    Create a User
    Create a DELETE Request  ${BASE_URL}/users/${encoded_email}  ${AUTH_TOKEN}  ${DELETED_SUCCESFULL_STATUS_CODE}

Delete a user with invalid authorization token
    Create a User
    ${response}  Create a DELETE Request  ${BASE_URL}/users/${encoded_email}  ${invalid_token}  ${UNAUTHORIZED_STATUS_CODE}
    Dictionaries Should Be Equal  ${response}  ${unauthorized_response_message}
    [Teardown]  Create a DELETE Request  ${BASE_URL}/users/${encoded_email}  ${AUTH_TOKEN}  ${DELETED_SUCCESFULL_STATUS_CODE}

Delete a user without authentication header
    Create a User
    ${response}=  DELETE  url=${BASE_URL}/users/${encoded_email}  expected_status=any
    Should Be Equal As Integers  ${UNAUTHORIZED_STATUS_CODE}  ${response.status_code}
    [Teardown]  Create a DELETE Request  ${BASE_URL}/users/${encoded_email}  ${AUTH_TOKEN}  ${DELETED_SUCCESFULL_STATUS_CODE}

Delete a non existing user
    ${json_response}=  Create a DELETE Request  ${BASE_URL}/users/${non_existing_email}  ${AUTH_TOKEN}  ${NOT_FOUND_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}   ${json_response}

*** Keywords ***
Create a User
    ${response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_DATA_SHARED_BY_TESTS}  ${CREATED_STATUS_CODE}
    ${encoded_email}=    Util.encode_email_value   ${response}[email]
    VAR  ${encoded_email}  ${encoded_email}  scope=TEST

