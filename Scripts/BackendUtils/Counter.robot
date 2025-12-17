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
Resource    Admin.robot

*** Variables ***
${JSON_FILE_PATH}         D:/Kanguro_test/data_file/schedule.json

*** Keywords ***
Get Parcel By Id
    [Arguments]       ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}    
    ${response}=   GET   ${base_URL}${get_parcel_by_id}/${parcel_id}    headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertion
    Should Be True    'id' in ${response_json}    Parcel ID is missing in the response
    Should Be True    'counterId' in ${response_json}    Counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}    Original Address is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}    EAN is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing from the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing from the response
    Should Be True    'pinRequired' in ${response_json}    pinRequired is missing in the response
    Should Be True    'monies' in ${response_json}    monies is missing in the response
    Should Be True    'courier' in ${response_json}    Courier information is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}    Delivery Driver information is missing in the response
    Should Be True    'kanguroPoint' in ${response_json}      KanguroPoint information is missing in the response
    Should Be True    'recipient' in ${response_json}     recipient information is missing in the response
    Should Be True    'courier' in ${response_json}     courier information is missing in the response
    # Asserting specific values
    Should Be Equal    ${response_json['status']}    created    Parcel status is not in 'created'
    Should Be Equal    ${response_json['adultSignatureRequired']}    ${True}    the adultsignaturerequired was not true
    Should Be Equal    ${response_json['recipientOnlyRequired']}    ${True}    the recipientOnlyRequired was not true
    Should Be Equal    ${response_json['commercialInvoiceRequired']}    ${False}    the commercialInvoiceRequired was not true

Validating the parcel and changing the parcel status into drop-off
    [Arguments]    ${counter_token}    ${parcel_id}
    ${data}=    Create Dictionary    valid=True       action=collect-from-delivery-driver    monies=[]    pin=123456    adultSignature=True    recipientOnly=True    commercialInvoice=True    title=not an incidence    description=testing valid drop-off    attachments=[]
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}    
    ${response}=    patch    ${base_URL}${Validate_parcel_endpoint}${parcel_id}    headers=${headers}    json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Get multiple parcels ids
    [Arguments]       ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}  # Store both parcel IDs
    @{responses}=    Create List    # Initialize an empty list to store responses
    FOR    ${index}    IN RANGE    2  # Getting two parcels by id
    ${current_parcel_id}=    Get From List    ${parcel_ids}    ${index}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${response}=    Get   ${base_URL}${get_parcel_by_id}/${current_parcel_id}    headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body for Parcel ID ${current_parcel_id}: ${response.content}
    # Asserting required fields in the response
    Should Be True    'id' in ${response_json}    Parcel ID is missing in the response
    Should Be True    'counterId' in ${response_json}    Counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}    Original Address is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}    EAN is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing from the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing from the response
    Should Be True    'pinRequired' in ${response_json}    pinRequired is missing in the response
    Should Be True    'monies' in ${response_json}    monies is missing in the response
    Should Be True    'courier' in ${response_json}    Courier information is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}    Delivery Driver information is missing in the response
    Should Be True    'kanguroPoint' in ${response_json}      KanguroPoint information is missing in the response
    Should Be True    'recipient' in ${response_json}     recipient information is missing in the response
    Should Be True    'courier' in ${response_json}     courier information is missing in the response
    # Asserting specific values
    Should Be Equal    ${response_json['status']}   created     Parcel status is not in 'created'
    Should Be Equal    ${response_json['adultSignatureRequired']}    ${True}    the adultsignaturerequired was not true
    Should Be Equal    ${response_json['recipientOnlyRequired']}    ${True}    the recipientOnlyRequired was not true
    Should Be Equal    ${response_json['commercialInvoiceRequired']}    ${False}    the commercialInvoiceRequired was not true
    Append To List    ${responses}    ${response_json}  # Store the response for later use
    END
    # Optionally return the responses if needed
    RETURN    ${responses}

