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
Resource   ../../Resources/CommonUtils/CommonUtils.robot

*** Keywords ***
Assigning verification code for the new recipient user
    [Arguments]  ${Admin_token}     ${recipient_phone_number}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary    phone=${recipient_phone_number}  type=user   verificationCode=${Assign_verification_code}
    ${response}=    POST  ${base_URL}${Special_phones_endpoint}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}

Updating the recipient signature and profile
    [Arguments]  ${recipient_token}     ${recipient_name}
    ${x_values}=    Create List    1    2
    ${y_values}=    Create List    1    1
    ${signature_point}=    Create Dictionary    x=${x_values}    y=${y_values}
    ${signature_points}=    Create List    ${signature_point}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${recipient_token}
    ${Recipient_email}=     Generate Random Email Recipient
    ${data}=    Create Dictionary    name=${recipient_name}     signature=${Signature}      signaturePoints=${Signature_points}    email=${Recipient_email}       imageUrl=${None}
    ${response}=    PUT  ${base_URL}${Recipient_profile_end_point}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True    'profile' in ${response_json}    profile is missing in the response
    Should Be True    'id' in ${response_json['profile']}    id is missing in the response
    Should Be True    'multipleCounters' in ${response_json['profile']}    multipleCounters is missing in the response
    Should Be True    'name' in ${response_json['profile']}    name is missing in the response
    Should Be True    'dni' in ${response_json['profile']}    dni is missing in the response
    Should Be True    'signature' in ${response_json['profile']}    signature is missing in the response
    Should Be True    'signaturePointsProvided' in ${response_json['profile']}    signaturePointsProvided is missing in the response
    Should Be True    'signaturePoints' in ${response_json['profile']}    signaturePoints is missing in the response
    Should Be True    'email' in ${response_json['profile']}    email is missing in the response
    Should Be True    'phone' in ${response_json['profile']}    phone is missing in the response
    Should Be True    'kanguroPoints' in ${response_json}    kanguroPoints is missing in the response
    ${Recipient_email}=     Set Variable   ${response_json['profile']['email']}
    #Log recipient email
    Log    Recipient Email: ${Recipient_email}
    RETURN     ${Recipient_email}

Get the group id
    [Arguments]     ${recipient_token}      ${Counter_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${recipient_token}
    ${response}=        PATCH   ${base_URL}${group_id_endpoint1}${Counter_id}${group_id_endpoint2}   headers=${headers}
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    Log     Response Body: ${response.content}
    #Assertions
    Should Be True    'groupId' in ${response_json}    Group ID is missing in the response
    Should Be True    'parcelsCount' in ${response_json}    parcel count is missing in the response
    ${group_id}=    Set Variable    ${response_json['groupId']}
    # Log the group ID
    Log    group ID: ${group_id}
    RETURN    ${group_id}

Get parcel EAN code by group
    [Arguments]     ${recipient_token}      ${group_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${recipient_token}
    ${response}=        GET   ${base_URL}${get_by_group_recipient_endpoint}${group_id}   headers=${headers}
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    Log     Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json['items'][0]}    Id is missing in the response
    Should Be True  'counterId' in ${response_json['items'][0]}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json['items'][0]}    originalAddress is missing in the response
    #Assertions
    Should Be Equal As Strings  ${response_json['items'][0]['status']}  dropped-off
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json['items'][0]}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    #Assertions
    Should Be Equal As Strings   ${response_json['items'][0]['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['items'][0]['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['items'][0]['commercialInvoiceRequired']}    False
    #Assertions
    Should Be True  'EAN' in ${response_json['items'][0]}    EAN section is missing in the response
    Should Be True  'recipient' in ${response_json['items'][0]}    Recipient section is missing in the response
    Should Be True  'sender' in ${response_json['items'][0]}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json['items'][0]}    monies is missing in the response
    Should Be True  'courier' in ${response_json['items'][0]}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json['items'][0]}    KanguroPoint section is missing in the response
    Should Be True  'deliveryDriver' in ${response_json['items'][0]}    Delivery driver section is missing in the response
    ${EAN}=    Set Variable    ${response_json['items'][0]['EAN']}
    Log    EAN: ${EAN}
    RETURN    ${EAN}