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

*** Variables ***
${LOCAL_FOLDER}    D:/Kanguro_test/Dowloaded_output_file
${FILE_NAME}   POD_file.pdf

*** Keywords ***
Create Recipient By Driver
    [Arguments]       ${driver_token}
    ${recipient_name}=    Generate Random Recipient Name
    ${recipient_phone_number}=    Generate Random Phone Number
    ${dni}=   Generate Random number
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    ${data}=    Create Dictionary    phone=${recipient_phone_number}    name=${recipient_name}      dni=${dni}
    ${response}=    POST   ${base_URL}${Create_recipient_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assert that the response status code is 200
    Should Be Equal As Strings    ${response.status_code}    200
    # Assertions for the response properties
    Should Be True    'id' in ${response_json}    Id is missing in the response
    Should Be True    'profile' in ${response_json}     Profile is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['profile']['name']}    ${recipient_name}
    Should Be Equal As Strings    ${response_json['profile']['phone']}    ${recipient_phone_number}
    Should Be Equal    ${response_json['profile']['dni']}    ${dni}
    Should Be Equal As Strings    ${response_json['profile']['multipleCounters']}    False
    Should Be Equal As Strings    ${response_json['profile']['signaturePointsProvided']}    False
    # Save the first ID in a variable
    ${recipient_id}=    Set Variable    ${response_json['id']}
    # Log the saved ID
    Log    Recipient ID: ${recipient_id}
    RETURN    ${recipient_id}  ${recipient_name}  ${recipient_phone_number}

Create Parcel By Driver using recipient
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    ${EAN}=    Generate Random EAN
    ${EAN2}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${EAN}   EAN2=${EAN2}    originalAddress=${originalAddress}  attachments=${attachments}  monies=[]   adultSignatureRequired=${True}  recipientOnlyRequired=${True}   commercialInvoiceRequired=${False}
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    # Send the request with the properly formatted JSON data
    ${response}=    POST   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    # Convert response content to JSON for verification
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    False
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    True
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    True
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${EAN}=     Set Variable    ${response_json['EAN']}
    ${EAN2}=    Set Variable    ${response_json['EAN2']}
    Log    Created Parcel ID: ${parcel_id}
    Log    Parcel EAN: ${EAN}
    Log    Parcel EAN2: ${EAN2}
    # RETURN the parcel ID and EAN
    RETURN    ${parcel_id}   ${EAN}  ${EAN2}

Create Parcel By Driver using recipient with monies
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}     originalAddress=${originalAddress}    attachments=${attachments}    monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=${False}
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    # Send the request with the properly formatted JSON data
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    # Convert response content to JSON for verification
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    False
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    True
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    True
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${EAN}=     Set Variable    ${response_json['EAN']}
    Log    Created Parcel ID: ${parcel_id}
    Log    Parcel EAN: ${EAN}
    # RETURN the parcel ID and EAN
    RETURN    ${parcel_id}   ${EAN}

Create Parcel By Driver using recipient with pin
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}      originalAddress=${originalAddress}    pin=${pin}    attachments=${attachments}    monies=[]    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=${False}
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    # Send the request with the properly formatted JSON data
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    # Convert response content to JSON for verification
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    True
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    True
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    True
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${EAN}=     Set Variable    ${response_json['EAN']}
    Log    Created Parcel ID: ${parcel_id}
    Log    Parcel EAN: ${EAN}
    # RETURN the parcel ID and EAN
    RETURN    ${parcel_id}   ${EAN}

Create Parcel By Driver using recipient with pin and monies
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}    pin=${pin}    originalAddress=${originalAddress}    attachments=${attachments}    monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=${False}
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    # Send the request with the properly formatted JSON data
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    # Convert response content to JSON for verification
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    True
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    True
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    True
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${EAN}=     Set Variable    ${response_json['EAN']}
    Log    Created Parcel ID: ${parcel_id}
    Log    Parcel EAN: ${EAN}
    # RETURN the parcel ID and EAN
    RETURN    ${parcel_id}   ${EAN}

Create multiple parcels by driver using recipient
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{parcel_ids}=    Create List    # Initialize an empty list to store parcel IDs
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}   originalAddress=${originalAddress}    attachments=${attachments}    monies=[]    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN'in ${response_json}      EAN is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
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
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'recipient' in ${response_json}    recipient section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
    # Append the parcel ID to the list
    Append To List    ${parcel_ids}    ${parcel_id}
    END
    # RETURN the parcel IDs
    ${parcel_id_1}=    Get From List    ${parcel_ids}    0
    ${parcel_id_2}=    Get From List    ${parcel_ids}    1
    RETURN    ${parcel_id_1}    ${parcel_id_2}