Validating the multiple parcel and changing the parcels status into drop-off
    [Arguments]       ${counter_token}  ${parcel_id_1}  ${parcel_id_2}  ${Delivery_driver_Phone_number}  ${recipient_phone_number}  ${monies_1}  ${monies_2}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}
    ${monies_list}=   Create list     ${monies_1}   ${monies_2}
    FOR    ${index}    IN RANGE    2
    ${current_parcel_id}=    Get From List    ${parcel_ids}    ${index}
    ${current_monies}=      Get From List    ${monies_list}    ${index}
    ${data}=    Create Dictionary    valid=True    action=collect-from-delivery-driver    monies=${current_monies}    pin=123456    adultSignature=True    recipientOnly=True    commercialInvoice=True    title=not an incidence    description=testing valid drop-off    attachments=[]
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${response}=    Patch    ${base_URL}${Validate_parcel_endpoint}${current_parcel_id}    headers=${headers}    json=${data}
    Log    Response Body for Parcel ID ${current_parcel_id}: ${response.content}
    # Assertions
    Should Be Equal As Strings    ${response.status_code}    204
    END

Validating the parcel and changing the parcel status into collected
    [Arguments]    ${counter_token}   ${parcel_id}   ${monies}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${data} =   Create Dictionary   action=${action_collect}    valid=${valid}     pin=${pin}  attachments=${attachments}   monies=${monies}    adultSignature=${True}   recipientOnly=${True}    commercialInvoice=False
    ${response}=    PATCH    ${base_URL}${Validate_parcel_endpoint}${parcel_id}    headers=${headers}   json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Validating multiple parcels and changing the parcels status into collected
    [Arguments]    ${counter_token}   ${parcel_id_1}  ${parcel_id_2}   ${monies_1}   ${monies_2}
    @{parcel_ids}=  Create List     ${parcel_id_1}     ${parcel_id_2}
    @{monies_list}=    Create List  ${monies_1}   ${monies_2}
    FOR    ${index}    IN RANGE    0    2
    ${parcel_id}=   Get From List    ${parcel_ids}    ${index}
    ${monies}=      Get From List    ${monies_list}    ${index}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${data} =   Create Dictionary   action=${action_collect}    valid=${valid}     pin=${pin}  attachments=${attachments}   monies=${monies}    adultSignature=${True}    recipientOnly=${True}    commercialInvoice=False
    ${response}=    PATCH    ${base_URL}${Validate_parcel_endpoint}${parcel_id}  headers=${headers}   json=${data}
    Log    Response Body for Parcel ID ${parcel_id}: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204
    END

Getting parcels monies details
    [Arguments]     ${counter_token}  ${parcel_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${counter_token}
    ${response}=        GET     ${base_URL}${Get_parcel_monies_endpoint}${parcel_id}   headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'status' in ${response_json}    status is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True  'pinRequired' in ${response_json}    pinRequired is missing in the response
    Should Be True  'EAN' in ${response_json}    EAN section is missing in the response
    Should Be True  'recipient' in ${response_json}    Recipient section is missing in the response
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    Delivery driver section is missing in the response
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    #Saving the parcel id
    ${monies}=    Set Variable    ${response_json['monies']}
    Log    monies: ${monies}
    # RETURN the parcel ID if needed
    RETURN    ${monies}

Getting multiple parcels monies details
    [Arguments]     ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    @{monies_list}=    Create List
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}  # Store both parcel IDs
    FOR    ${index}    IN RANGE    2
    ${current_parcel_id}=   Get From List    ${parcel_ids}    ${index}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${counter_token}
    ${response}=        GET     ${base_URL}${Get_parcel_monies_endpoint}${current_parcel_id}   headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    ${monies}=    Set Variable    ${response_json['monies']}
    Log    Monies: ${monies}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'status' in ${response_json}    status is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True  'pinRequired' in ${response_json}    pinRequired is missing in the response
    Should Be True  'EAN' in ${response_json}    EAN section is missing in the response
    Should Be True  'recipient' in ${response_json}    Recipient section is missing in the response
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    Delivery driver section is missing in the response
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    Append To List    ${monies_list}    ${monies}
    END
    # RETURN the monies
    ${monies_1}=    Get From List    ${monies_list}    0
    ${monies_2}=    Get From List    ${monies_list}    1
    RETURN    ${monies_1}    ${monies_2}

