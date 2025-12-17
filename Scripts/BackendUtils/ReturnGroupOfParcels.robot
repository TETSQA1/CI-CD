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
Resource   LabellessReturn.robot

*** Keywords ***
Assigning EAN for the group of parcels
    [Arguments]     ${Counter_token}    ${parcel_id_1}  ${parcel_id_2}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}  # Store both parcel IDs
    @{responses}=    Create List    # Initialize an empty list to store responses
    FOR    ${index}    IN RANGE    2  # Getting two parcels by id
    ${current_parcel_id}=    Get From List    ${parcel_ids}    ${index}
    ${new_EAN}=    Generate Random EAN
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=        Create Dictionary       EAN=${new_EAN}
    ${response}=        PUT     ${base_URL}${update_EAN_endpoint1}${current_parcel_id}${update_EAN_endpoint2}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created-recipient
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
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
    #Assertions
    Should Be True  'EAN' in ${response_json}    EAN section is missing in the response
    Should Be True  'recipient' in ${response_json}    Recipient section is missing in the response
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    END
    # Optionally return the responses if needed
    RETURN    ${responses}

Assign recipient for the group of parcels
     [Arguments]     ${Counter_token}    ${parcel_id_1}  ${parcel_id_2}  ${recipient_id}   ${recipient_name}   ${recipient_email}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}  # Store both parcel IDs
    @{responses}=    Create List    # Initialize an empty list to store responses
    FOR    ${index}    IN RANGE    2  # Getting two parcels by id
    ${current_parcel_id}=    Get From List    ${parcel_ids}    ${index}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=        Create Dictionary       recipientId=${recipient_id}     name=${recipient_name}  email=${recipient_email}
    ${response}=        PUT     ${base_URL}${update_recipient_endpoint1}${current_parcel_id}${update_recipient_endpoint2}   headers=${headers}   json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings              ${response_json['EAN']}   ${null}
    Should Be Equal As Strings    ${response_json['status']}    created-recipient
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
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
    #Assertions
    Should Be True  'recipient' in ${response_json}    Recipient section is missing in the response
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    END
    # Optionally return the responses if needed
    RETURN    ${responses}

Creating group for recipient to deliver
     [Arguments]    ${driver_token}  ${parcel_id_1}   ${parcel_id_2}
     ${headers}=    Create Dictionary   Content-Type=application/json   Authorization=${driver_token}
     ${parcel_ids}=   Create List  ${parcel_id_1}  ${parcel_id_2}
     ${data}=   Create Dictionary    parcelsIds=${parcel_ids}
     ${response}=   POST    ${base_URL}${Recipient_deliver_groups_endpoint}    headers=${headers}   json=${data}
     ${response_json}=    Evaluate    json.loads($response.content)    json
     Log    Response Body: ${response.content}
     # Assertions
     Should Be True  'groupId' in ${response_json}    groupId is missing in the response
     Should Be True  'parcelsCount' in ${response_json}    parcelsCount is missing in the response
     ${group_id_deliver}=       Set Variable    ${response_json['groupId']}
     Log    Group ID: ${group_id_deliver}
     RETURN  ${group_id_deliver}

Get possible actions for the group of return parcels
     [Arguments]    ${group_id_deliver}     ${counter_token}
     ${headers}=    Create Dictionary   Content-Type=application/json   Authorization=${counter_token}
     ${response}=   GET    ${base_URL}${Possible_actions_endpoint1}${group_id_deliver}${Possible_actions_endpoint2}    headers=${headers}
     ${response_json}=    Evaluate    json.loads($response.content)    json
     Log    Response Body: ${response.content}
     #Assertions
     Should Be True  'possibleNextActions' in ${response_json}    possibleNextActions section is missing in the response
     Should Be True  'code' in ${response_json}    code section is missing in the response
     Should Be True  'codeType'  in ${response_json} code section is missing in the response
     Should Be True  'surprise'  in ${response_json} surprise section is missing in the response

Change the parcel status into dropping-recipient
     [Arguments]    ${group_id_deliver}    ${counter_token}
     ${headers}=    Create Dictionary   Content-Type=application/json   Authorization=${counter_token}
     ${data}=   Create Dictionary   action=collect-from-recipient   code=${group_id_deliver}
     ${response}=   POST    ${base_URL}${Confirm_action_endpoint}    headers=${headers}    json=${data}
     ${response_json}=    Evaluate    json.loads($response.content)    json
     Log    Response Body: ${response.content}
     #Assertions
     Should Be Equal    ${response_json['action']}    collect-from-recipient
     Should Be Equal    ${response_json['parcelsList']['items'][1]['status']}    dropping-recipient
     Should Be True    'codeType' in ${response_json}     codeType is missing in response
     Should Be True    'groupId' in ${response_json}     groupId is missing in response
     Should Be True    'parcelsList' in ${response_json}     parcelsList is missing in response

Change the group of parcels status into returning
    [Arguments]     ${Counter_token}  ${group_id}  ${parcel_id1}    ${parcel_id2}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}
    @{responses}=    Create List
    FOR    ${index}    IN RANGE    2  # Getting two parcels by id
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${current_parcel_id}=    Get From List    ${parcel_ids}    ${index}
    ${data}=    Create Dictionary      groupId=${groupId}
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
    Should Be Equal   ${response_json['status']}    returning
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
    END

Validating multiple return group of parcels and changing parcel status into drop-off-recipient
    [Arguments]    ${counter_token}   ${parcel_id_1}  ${parcel_id_2}   ${monies_1}   ${monies_2}
    @{parcel_ids}=  Create List     ${parcel_id_1}     ${parcel_id_2}
    @{monies_list}=    Create List  ${monies_1}   ${monies_2}
    FOR    ${index}    IN RANGE    0    2
    ${parcel_id}=   Get From List    ${parcel_ids}    ${index}
    ${monies}=      Get From List    ${monies_list}    ${index}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${data} =   Create Dictionary   action=${action_return}    valid=${valid}     pin=${pin}  attachments=${attachments}   monies=${monies}    adultSignature=False    recipientOnlyRequired=False    commercialInvoiceRequired=False
    ${response}=    PATCH    ${base_URL}${Validate_parcel_endpoint}${parcel_id}  headers=${headers}   json=${data}
    Log    Response Body for Parcel ID ${parcel_id}: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204
    END

Validating multiple return group of parcels and changing parcel status into returned
    [Arguments]    ${counter_token}   ${parcel_id_1}  ${parcel_id_2}   ${monies_1}   ${monies_2}
    @{parcel_ids}=  Create List     ${parcel_id_1}     ${parcel_id_2}
    @{monies_list}=    Create List  ${monies_1}   ${monies_2}
    FOR    ${index}    IN RANGE    0    2
    ${parcel_id}=   Get From List    ${parcel_ids}    ${index}
    ${monies}=      Get From List    ${monies_list}    ${index}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${counter_token}
    ${data} =   Create Dictionary   action=${action_return_driver}    valid=${valid}     pin=${pin}  attachments=${attachments}   monies=${monies}    adultSignatureRequired=False    recipientOnlyRequired=False    commercialInvoiceRequired=False
    ${response}=    PATCH    ${base_URL}${Validate_parcel_endpoint}${parcel_id}  headers=${headers}   json=${data}
    Log    Response Body for Parcel ID ${parcel_id}: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204
    END