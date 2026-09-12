*** Settings ***
Resource             resource.robot
Variables            ../variables/status_codes.py
Variables            ../input_payloads/put_endpoint_payloads.py
Variables            ../expected_payloads/get_user_by_email.py
Variables            ../expected_payloads/get_all_users.py

*** Variables ***
${non_existing_email}  non-existing-mail@test.com

*** Test Cases ***
UPDATE a user
    [Setup]  Setup
    Create PUT Request  ${BASE_URL}/users/${encoded_email}   ${UPDATE_USER_DATA}  ${UPDATE_USER_DATA}  ${SUCCESSFULL_STATUS_CODE}
    ${encoded_updated_email}=    Util.encode_email_value  ${UPDATE_USER_DATA}[email]
    ${get_response}=  Create GET Request  ${BASE_URL}/users/${encoded_updated_email}  ${SUCCESSFULL_STATUS_CODE}
    Dictionaries Should Be Equal  ${UPDATE_USER_DATA}  ${get_response}
    [Teardown]  Teardown

UPDATE a user with invalid age property
    [Setup]  Setup
    Create PUT Request  ${BASE_URL}/users/${encoded_email}   ${UPDATE_USER_DATA_WITH_AGE_AS_STRING}  ${error_response_message}  ${BAD_REQUEST_STATUS_CODE}
    [Teardown]  Teardown

UPDATE a user with invalid name and email properties
    [Setup]  Setup
    Create PUT Request  ${BASE_URL}/users/${encoded_email}   ${UPDATE_USER_DATA_WITH_NAME_AND_EMAIL_AS_INTEGERS}  ${error_response_message}  ${BAD_REQUEST_STATUS_CODE}
    [Teardown]  Teardown

UPDATE a user with duplicate email
    [Setup]  Setup
    Create PUT Request  ${BASE_URL}/users/${encoded_email}   ${UPDATE_USER_DATA_WITH_DUPLICATE_EMAIL}  ${error_response_message}  ${CONFLICT_STATUS_CODE}
    [Teardown]  Teardown

UPDATE a non existing user 
    ${encoded_non_existing_email}=    Util.encode_email_value  ${non_existing_email}
    Create PUT Request  ${BASE_URL}/users/${encoded_non_existing_email}   ${UPDATE_USER_DATA}  ${error_response_message}  ${NOT_FOUND_STATUS_CODE}

*** Keywords ***
Setup
    ${response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_DATA_SHARED_BY_TESTS}  ${CREATED_STATUS_CODE}
    ${encoded_email}=    Util.encode_email_value   ${response}[email]
    VAR  ${encoded_email}  ${encoded_email}  scope=SUITE

Teardown
    Create a DELETE Request  ${BASE_URL}/users/${encoded_email}  ${AUTH_TOKEN}  ${DELETED_SUCCESFULL_STATUS_CODE}