Change the status of the parcel into collecting
    [Arguments]     ${Counter_token}  ${group_id}   ${parcel_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=    Create Dictionary   groupId=${group_id}
    ${response}=        PATCH     ${base_URL}${Change_to_collecting_endpoint1}${parcel_id}${Change_to_collecting_endpoint2}      headers=${headers}      json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertion
    Should Be True    'id' in ${response_json}    Parcel ID is missing in the response
    Should Be True    'counterId' in ${response_json}    Counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}    Original Address is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}    EAN is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing from the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing from the response
    Should Be True    'pinRequired' in ${response_json}    pinRequired is missing in the response
    Should Be True    'monies' in ${response_json}    monies is missing in the response
    Should Be True    'courier' in ${response_json}    Courier information is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}    Delivery Driver information is missing in the response
    Should Be True    'kanguroPoint' in ${response_json}      KanguroPoint information is missing in the response
    Should Be True    'recipient' in ${response_json}     recipient information is missing in the response
    Should Be True    'courier' in ${response_json}     courier information is missing in the response
    # Asserting specific values
    Should Be Equal    ${response_json['status']}    collecting    Parcel status is not in 'created'
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False

Change the status of the multiple parcels into collecting
    [Arguments]     ${Counter_token}  ${group_id}  ${parcel_id_1}    ${parcel_id_2}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=    Create Dictionary   groupId=${group_id}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}
    FOR    ${index}    IN RANGE    2
    ${current_parcel_id}=   Get From List    ${parcel_ids}    ${index}
    ${response}=        PATCH     ${base_URL}${Change_to_collecting_endpoint1}${current_parcel_id}${Change_to_collecting_endpoint2}      headers=${headers}      json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertion
    Should Be True    'id' in ${response_json}    Parcel ID is missing in the response
    Should Be True    'counterId' in ${response_json}    Counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}    Original Address is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}    EAN is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing from the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing from the response
    Should Be True    'pinRequired' in ${response_json}    pinRequired is missing in the response
    Should Be True    'monies' in ${response_json}    monies is missing in the response
    Should Be True    'courier' in ${response_json}    Courier information is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}    Delivery Driver information is missing in the response
    Should Be True    'kanguroPoint' in ${response_json}      KanguroPoint information is missing in the response
    Should Be True    'recipient' in ${response_json}     recipient information is missing in the response
    Should Be True    'courier' in ${response_json}     courier information is missing in the response
    # Asserting specific values
    Should Be Equal    ${response_json['status']}    collecting    Parcel status is not in 'created'
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    END

Validating the parcel and changing the parcel status into drop-off recipient
    [Arguments]    ${counter_token}   ${parcel_id}     ${monies}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${data} =   Create Dictionary   action=${action_return}    valid=${valid}     pin=${pin}  attachments=${attachments}   monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${response}=    PATCH    ${base_URL}${Validate_parcel_endpoint}${parcel_id}    headers=${headers}   json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Validating the return parcel and changing the status to returned
    [Arguments]    ${counter_token}   ${parcel_id}   ${monies}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${data} =   Create Dictionary   action=${action_return_driver}    valid=${valid}     pin=${pin}  attachments=${attachments}   monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${response}=    PATCH    ${base_URL}${Validate_parcel_endpoint}${parcel_id}    headers=${headers}   json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Validating the group of return parcel and changing the status to returned
    [Arguments]    ${counter_token}   ${parcel_id_1}  ${parcel_id_2}   ${monies_1}   ${monies_2}
    @{parcel_ids}=  Create List     ${parcel_id_1}     ${parcel_id_2}
    @{monies_list}=    Create List  ${monies_1}   ${monies_2}
    FOR    ${index}    IN RANGE    0    2
    ${parcel_id}=   Get From List    ${parcel_ids}    ${index}
    ${monies}=      Get From List    ${monies_list}    ${index}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${data} =   Create Dictionary   action=${action_return_driver}    valid=${valid}     pin=${pin}  attachments=${attachments}   monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${response}=    PATCH    ${base_URL}${Validate_parcel_endpoint}${parcel_id}  headers=${headers}   json=${data}
    Log    Response Body for Parcel ID ${parcel_id}: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204
    END

