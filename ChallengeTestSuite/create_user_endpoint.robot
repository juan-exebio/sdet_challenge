*** Settings ***
Resource             resource.robot
Variables            ../variables/status_codes.py
Variables            ../expected_payloads/create_user.py
Suite Teardown       Teardown

*** Variables ***
@{emails_to_be_deleted}  jane@example.com  123  test

*** Test Cases ***
Create a new User
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_DATA}  ${CREATED_STATUS_CODE}
    Dictionaries Should Be Equal  ${EXPECTED_JANE_USER_DATA}  ${json_response}

Create a new User with empty json body
    ${EMPTY_JSON_BOY}=  Create Dictionary
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${EMPTY_JSON_BOY}  ${BAD_REQUEST_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${json_response}

Create a new User with Name as empty value
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_WITH_EMPTY_NAME}  ${BAD_REQUEST_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${json_response}

Create a new User with Name, Email and Age as empty values
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_WITH_EMPTY_PROPERTIES}  ${BAD_REQUEST_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${json_response}

Create a new User with Invalid Email value
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_WITH_INVALID_EMAIL}  ${BAD_REQUEST_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${json_response}

Create a new User with Age as String
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_DATA_WITH_AGE_AS_STRING}  ${BAD_REQUEST_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${json_response}

Create a new User with Name and Email as Integers
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_DATA_WITH_NAME_AND_EMAIL_AS_INTEGERS}  ${BAD_REQUEST_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${json_response}

Create a new User with Duplicate Email
    ${json_response}=  Create a POST Request  ${BASE_URL}/users  ${CREATE_USER_DATA_WITH_DUPLICATE_EMAIL}  ${CONFLICT_STATUS_CODE}
    Dictionaries Should Be Equal  ${error_response_message}  ${json_response}

*** Keywords ***
Teardown
    FOR  ${email}  IN  @{emails_to_be_deleted}
        ${encoded_email}=    Util.encode_email_value   ${email}
        Create a DELETE Request  ${BASE_URL}/users/${encoded_email}  ${AUTH_TOKEN}  ${DELETED_SUCCESFULL_STATUS_CODE}
    END

