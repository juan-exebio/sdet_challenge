*** Settings ***
Resource             resource.robot
Variables            ../variables/status_codes.py
Variables            ../expected_payloads/get_user_by_email.py
Variables            ../expected_payloads/get_all_users.py

*** Variables ***
${non_existing_email}  non-existing-mail@test.com

*** Test Cases ***
GET ALL users when there is no created users
    ${response}=  Create GET Request  ${BASE_URL}/users  ${SUCCESSFULL_STATUS_CODE}
    Lists Should Be Equal  []  ${response}

GET All users when there are created users
    [Setup]  Setup
    ${response}=  Create GET Request  ${BASE_URL}/users  ${SUCCESSFULL_STATUS_CODE}
    Lists Should Be Equal  ${EXPECTED_ALL_USERS}  ${response}
    [Teardown]  Teardown

GET User that exists by Email
    [Setup]  Setup
    ${response}=  Create GET Request  ${BASE_URL}/users/${emails_to_be_deleted}[0]  ${SUCCESSFULL_STATUS_CODE}
    Dictionaries Should Be Equal  ${EXPECTED_USER_BY_EMAIL}  ${response}
    [Teardown]  Teardown

GET User that doesn't exist by Email
    ${encoded_email}=   Util.encode_email_value   ${non_existing_email}
    ${response}=  Create GET Request  ${BASE_URL}/users/${encoded_email}  ${NOT_FOUND_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${response}

GET User that exists by Email with unencoded value
    [Setup]  Setup
    ${response}=  Create GET Request  ${BASE_URL}/users/${CREATE_USERS_FOR_GET_ALL_USERS}[0][email]  ${NOT_FOUND_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${response}
    [Teardown]  Teardown

GET User that doesn't exist by Email with unencoded value
    ${response}=  Create GET Request  ${BASE_URL}/users/${non_existing_email}  ${NOT_FOUND_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${response}

*** Keywords ***
Setup
    @{emails_to_be_deleted}=  Create List
    FOR  ${ITEM}  IN  @{CREATE_USERS_FOR_GET_ALL_USERS}
        ${response}=  Create a POST Request  ${BASE_URL}/users  ${ITEM}  ${CREATED_STATUS_CODE}
        ${encoded_email}=    Util.encode_email_value   ${response}[email]
        Append To List  ${emails_to_be_deleted}  ${encoded_email}
    END
    VAR  ${emails_to_be_deleted}  ${emails_to_be_deleted}  scope=SUITE

Teardown
    FOR  ${email}  IN  @{emails_to_be_deleted}
        Create a DELETE Request  ${BASE_URL}/users/${email}  ${AUTH_TOKEN}  ${DELETED_SUCCESFULL_STATUS_CODE}
    END