Getting the parcel id using group
    [Arguments]     ${Counter_token}    ${group_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${response}=        GET     ${base_URL}${get_by_group_counter_endpoint}${group_id}      headers=${headers}
    Log     Response Body: ${response.content}
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    #Assertions
    Should Be True    'id' in ${response_json['items'][0]}     Id is missing in the response
    Should Be True    'counterId' in ${response_json['items'][0]}     counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json['items'][0]}   original address is missing in the response
    Should Be True    'status' in ${response_json['items'][0]}   status is missing in the response
    Should Be True    'createdAt' in ${response_json['items'][0]}   createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json['items'][0]}   updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json['items'][0]}   EAN is missing in the response
    Should Be True    'expireTimestamp' in ${response_json['items'][0]}     Expired time stamp is missing in the response
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json['items'][0]}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json['items'][0]}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json['items'][0]}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json['items'][0]}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    #Assertions
    Should Be True    'deliveryDriver' in ${response_json['items'][0]}   Delivery Driver information is missing in the response
    Should Be True    'courier' in ${response_json['items'][0]}   Courier information is missing in the response
    Should Be True    'kanguroPoint' in ${response_json['items'][0]}   Kanguro point information is missing in the response
    Should Be True    'recipient' in ${response_json['items'][0]}   Recipient information is missing in the response
    ${parcel_id}=    Set Variable    ${response_json['items'][0]['id']}
    Log    Parcel ID: ${parcel_id}
    RETURN    ${parcel_id}

Get parcel id by EAN
    [Arguments]       ${counter_token}    ${EAN}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${response}=    get   ${base_URL}${get_by_EAN}${EAN}    headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True    'id' in ${response_json}    Id is missing in the response
    Should Be True    'counterId' in ${response_json}    counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}     original address is missing in the response
    Should Be True    'status' in ${response_json}  status is missing in the response
    Should Be True    'createdAt' in ${response_json}  createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}  updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}  EAN is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['expireTimestamp']}   ${null}
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${EAN}=    Set Variable    ${response_json['EAN']}
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
    # RETURN the parcel ID if needed
    RETURN    ${parcel_id}

Get parcel id by EAN2
    [Arguments]       ${counter_token}    ${EAN2}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${response}=    GET   ${base_URL}${get_by_EAN}${EAN2}    headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True    'id' in ${response_json}    Id is missing in the response
    Should Be True    'counterId' in ${response_json}    counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}     original address is missing in the response
    Should Be True    'status' in ${response_json}  status is missing in the response
    Should Be True    'createdAt' in ${response_json}  createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}  updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}  EAN is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['expireTimestamp']}   ${null}
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    ${parcel_id}=    Set Variable    ${response_json['id']}
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
    # RETURN the parcel ID if needed
    RETURN    ${parcel_id}

Get multiple parcel id by EAN
    [Arguments]       ${counter_token}    ${EAN_1}     ${EAN_2}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    @{EAN_list}=  Create List     ${EAN_1}     ${EAN_2}
    @{parcels_list}=    Create List
    FOR    ${index}    IN RANGE    2
    ${current_EAN}=      Get From List    ${EAN_list}    ${index}
    ${response}=    get   ${base_URL}${get_by_EAN}${current_EAN}    headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    ${parcels}=    Set Variable    ${response_json['id']}
    Log    parcels: ${parcels}
    #Assertions
    Should Be True    'id' in ${response_json}    Id is missing in the response
    Should Be True    'counterId' in ${response_json}    counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}     original address is missing in the response
    Should Be True    'status' in ${response_json}  status is missing in the response
    Should Be True    'createdAt' in ${response_json}  createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}  updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}  EAN is missing in the response
    Should Be True    'expireTimestamp' in ${response_json}   expireTimestamp is missing in the response
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    Append To List    ${parcels_list}   ${parcels}
    END
    # Save the ID of the created parcel
    ${parcel_id_1}=    Get From List    ${parcels_list}    0
    ${parcel_id_2}=    Get From List    ${parcels_list}    1
    # Log
    Log    Created Parcel ID 1: ${parcel_id_1}
    Log    Created Parcel ID 2: ${parcel_id_2}
    # RETURN the parcel ID if needed
    RETURN    ${parcel_id_1}    ${parcel_id_2}

