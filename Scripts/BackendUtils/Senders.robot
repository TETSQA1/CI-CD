*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json
Resource   BackendMainconfig.robot
Resource   ../../Resources/CommonUtils/CommonUtils.robot

*** Keywords ***
Adding a new sender
    [Arguments]     ${Admin_token}
    ${Sender_name}=  Generate Random sender Name
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
    ${data}=    Create Dictionary   name=${Sender_name}
    ${response}=    POST    ${base_URL}${Senders_base_endpoint}   headers=${headers}   json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)    json
    ${Sender_id}=  Set Variable  ${response_json['id']}
    ${Sender_name}=     Set Variable    ${response_json['name']}
    #Assertions
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'name' in ${response_json}  name is missing in the response
    RETURN  ${Sender_id}    ${Sender_name}

Updating the sender
    [Arguments]     ${Admin_token}  ${Sender_id}
    ${Sender_name}=  Generate Random sender Name
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
    ${data}=    Create Dictionary   name=${Sender_name}
    ${response}=    PUT    ${base_URL}${Senders_base_endpoint}/${Sender_id}   headers=${headers}   json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)    json
    ${Updated_Sender_id}=  Set Variable  ${response_json['id']}
    ${Updated_Sender_name}=     Set Variable    ${response_json['name']}
    #Assertions
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'name' in ${response_json}  name is missing in the response
    RETURN  ${Updated_Sender_id}    ${Updated_Sender_name}

Deleting the sender
    [Arguments]     ${Admin_token}  ${Sender_id}
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
    ${response}=    DELETE    ${base_URL}${Senders_base_endpoint}/${Sender_id}   headers=${headers}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204