Create multiple parcels by driver using recipient with pin
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{parcel_ids}=    Create List    # Initialize an empty list to store parcel IDs
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}  originalAddress=${originalAddress}   pin=${pin}   attachments=${attachments}    monies=[]    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN'in ${response_json}      EAN is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
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
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'recipient' in ${response_json}    recipient section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
    # Append the parcel ID to the list
    Append To List    ${parcel_ids}    ${parcel_id}
    END
    # RETURN the parcel IDs
    ${parcel_id_1}=    Get From List    ${parcel_ids}    0
    ${parcel_id_2}=    Get From List    ${parcel_ids}    1
    RETURN    ${parcel_id_1}    ${parcel_id_2}

Create multiple parcels by driver using recipient with monies
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{parcel_ids}=    Create List    # Initialize an empty list to store parcel IDs
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    ${recipient_email}=    Generate Random Email Recipient
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}  originalAddress=${originalAddress}   monies=${monies}   attachments=${attachments}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN'in ${response_json}      EAN is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
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
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'recipient' in ${response_json}    recipient section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
    # Append the parcel ID to the list
    Append To List    ${parcel_ids}    ${parcel_id}
    END
    # RETURN the parcel IDs
    ${parcel_id_1}=    Get From List    ${parcel_ids}    0
    ${parcel_id_2}=    Get From List    ${parcel_ids}    1
    RETURN    ${parcel_id_1}    ${parcel_id_2}

Create multiple parcels by driver using recipient with Pin and monies
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{parcel_ids}=    Create List    # Initialize an empty list to store parcel IDs
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}    pin=${pin}    originalAddress=${originalAddress}    attachments=${attachments}    monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN'in ${response_json}      EAN is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
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
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'recipient' in ${response_json}    recipient section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
    # Append the parcel ID to the list
    Append To List    ${parcel_ids}    ${parcel_id}
    END
    # RETURN the parcel IDs
    ${parcel_id_1}=    Get From List    ${parcel_ids}    0
    ${parcel_id_2}=    Get From List    ${parcel_ids}    1
    RETURN    ${parcel_id_1}    ${parcel_id_2}

Create multiple parcels by driver using recipient with pin and monies (Get EAN Mobile)
    [Arguments]      ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{EAN_list}=      Create List    # Initialize an empty list to store EAN values
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}    pin=${pin}    originalAddress=${originalAddress}    attachments=${attachments}    monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    True
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${EAN}=    Set Variable    ${response_json['EAN']}
    Log    Created Parcel EAN: ${EAN_list}
    # Append the parcel ID to the list
    Append To List    ${EAN_list}    ${EAN}
    END
    # RETURN the parcel IDs and EAN list
    ${EAN_1}=    Get From List    ${EAN_list}    0
    ${EAN_2}=    Get From List    ${EAN_list}    1
    RETURN      ${EAN_1}   ${EAN_2}

Create multiple parcels by driver using recipient (Get EAN Mobile)
    [Arguments]      ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{EAN_list}=      Create List    # Initialize an empty list to store EAN values
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}    originalAddress=${originalAddress}    attachments=${attachments}    monies=[]    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    False
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${EAN}=    Set Variable    ${response_json['EAN']}
    Log    Created Parcel EAN: ${EAN_list}
    # Append the parcel ID to the list
    Append To List    ${EAN_list}    ${EAN}
    END
    # RETURN the parcel IDs and EAN list
    ${EAN_1}=    Get From List    ${EAN_list}    0
    ${EAN_2}=    Get From List    ${EAN_list}    1
    RETURN      ${EAN_1}   ${EAN_2}

Create multiple parcels by driver using recipient with pin (Get EAN Mobile)
    [Arguments]      ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{EAN_list}=      Create List    # Initialize an empty list to store EAN values
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}    pin=${pin}    originalAddress=${originalAddress}    attachments=${attachments}    monies=[]    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    True
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${EAN}=    Set Variable    ${response_json['EAN']}
    Log    Created Parcel EAN: ${EAN_list}
    # Append the parcel ID to the list
    Append To List    ${EAN_list}    ${EAN}
    END
    # RETURN the parcel IDs and EAN list
    ${EAN_1}=    Get From List    ${EAN_list}    0
    ${EAN_2}=    Get From List    ${EAN_list}    1
    RETURN      ${EAN_1}   ${EAN_2}