Create the return group for the parcel
    [Arguments]     ${Counter_token}    ${courier_id}
    ${data}=    Create Dictionary      courierId=${courier_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${response}=        POST     ${base_URL}${Create_return_group_endpoint}     headers=${headers}      json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True  'groupId' in ${response_json}    GroupId is missing in the response
    Should Be True  'parcelsCount' in ${response_json}    Parcels count is missing in the response
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    ${group_id}=    Set Variable    ${response_json['groupId']}
    Log    group ID: ${group_id}
    RETURN    ${group_id}

Getting the parcel id using the group id
    [Arguments]     ${Counter_token}    ${group_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${response}=        GET     ${base_URL}${get_by_group_counter_endpoint}${group_id}      headers=${headers}
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    Log     Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json['items'][0]}    Id is missing in the response
    Should Be True  'counterId' in ${response_json['items'][0]}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json['items'][0]}    originalAddress is missing in the response
    #Assertions
    Should Be Equal As Strings  ${response_json['items'][0]['status']}  returning
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json['items'][0]}     pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json['items'][0]}   adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json['items'][0]}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json['items'][0]}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    #Assertions
    Should Be True  'EAN' in ${response_json['items'][0]}    EAN section is missing in the response
    Should Be True  'recipient' in ${response_json['items'][0]}    Recipient section is missing in the response
    Should Be True  'sender' in ${response_json['items'][0]}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json['items'][0]}    monies is missing in the response
    Should Be True  'courier' in ${response_json['items'][0]}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json['items'][0]}    KanguroPoint section is missing in the response
    Should Be True  'deliveryDriver' in ${response_json['items'][0]}    Delivery driver section is missing in the response
    ${parcel_id}=    Set Variable    ${response_json['items'][0]['id']}
    Log    Parcel ID: ${parcel_id}
    RETURN    ${parcel_id}

Get the multiple parcel id using group id
    [Arguments]     ${Counter_token}    ${group_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${response}=        GET     ${base_URL}${get_by_group_counter_endpoint}${group_id}      headers=${headers}
    Log     Response Body: ${response.content}
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    #Assertions
    Should Be True    'id' in ${response_json['items'][0]}     Id is missing in the response
    Should Be True    'counterId' in ${response_json['items'][0]}     counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json['items'][0]}   original address is missing in the response
    Should Be True    'status' in ${response_json['items'][0]}   status is missing in the response
    Should Be True    'EAN' in ${response_json['items'][0]}   EAN is missing in the
    Should Be True    'createdAt' in ${response_json['items'][0]}   createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json['items'][0]}   updatedAt is missing in the response
    Should Be True    'expireTimestamp' in ${response_json['items'][0]}     Expired time stamp is missing in the response
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json['items'][0]}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json['items'][0]}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json['items'][0]}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    #Assertions
    Should Be True    'deliveryDriver' in ${response_json['items'][0]}   Delivery Driver information is missing in the response
    Should Be True    'courier' in ${response_json['items'][0]}   Courier information is missing in the response
    Should Be True    'kanguroPoint' in ${response_json['items'][0]}   Kanguro point information is missing in the response
    Should Be True    'recipient' in ${response_json['items'][0]}   Recipient information is missing in the response
    ${parcel_id_1}=    Set Variable    ${response_json['items'][0]['id']}
    ${parcel_id_2}=     Set Variable    ${response_json['items'][1]['id']}
    Log    Parcel ID 1: ${parcel_id_1}
    Log  Parcel Id 2: ${parcel_id_2}
    RETURN    ${parcel_id_1}    ${parcel_id_2}

Changing the expired parcel status to expired-returning
    [Arguments]     ${Counter_token}  ${group_id}  ${parcel_id}
    ${data}=    Create Dictionary      groupId=${groupId}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${response}=        PATCH     ${base_URL}${Returning_status_change_endpoint1}${parcel_id}${Returning_status_change_endpoint2}   headers=${headers}   json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True  'expireTimestamp' in ${response_json}    expireTimestamp is missing in the response
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'recipient' in ${response_json}    recipient section is missing in the response
    #Asserting specific values
    Should Be Equal   ${response_json['status']}    expired-returning
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False

Changing the expired multiple parcel status to expired-returning
    [Arguments]     ${Counter_token}  ${group_id}   ${parcel_id_1}  ${parcel_id_2}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}  # Store both parcel IDs
    FOR    ${index}    IN RANGE    2  # Getting two parcels by id
    ${current_parcel_id}=    Get From List    ${parcel_ids}    ${index}
    ${data}=    Create Dictionary      groupId=${groupId}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${response}=        PATCH     ${base_URL}${Returning_status_change_endpoint1}${current_parcel_id}${Returning_status_change_endpoint2}   headers=${headers}   json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True  'expireTimestamp' in ${response_json}    expireTimestamp is missing in the response
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'recipient' in ${response_json}    recipient section is missing in the response
    #Asserting specific values
    Should Be Equal   ${response_json['status']}    expired-returning
    Should Be Equal   ${response_json['adultSignatureRequired']}   ${True}
    Should Be Equal   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal   ${response_json['commercialInvoiceRequired']}    ${False}
    END

