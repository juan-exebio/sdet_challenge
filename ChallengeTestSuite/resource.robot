*** Settings ***
Library              Collections
Library              RequestsLibrary
Library              ../utils/util.py  WITH NAME  Util
Variables            ../variables/env_variables.py
Variables            ../input_payloads/post_endpoint_payloads.py
Variables            ../expected_payloads/error_messages.py

*** Keywords ***
Create a POST Request
    [Arguments]  ${url}  ${json_body}  ${expected_status_code}
    ${response}=  POST  url=${url}  json=${json_body}  expected_status=any
    Should Be Equal As Integers  ${expected_status_code}  ${response.status_code}
    RETURN  ${response.json()}

Create a DELETE Request
    [Arguments]  ${url}  ${token}  ${expected_status_code}
    &{headers}=    Create Dictionary    Authentication=${token}    Content-Type=application/json
    ${response}=  DELETE  url=${url}  headers=${headers}  expected_status=any
    Should Be Equal As Integers  ${expected_status_code}  ${response.status_code}
    IF  ${response.status_code} != 204
        RETURN  ${response.json()}
    END

Create GET Request
    [Arguments]  ${url}  ${expected_status_code}
    ${response}=  GET  ${url}  expected_status=any
    Should Be Equal As Integers  ${expected_status_code}  ${response.status_code}
    RETURN  ${response.json()}

Create PUT Request
    [Arguments]  ${url}  ${json_body}  ${expected_response}  ${expected_status_code}
    ${response}=  PUT   ${url}  json=${json_body}  expected_status=any
    Should Be Equal As Integers  ${expected_status_code}  ${response.status_code}
    Dictionaries Should Be Equal  ${expected_response}  ${response.json()}