Create multiple parcels by driver using recipient with monies (Get EAN Mobile)
    [Arguments]      ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    @{EAN_list}=      Create List    # Initialize an empty list to store EAN values
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${new_ean}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}   originalAddress=${originalAddress}    attachments=${attachments}    monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}    recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created    parcel=${parcel_data}
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    ${False}
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${EAN}=    Set Variable    ${response_json['EAN']}
    Log    Created Parcel EAN: ${EAN_list}
    # Append the parcel ID to the list
    Append To List    ${EAN_list}    ${EAN}
    END
    # RETURN the parcel IDs and EAN list
    ${EAN_1}=    Get From List    ${EAN_list}    0
    ${EAN_2}=    Get From List    ${EAN_list}    1
    RETURN      ${EAN_1}   ${EAN_2}

Updating the created parcel
    [Arguments]       ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}  ${parcel_id}
    ${EAN}=    Generate Random EAN
    ${EAN2}=    Generate Random EAN
    ${recipient_email}=    Generate Random Email Recipient
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${EAN}   EAN2=${EAN2}   pin=${Pin}     monies=${monies}    originalAddress=${originalAddress}  attachments=${attachments}  adultSignatureRequired=${True}  recipientOnlyRequired=${True}   commercialInvoiceRequired=${False}
    ${data}=    Create Dictionary   kanguroPointId=${Kanguro_point_id}   parcel=${parcel_data}
    # Send the request with the properly formatted JSON data
    ${response}=    PUT   ${base_URL}${Parcels_base_end_point}${parcel_id}    headers=${headers}    json=${data}
    # Convert response content to JSON for verification
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created
    Should Be Equal As Strings   ${response_json['pinRequired']}    True
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    True
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    True
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    # Save the ID of the created parcel
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${EAN}=     Set Variable    ${response_json['EAN']}
    ${EAN2}=    Set Variable    ${response_json['EAN2']}
    Log    Created Parcel ID: ${parcel_id}
    Log    Parcel EAN: ${EAN}
    Log    Parcel EAN2: ${EAN2}
    # RETURN the parcel ID and EAN
    RETURN    ${parcel_id}   ${EAN}  ${EAN2}

Cancelling the created parcel
    [Arguments]     ${driver_token}   ${parcel_id}
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${driver_token}
    ${response}=    DELETE  ${base_URL}${Parcels_base_end_point}${parcel_id}   headers=${headers}
    ${response_json}=  Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['id']}    ${parcel_id}
    Should Be Equal As Strings    ${response_json['status']}    cancelled
    Should Be Equal As Strings   ${response_json['pinRequired']}    ${False}
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response

Expiring the created parcel
    [Arguments]     ${driver_token}   ${parcel_id}
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${driver_token}
    ${response}=    PATCH  ${base_URL}${Parcels_base_end_point}${parcel_id}${Expire_parcels_endpoint2}   headers=${headers}
    ${response_json}=  Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    ${expire_ts}=    Set Variable    ${response_json["expireTimestamp"]}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['id']}    ${parcel_id}
    Should Be Equal As Strings    ${response_json['status']}    expired
    Should Not Be Equal    ${expire_ts}    ${None}
    Should Be Equal As Strings   ${response_json['pinRequired']}    ${False}
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response

Getting the parcel invitation URL
    [Arguments]     ${driver_token}   ${parcel_id}
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${driver_token}
    ${response}=    GET  ${base_URL}${Parcels_base_end_point}${parcel_id}${Get_invitation_endpoint_2}   headers=${headers}
    ${response_json}=  Evaluate    json.loads($response.content)    json
    ${Invitation_URL}=  Set Variable    ${response_json['url']}
    Log    invitation URL: ${Invitation_URL}
    # Assertions
    Should Be True  'url' in ${response_json}    url is missing in the response

Dropping the created parcel
    [Arguments]     ${driver_token}   ${parcel_id}
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${driver_token}
    ${response}=    PATCH  ${base_URL}${Parcels_base_end_point}${parcel_id}${Dropping_parcel_endpoint_2}   headers=${headers}
    ${response_json}=  Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['id']}    ${parcel_id}
    Should Be Equal As Strings    ${response_json['status']}    dropping
    Should Be Equal As Strings   ${response_json['pinRequired']}    ${False}
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    ${True}
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response

Get delivery driver KP by ID
    [Arguments]  ${driver_token}     ${kanguroPointId}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    ${response}=   Run Keyword And Ignore Error    GET   ${base_URL}${DD_KP_id_endpoint}${kanguroPointId}    headers=${headers}
    RETURN      ${response}  # Return the response object

