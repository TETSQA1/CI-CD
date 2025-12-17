*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json
Library    String
Library    DateTime
Library    OperatingSystem
Library    BuiltIn
Library    Process
Resource   BackendMainconfig.robot

*** Keywords ***
Login As Driver
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary   phone=${Delivery_driver_Phone_number}
    ${response}=    post     ${base_URL}${driver_login_first_step}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${requestId}=    Get From Dictionary    ${response_dict}  requestId  default=None
    Log    requestId: ${requestId}
    Should Not Be Empty    ${requestId}
    RETURN     ${requestId}

Login As Driver Second Step
    [Arguments]    ${requestId}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    requestId=${requestId}    verificationCode=${Assign_verification_code}
    ${response}=    Post   ${base_URL}${driver_login_second_step}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${accessToken}=    Get From Dictionary    ${response_dict}    accessToken    default=None
    ${driver_token}=    Set Variable    Bearer ${accessToken}
    Log    accessToken: ${accessToken}
    Log    driver_token: ${driver_token}
    Should Not Be Empty    ${accessToken}
    RETURN    ${driver_token}

Login As Counter first step
    [Arguments]  ${Counter_phone_number}
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    phone=${Counter_phone_number}
    ${response}=    POST       ${base_URL}${counter_login_first_step}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${requestId}=    Get From Dictionary    ${response_dict}  requestId  default=None
    Log    requestId: ${requestId}
    Should Not Be Empty    ${requestId}
    RETURN     ${requestId}

Login As Counter Second Step
    [Arguments]    ${requestId}
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    requestId=${requestId}    verificationCode=${Assign_verification_code}
    ${response}=    post     ${base_URL}${counter_login_second_step}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${accessToken}=    Get From Dictionary    ${response_dict}  accessToken  default=None
    ${counter_token}=    Set Variable    Bearer ${accessToken}
    Log    accessToken: ${accessToken}
    Log    counter_token: ${counter_token}
    Should Not Be Empty    ${accessToken}
    RETURN     ${counter_token}

Login as Recipient
    [Arguments]     ${kanguroPointId}   ${Recipient_ID}
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    recipientId=${Recipient_ID}        kanguroPointId=${kanguroPointId}
    ${response}=    post     ${base_URL}${Recipient_login_endpoint}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${accessToken}=    Get From Dictionary    ${response_dict}  accessToken  default=None
    ${recipient_token}=    Set Variable    Bearer ${accessToken}
    Log    accessToken: ${accessToken}
    Log    recipient_token: ${recipient_token}
    Should Not Be Empty    ${accessToken}
    RETURN     ${recipient_token}

Login as admin backend
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    email=${Admin_email}       password=${Admin_password}
    ${response}=    POST  ${base_URL}${Admin_login_endpoint}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${accessToken}=    Get From Dictionary    ${response_dict}    accessToken    default=None
    ${Admin_token}=    Set Variable    Bearer ${accessToken}
    Log    accessToken: ${accessToken}
    Log    driver_token: ${Admin_token}
    Should Not Be Empty    ${accessToken}
    RETURN    ${Admin_token}

Login as Call-bot
    [Arguments]    ${apiKey}    ${apiSecret}
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    apiKey=${apiKey}        apiSecret=${apiSecret}
    ${response}=    POST  ${base_URL}${Call_bot_login_endpoint}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${accessToken}=    Get From Dictionary    ${response_dict}    accessToken    default=None
    ${call-bot_token}=    Set Variable    Bearer ${accessToken}
    Log    accessToken: ${accessToken}
    Should Not Be Empty    ${accessToken}
    RETURN    ${call-bot_token}

Login as Recipient first step
    [Arguments]     ${Recipient_phone_number}
    ${headers}=   Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    phone=${Recipient_phone_number}
    ${response}=    post     ${base_URL}${Recipient_login_first_step_endpoint}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${requestId}=    Get From Dictionary    ${response_dict}  requestId  default=None
    Log    requestId: ${requestId}
    Should Not Be Empty    ${requestId}
    RETURN     ${requestId}

Login As Recipient second step
    [Arguments]    ${requestId_recipient}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    requestId=${requestId_recipient}    verificationCode=${Assign_verification_code}
    ${response}=    Post   ${base_URL}${Recipient_login_Second_step_endpoint}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_dict}=    Evaluate    json.loads($response.content)    json
    ${accessToken}=    Get From Dictionary    ${response_dict}    accessToken    default=None
    ${Recipient_token}=    Set Variable    Bearer ${accessToken}
    Log    accessToken: ${accessToken}
    Log    Recipient_token: ${Recipient_token}
    Should Not Be Empty    ${accessToken}
    RETURN    ${Recipient_token}