Adding the counter schedule details
    [Arguments]     ${Admin_token}
    ${Data_String}=    Get File    ${JSON_FILE_PATH}
    ${headers}=     Create Dictionary       Content-Type=application/json       Authorization=${Admin_token}
    ${url}=    Catenate    SEPARATOR=    ${base_URL}    ${Update_counter_schedule_endpoint1}${Counter_id}${Update_counter_schedule_endpoint2}
    ${response}=        PUT     ${url}    headers=${headers}   data=${Data_String}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}

Get derivation parcel id by EAN code
    [Arguments]       ${counter_token}    ${code}
    ${headers}=    Create Dictionary    Content-Type=application/json     Authorization=${counter_token}
    ${response}=    GET     ${base_URL}${get_by_EAN}${code}    headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True    'id' in ${response_json}    Id is missing in the response
    Should Be True    'counterId' in ${response_json}    counter ID is missing in the response
    Should Be True    'originalAddress' in ${response_json}     original address is missing in the response
    Should Be True    'status' in ${response_json}  status is missing in the response
    Should Be True    'createdAt' in ${response_json}  createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}  updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}  EAN is missing in the response
    Should Be True    'monies' in ${response_json}  monies is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}  deliveryDriver is missing in the response
    Should Be True    'courier' in ${response_json}  courier is missing in the response
    Should Be True    'kanguroPoint' in ${response_json}  kanguroPoint is missing in the response
    Should Be True    'sender' in ${response_json}  sender is missing in the response
    Should Be True    'recipient' in ${response_json}  recipient is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['expireTimestamp']}   ${null}
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if adultSignatureRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${derivation_recipient_id}=     Set Variable    ${response_json['recipient']['id']}
    ${derivation_recipient_name}=      Set Variable  ${response_json['recipient']['profile']['name']}
    ${derivation_recipient_Phone_number}=       Set Variable    ${response_json['recipient']['profile']['phone']}
    Log    Parcel ID: ${parcel_id}
    Log    Recipient_ID: ${derivation_recipient_id}
    Log    Recipient_name:${derivation_recipient_name}
    Log    Recipient_phone_number:${derivation_recipient_Phone_number}
    # RETURN the parcel ID if needed
    RETURN    ${parcel_id}   ${derivation_recipient_id}   ${derivation_recipient_name}  ${derivation_recipient_Phone_number}

Getting the counter future parcels
    [Arguments]    ${counter_token}
    # Create the headers for the API request.
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    # Send the GET request to the API endpoint.
    ${response}=    GET    ${base_URL}${future_parcels_endpoint}    headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    ${items}=       Set Variable    ${response_json['items']}
    Run Keyword If    ${items} == []    Return From Keyword
    ${parcel_id}=    Set Variable    ${items[0]['id']}
    #${parcel_id}=    Set Variable    ${response_json['items'][0]['id']}
    Log    Parcel ID: ${parcel_id}
    RETURN    ${parcel_id}

Changing All The Future Parcel Status Into Cancelled
    [Arguments]    ${Admin_token}    ${counter_token}
    FOR    ${index}    IN RANGE    1000
        ${parcel_id}=    Getting the counter future parcels    ${counter_token}
        Run Keyword If    '${parcel_id}' == ''    Run Keywords    Log    No future parcels to cancel.    AND    Exit For Loop
        Run Keyword If    '${parcel_id}' == 'None'    Run Keywords    Log    No future parcels to cancel (None).    AND    Exit For Loop
        Change The Parcel Status Into Cancelled    ${Admin_token}    ${parcel_id}
    END

Deleting the vacation periods
    [Arguments]   ${Admin_token}
    ${headers}=    Create Dictionary    Content-Type=application/json     Authorization=${Admin_token}
    ${data}=    Create Dictionary   holidays=[]
    ${response}=    PUT     ${base_URL}${Update_vacation_endpoint1}${Counter_id}${Update_vacation_endpoint2}   headers=${headers}   json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True    'count' in ${response_json}    count is missing in the response
    Should Be True    'items' in ${response_json}    items is missing in the response