Create a return parcel
    [Arguments]       ${driver_token}   ${recipient_id}   ${recipient_phone_number}   ${recipient_name}     ${kanguroPointId}   ${recipient_email}   ${originalAddress}
    ${new_ean}=    Generate Random EAN
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    ${monies_list}=   Create Dictionary   currency=EUR  amount=12
    ${monies}=  Create List  ${monies_list}
    # Directly create the data dictionary
    ${parcel_data}=    Create Dictionary    EAN=${new_ean}    pin=${pin}    originalAddress=${originalAddress}    attachments=${attachments}    monies=${monies}    adultSignatureRequired=${True}    recipientOnlyRequired=${True}    commercialInvoiceRequired=False
    ${data}=    Create Dictionary    recipientId=${recipient_id}    recipientPhone=${recipient_phone_number}   recipientEmail=${recipient_email}    recipientName=${recipient_name}    kanguroPointId=${kanguroPointId}    status=created-recipient        parcel=${parcel_data}
    # Send the request with the properly formatted JSON data
    ${response}=    Post   ${base_URL}${Parcels_base_end_point}    headers=${headers}    json=${data}
    # Convert response content to JSON for verification
    ${response_json}=    Evaluate    json.loads($response.content)    json
    # Log the response body
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counter ID is missing in the response
    Should Be True  'originalAddress' in ${response_json}     original address is missing in the response
    Should Be True  'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True  'updatedAt' in ${response_json}    updatedAt is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['EAN']}    ${new_ean}
    Should Be Equal As Strings    ${response_json['status']}    created-recipient
    Should Be Equal As Strings    ${response_json['expireTimestamp']}   ${null}
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${recipientOnlyRequired}=    Get From Dictionary    ${response_json}    recipientOnlyRequired
    Run Keyword If    '${recipientOnlyRequired}' == 'True'    Should Be Equal As Strings    ${recipientOnlyRequired}    True
    Run Keyword If    '${recipientOnlyRequired}' == 'False'   Should Be Equal As Strings    ${recipientOnlyRequired}    False
    # Check if recipientOnlyRequired is either True or False (string comparison)
    ${adultSignatureRequired}=    Get From Dictionary    ${response_json}    adultSignatureRequired
    Run Keyword If    '${adultSignatureRequired}' == 'True'    Should Be Equal As Strings    ${adultSignatureRequired}    True
    Run Keyword If    '${adultSignatureRequired}' == 'False'   Should Be Equal As Strings    ${adultSignatureRequired}    False
    # Check if commercialInvoiceRequired is either True or False (string comparison)
    ${commercialInvoiceRequired}=    Get From Dictionary    ${response_json}    commercialInvoiceRequired
    Run Keyword If    '${commercialInvoiceRequired}' == 'True'    Should Be Equal As Strings    ${commercialInvoiceRequired}    True
    Run Keyword If    '${commercialInvoiceRequired}' == 'False'   Should Be Equal As Strings    ${commercialInvoiceRequired}    False
    #Assertions
    Should Be True  'attachments' in ${response_json}    attachments is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'deliveryDriver' in ${response_json}    DeliveryDriver section is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    Should Be True  'recipient' in ${response_json}    recipient section is missing in the response
    ${parcel_id}=    Set Variable    ${response_json['id']}
    ${EAN}=    Set Variable    ${response_json['EAN']}
    Log    Created Parcel ID: ${parcel_id}
    Log    Created Parcel EAN: ${EAN}
    # RETURN the parcel ID and EAN
    RETURN    ${parcel_id}   ${EAN}

Confirm returning the parcel by requesting the counter
    [Arguments]  ${driver_token}    ${Counter_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${driver_token}
    ${response}=    PATCH  ${base_URL}${Request_counter_confirm_return_endpoint1}${Counter_id}${Request_counter_confirm_return_endpoint2}  headers=${HEADERS}
    ${response_json}=    Evaluate    json.loads('''${response.content}''')
    Log     Response Body: ${response.content}
    #Assertions
    Should Be True    'groupId' in ${response_json}    Group ID is missing in the response
    Should Be True    'parcelsCount' in ${response_json}    parcel count is missing in the response
    ${group_id}=    Set Variable    ${response_json['groupId']}
    # Log the group ID
    Log    group ID: ${group_id}
    RETURN    ${group_id}

Generate the POD for the parcel delivered to the customer
    [Arguments]     ${driver_token}     ${parcel_id}
    ${headers}=    Create Dictionary    content-Type=application/json   Authorization=${driver_token}
    ${response}=  GET  ${base_URL}${Parcels_base_end_point}${parcel_id}${POD_endpoint_2}        headers=${HEADERS}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${pdf_content}=    Get Binary    ${response}
    Create Directory    ${LOCAL_FOLDER}
    ${file_path}=    Join Path    ${LOCAL_FOLDER}    ${FILE_NAME}
    Create Binary File    ${file_path}    ${pdf_content}
    Log    PDF saved to: ${file_path}

Get Binary
    [Arguments]    ${response}
    RETURN    ${response.content}