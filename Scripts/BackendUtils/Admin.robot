*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json
Library    String
Library    DateTime
Library    OperatingSystem
Library    BuiltIn
Library    Process
Library    DateTime
Resource   BackendMainconfig.robot
Resource   ../../Resources/CommonUtils/CommonUtils.robot

*** Variables ***
${derivations_role}          derivations
${Provider}        vonage

*** Keywords ***
Enabling the show validation on DD drop-off
    [Arguments]     ${Admin_token}    ${Counter_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   showContactInfo=${True}     collectFromRecipient=${True}     collectFromRecipientLabelless=${True}      deliverToDeliveryDriver=${True}     recoverDroppedOffRecipient=${True}   showValidationPageInDeliveryDriverDropOff=${True}   showValidationPageInDeliveryDriverCollect=${True}
    ${response}=    PATCH   ${base_URL}${Counter_settings_endpoint1}${Counter_id}${Counter_settings_endpoint2}   headers=${headers}    json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Disabling the show validation on DD drop-off
    [Arguments]     ${Admin_token}    ${Counter_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   showContactInfo=${True}     collectFromRecipient=${True}     collectFromRecipientLabelless=${True}      deliverToDeliveryDriver=${True}     recoverDroppedOffRecipient=${True}   showValidationPageInDeliveryDriverDropOff=${False}   showValidationPageInDeliveryDriverCollect=${False}
    ${response}=    PATCH   ${base_URL}${Counter_settings_endpoint1}${Counter_id}${Counter_settings_endpoint2}   headers=${headers}    json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Change the parcel status to expired
    [Arguments]     ${Admin_token}    ${monies}  ${parcel_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   status=expired      monies=${monies}     pin=123456     commertialInvoice=${True}
    ${response}=    PUT   ${base_URL}${parcel_status_change_endpoint1}${parcel_id}${parcel_status_change_endpoint2}  headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True    'id' in ${response_json}    Id is missing in the response
    Should Be True    'counterId' in ${response_json}    counterId is missing in the response
    Should Be True    'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}    EAN is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['status']}   expired    status is not changed to expired
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    #Assertions
    Should Be Equal    ${response_json['adultSignatureRequired']}   ${True}    adultSignatureRequired is not true
    Should Be Equal    ${response_json['recipientOnlyRequired']}   ${True}    recipientOnlyRequired is not true
    Should Be Equal    ${response_json['commercialInvoiceRequired']}   ${False}    commercialInvoiceRequired is not false

Change the multiple parcel status to expired
    [Arguments]     ${Admin_token}    ${monies_1}   ${monies_2}  ${parcel_id_1}  ${parcel_id_2}
    @{parcel_ids}=    Create List    ${parcel_id_1}    ${parcel_id_2}  # Store both parcel IDs
    @{monies_list}=    Create List  ${monies_1}   ${monies_2}
    FOR    ${index}    IN RANGE    2  # Getting two parcels by id
    ${current_parcel_id}=    Get From List    ${parcel_ids}    ${index}
    ${monies}=      Get From List    ${monies_list}    ${index}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   status=expired      monies=${monies}     pin=123456     commertialInvoice=${True}
    ${response}=    PUT   ${base_URL}${parcel_status_change_endpoint1}${current_parcel_id}${parcel_status_change_endpoint2}  headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True    'id' in ${response_json}    Id is missing in the response
    Should Be True    'counterId' in ${response_json}    counterId is missing in the response
    Should Be True    'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True    'createdAt' in ${response_json}    createdAt is missing in the response
    Should Be True    'updatedAt' in ${response_json}    updatedAt is missing in the response
    Should Be True    'EAN' in ${response_json}    EAN is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['status']}   expired    status is not changed to expired
    # Check if pinRequired is either True or False (string comparison)
    ${pinRequired}=    Get From Dictionary    ${response_json}    pinRequired
    Run Keyword If    '${pinRequired}' == 'True'    Should Be Equal As Strings    ${pinRequired}    True
    Run Keyword If    '${pinRequired}' == 'False'   Should Be Equal As Strings    ${pinRequired}    False
    #Assertions
    Should Be Equal    ${response_json['adultSignatureRequired']}   ${True}    adultSignatureRequired is not true
    Should Be Equal    ${response_json['recipientOnlyRequired']}   ${True}    recipientOnlyRequired is not true
    Should Be Equal    ${response_json['commercialInvoiceRequired']}   ${False}    commercialInvoiceRequired is not false
    END

Getting the monies details using admin endpoint
    [Arguments]     ${Admin_token}        ${parcel_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Admin_token}
    ${response}=        GET     ${base_URL}${parcel_monies_admin_endpoint}${parcel_id}   headers=${headers}
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
    #Saving the parcel id
    ${monies}=    Set Variable    ${response_json['monies']}
    Log    monies: ${monies}
    # RETURN the parcel ID if needed
    RETURN    ${monies}

Create a new call-bot provider
    [Arguments]   ${Admin_token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary    name=sythflow 01   role=${derivations_role}  provider=${Provider}  status=1  agentId=1724979990428x327903253233833100
    ${response}=    POST   ${base_URL}${create_call-bot_provider_endpoint}   headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'name' in ${response_json}  name is missing in the response
    Should Be True    'role' in ${response_json}  role is missing in the response
    Should Be True    'status' in ${response_json}  status is missing in the response
    Should Be True    'provider' in ${response_json}    provider is missing in the response
    Should Be True    'agentId' in ${response_json}     agentId is missing in the response
    Should Be True    'createdAt' in ${response_json}   createdAt is missing in the response
    ${Call-bot_id}=   Get From Dictionary    ${response_json}    id
    Log    call-bot ID: ${Call-bot_id}
    RETURN  ${Call-bot_id}

Get callbot apiKey
    [Arguments]   ${Admin_token}    ${callbot_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${response}=    PUT   ${base_URL}${create_call-bot_provider_endpoint}/${callbot_id}/api-key   headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be True    'apiKey' in ${response_json}   id is missing in the response
    Should Be True    'apiSecret' in ${response_json}  name is missing in the response
    ${apiKey}=   Get From Dictionary    ${response_json}    apiKey
    ${apiSecret}=   Get From Dictionary    ${response_json}    apiSecret
    Log    apiKey: ${apiKey}
    Log    apiSecret: ${apiSecret}
    RETURN      ${apiKey}    ${apiSecret}

Create a new derivation
    [Arguments]   ${Admin_token}
    ${code}=  Generate derivation code
    ${phone}=  Generate Random Phone Number
    ${date}=    Get Current Date
    ${new_recipient_phone_number}=  Generate Random Phone Number
    ${new_recipient_email}=     Generate Random Email
    ${new_recipient_name}=  Generate Random Recipient Name
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary    code=${code}   originalAddress=Av. Diagonal, 609, Les Corts, 08021 Barcelona, Spain   address=Av. Diagonal, 609, Les Corts, 08021 Barcelona, Spain   phone=${new_recipient_phone_number}   email=${new_recipient_email}     recipientName=${new_recipient_name}  courierId=${Courier_id}    sender=primesender     deliveryDriverId=${null}    senderId=${null}    derivationDate=${date}
    ${response}=    POST   ${base_URL}${create_derivation_endpoint}   headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Assertions check postal code in derivation code
    ${expected_code}=   Set Variable    08021
    ${full_code}=    Get From Dictionary    ${response_json}    code
    ${actual_code}=    Evaluate    $full_code.split('-')[1]
    Run Keyword If    '${actual_code}' != '${expected_code}'    Log    "Unexpected code received: ${actual_code}"
    ...  ELSE
    ...  Log    Expected postal code 08028 is received
    #assertions
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'code' in ${response_json}  code is missing in the response
    Should Be True    'originalAddress' in ${response_json}  originalAddress is missing in the response
    Should Be True    'originalAddressCity' in ${response_json}  originalAddressCity is missing in the response
    Should Be True    'originalAddressDirection' in ${response_json}  originalAddressDirection is missing in the response
    Should Be True    'originalAddressFloorInfo' in ${response_json}    originalAddressFloorInfo is missing in the response
    Should Be True    'originalAddressStreetNumber' in ${response_json}    originalAddressStreetNumber is missing in the response
    Should Be True    'originalAddressPostalCode' in ${response_json}    originalAddressPostalCode is missing in the response
    Should Be True    'originalAddressProvince' in ${response_json}    originalAddressProvince is missing in the response
    Should Be True    'phone' in ${response_json}    phone is missing in the response
    Should Be True    'email' in ${response_json}    email is missing in the response
    Should Be True    'name' in ${response_json}    name is missing in the response
    Should Be True    'dni' in ${response_json}     dni is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be True    '${response_json['status']}' in ['PENDING']
    #Assertions
    Should Be True    'comments' in ${response_json}   comments is missing in the response
    Should Be True    'commercial' in ${response_json}   commercial is missing in the response
    Should Be True    'senderId' in ${response_json}   senderId is missing in the response
    Should Be True    'sender' in ${response_json}   sender is missing in the response
    Should Be True    'courierId' in ${response_json}   courierId is missing in the response
    Should Be True    'courier' in ${response_json}   courier is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}   deliveryDriver is missing in the response
    Should Be True    'distance' in ${response_json}    distance is missing in the response
    Should Be True    'distanceTime' in ${response_json}    distanceTime is missing in the response
    Should Be True    'parcelsCount' in ${response_json}    parcelsCount is missing in the response
    Should Be True    'locutionUrl' in ${response_json}     locutionUrl is missing in the response
    Should Be True    'kanguroPointId' in ${response_json}   kanguroPointId is missing in the response
    Should Be True    'kanguroPointName' in ${response_json}   kanguroPointName is missing in the response
    Should Be True    'kanguroPointDirection' in ${response_json}   kanguroPointDirection is missing in the response
    Should Be True    'kanguroPointCity' in ${response_json}   kanguroPointCity is missing in the response
    Should Be True    'kanguroPointProvince' in ${response_json}   kanguroPointProvince is missing in the response
    Should Be True    'kanguroPointPostalCode' in ${response_json}   kanguroPointPostalCode is missing in the response
    Should Be True    'callsCount' in ${response_json}   callsCount is missing in the response
    Should Be True    'derivationDate' in ${response_json}   derivationDate is missing in the response
    ${derivation_id}=   Get From Dictionary    ${response_json}    id
    ${code}=  Get From Dictionary    ${response_json}    code
    ${Derivation_recipient_name}=       Set Variable    ${new_recipient_name}
    ${Derivation_recipient_phone_number}=       Set Variable    ${new_recipient_phone_number}
    RETURN  ${derivation_id}  ${code}  ${Derivation_recipient_name}  ${Derivation_recipient_phone_number}

Assign the call-bot for the derivation
    [Arguments]   ${Admin_token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary
    ${response}=    PATCH   ${base_URL}${Assign_derivation_call-bot_endpoint}   headers=${headers}    json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Accepting the derivation by call-bot
    [Arguments]   ${callbot_token}    ${derivation_id}
    ${DNI}=  Generate Random number
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${callbot_token}
    ${data}=    Create Dictionary  locutionUrl=...  dni=${DNI}   kanguroPointId=${Derivation_KP_ID}
    ${response}=    PATCH   ${base_URL}${Accept_derivation_endpoint1}${derivation_id}${Accept_derivation_endpoint2}   headers=${headers}    json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Rejecting the derivation by call-bot
    [Arguments]   ${callbot_token}    ${derivation_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${callbot_token}
    ${data}=    Create Dictionary  comments=C01
    ${response}=    PATCH   ${base_URL}${Reject_derivation_endpoint1}${derivation_id}${Reject_derivation_endpoint2}   headers=${headers}    json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Check the status of the derivation
    [Arguments]   ${callbot_token}     ${derivation_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${callbot_token}
    ${response}=    GET   ${base_URL}${Derivation_status_endpoint}${derivation_id}   headers=${headers}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Assertions
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'originalAddress' in ${response_json}  originalAddress is missing in the response
    Should Be True    'originalAddressCity' in ${response_json}  originalAddressCity is missing in the response
    Should Be True    'originalAddressDirection' in ${response_json}  originalAddressDirection is missing in the response
    Should Be True    'originalAddressFloorInfo' in ${response_json}    originalAddressFloorInfo is missing in the response
    Should Be True    'originalAddressStreetNumber' in ${response_json}    originalAddressStreetNumber is missing in the response
    Should Be True    'originalAddressPostalCode' in ${response_json}    originalAddressPostalCode is missing in the response
    Should Be True    'originalAddressProvince' in ${response_json}    originalAddressProvince is missing in the response
    Should Be True    'phone' in ${response_json}    phone is missing in the response
    Should Be True    'email' in ${response_json}    email is missing in the response
    Should Be True    'name' in ${response_json}    name is missing in the response
    Should Be True    'dni' in ${response_json}     dni is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be True    'code' in ${response_json}  code is missing in the response
    #Checking the parcel status
    Run Keyword If    '${response_json["status"]}' == 'ACCEPTED'    Log    The parcel status is accepted
    ...  ELSE IF    '${response_json["status"]}' == 'REJECTED'    Log    The parcel status is rejected
    #Assertions
    Should Be True    'comments' in ${response_json}   comments is missing in the response
    Should Be True    'commercial' in ${response_json}   commercial is missing in the response
    Should Be True    'senderId' in ${response_json}   senderId is missing in the response
    Should Be True    'sender' in ${response_json}   sender is missing in the response
    Should Be True    'courierId' in ${response_json}   courierId is missing in the response
    Should Be True    'courier' in ${response_json}   courier is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}   deliveryDriver is missing in the response
    Should Be True    'distance' in ${response_json}    distance is missing in the response
    Should Be True    'distanceTime' in ${response_json}    distanceTime is missing in the response
    Should Be True    'parcelsCount' in ${response_json}    parcelsCount is missing in the response
    Should Be True    'locutionUrl' in ${response_json}     locutionUrl is missing in the response
    Should Be True    'kanguroPointId' in ${response_json}   kanguroPointId is missing in the response
    Should Be True    'kanguroPointName' in ${response_json}   kanguroPointName is missing in the response
    Should Be True    'kanguroPointDirection' in ${response_json}   kanguroPointDirection is missing in the response
    Should Be True    'kanguroPointCity' in ${response_json}   kanguroPointCity is missing in the response
    Should Be True    'kanguroPointProvince' in ${response_json}   kanguroPointProvince is missing in the response
    Should Be True    'kanguroPointPostalCode' in ${response_json}   kanguroPointPostalCode is missing in the response
    Should Be True    'callsCount' in ${response_json}   callsCount is missing in the response
    Should Be True    'derivationDate' in ${response_json}   derivationDate is missing in the response

Update the derivation
    [Arguments]   ${Admin_token}     ${derivation_id}   ${Derivation_recipient_phone_number}    ${derivation_recipient_name}
    ${Phone}=   Generate Random Phone Number
    ${derivation_date}=     Get Current Date
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   originalAddress=${originalAddress}  address=${originalAddress}  phone=${Derivation_recipient_phone_number}  email=none   recipientName=${derivation_recipient_name}  derivationDate=${derivation_date}
    ${response}=    PUT   ${base_URL}${Update_derivation_endpoint}${derivation_id}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Asserting specific values
    Should Be Equal As Strings    ${response.status_code}    200
    #Checking the parcel status
    Run Keyword If    '${response_json["status"]}' == 'ACCEPTED'    Log    The parcel status is accepted
    ...  ELSE IF    '${response_json["status"]}' == 'REJECTED'    Log    The parcel status is rejected
    #Assertions
    Should Be True    'code' in ${response_json}  code is missing in the response
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'code' in ${response_json}   code is missing in the response
    Should Be True    'originalAddress' in ${response_json}  originalAddress is missing in the response
    Should Be True    'address' in ${response_json}  address is missing in the response
    Should Be True    'originalAddressCity' in ${response_json}  originalAddressCity is missing in the response
    Should Be True    'originalAddressDirection' in ${response_json}  originalAddressDirection is missing in the response
    Should Be True    'originalAddressFloorInfo' in ${response_json}    originalAddressFloorInfo is missing in the response
    Should Be True    'originalAddressStreetNumber' in ${response_json}    originalAddressStreetNumber is missing in the response
    Should Be True    'originalAddressPostalCode' in ${response_json}    originalAddressPostalCode is missing in the response
    Should Be True    'originalAddressProvince' in ${response_json}    originalAddressProvince is missing in the response
    Should Be True    'phone' in ${response_json}    phone is missing in the response
    Should Be True    'email' in ${response_json}    email is missing in the response
    Should Be True    'name' in ${response_json}    name is missing in the response
    Should Be True    'dni' in ${response_json}     dni is missing in the response
    Should Be True    'comments' in ${response_json}   comments is missing in the response
    Should Be True    'commercial' in ${response_json}   commercial is missing in the response
    Should Be True    'senderId' in ${response_json}   senderId is missing in the response
    Should Be True    'sender' in ${response_json}   sender is missing in the response
    Should Be True    'courierId' in ${response_json}   courierId is missing in the response
    Should Be True    'courier' in ${response_json}   courier is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}   deliveryDriver is missing in the response
    Should Be True    'distance' in ${response_json}    distance is missing in the response
    Should Be True    'distanceTime' in ${response_json}    distanceTime is missing in the response
    Should Be True    'parcelsCount' in ${response_json}    parcelsCount is missing in the response
    Should Be True    'locutionUrl' in ${response_json}     locutionUrl is missing in the response
    Should Be True    'kanguroPointId' in ${response_json}   kanguroPointId is missing in the response
    Should Be True    'kanguroPointName' in ${response_json}   kanguroPointName is missing in the response
    Should Be True    'kanguroPointDirection' in ${response_json}   kanguroPointDirection is missing in the response
    Should Be True    'kanguroPointCity' in ${response_json}   kanguroPointCity is missing in the response
    Should Be True    'kanguroPointProvince' in ${response_json}   kanguroPointProvince is missing in the response
    Should Be True    'kanguroPointPostalCode' in ${response_json}   kanguroPointPostalCode is missing in the response
    Should Be True    'callsCount' in ${response_json}   callsCount is missing in the response
    Should Be True    'derivationDate' in ${response_json}   derivationDate is missing in the response
    ${code}=    Get From Dictionary    ${response_json}    code
    Log    Code:${code}
    #Return the values
    RETURN  ${code}

Adding a new FAQ
    [Arguments]     ${Admin_token}
    ${question}=    Generate Random contents
    ${answer}=      Generate Random contents
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   userType=counter    question=${question}    answer=${answer}    tags=tag1,tag2  i18NexusQuestionKey=question_key  i18NexusAnswerKey=answer_key  incidenceReason=incidence reason  incidenceType=1   url=www.google.com
    ${response}=    POST   ${base_URL}${Add_FAQ_endpoint}    headers=${headers}      json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Assertions
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'userType' in ${response_json}   userType is missing in the response
    Should Be True    'question' in ${response_json}   question is missing in the response
    Should Be True    'answer' in ${response_json}   answer is missing in the response
    Should Be True    'tags' in ${response_json}   tags is missing in the response
    Should Be True    'i18NexusQuestionKey' in ${response_json}   i18NexusQuestionKey is missing in the
    Should Be True    'i18NexusAnswerKey' in ${response_json}   i18NexusAnswerKey is missing in the response
    Should Be True    'incidenceReason' in ${response_json}   incidenceReason is missing in the response
    Should Be True    'incidenceType' in ${response_json}   incidenceType is missing in the response
    Should Be True    'url' in ${response_json}   url is missing in the response
    #Log and return values
    ${FAQ_id}=   Get From Dictionary    ${response_json}    id
    ${FAQ_answer}=  Get From Dictionary    ${response_json}    question
    Log    FAQ_id:${FAQ_id}
    Log    FAQ_answer:${FAQ_answer}
    #Returning values
    RETURN  ${FAQ_id}   ${FAQ_answer}

Edit the FAQ
    [Arguments]     ${Admin_token}  ${FAQ_id}
    ${question}=    Generate Random contents
    ${answer}=      Generate Random contents
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   userType=counter    question=${question}    answer=${answer}    tags=tag1,tag2  i18NexusQuestionKey=question_key  i18NexusAnswerKey=answer_key  incidenceReason=incidence reason  incidenceType=2   url=www.google.com
    ${response}=    PUT   ${base_URL}${Edit_FAQ_endpoint}${FAQ_id}    headers=${headers}      json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Assertions
    Should Be True    'id' in ${response_json}   id is missing in the response
    Should Be True    'userType' in ${response_json}   userType is missing in the response
    Should Be True    'question' in ${response_json}   question is missing in the response
    Should Be True    'answer' in ${response_json}   answer is missing in the response
    Should Be True    'tags' in ${response_json}   tags is missing in the response
    Should Be True    'i18NexusQuestionKey' in ${response_json}   i18NexusQuestionKey is missing in the
    Should Be True    'i18NexusAnswerKey' in ${response_json}   i18NexusAnswerKey is missing in the response
    Should Be True    'incidenceReason' in ${response_json}   incidenceReason is missing in the response
    Should Be True    'incidenceType' in ${response_json}   incidenceType is missing in the response
    Should Be True    'url' in ${response_json}   url is missing in the response

Delete the FAQ
    [Arguments]     ${Admin_token}  ${FAQ_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${response}=    DELETE   ${base_URL}${Edit_FAQ_endpoint}${FAQ_id}    headers=${headers}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Change the parcel status into cancelled
    [Arguments]     ${Admin_token}   ${parcel_id}
    ${headers}=     Create Dictionary    Content-Type=application/json      Authorization=${Admin_token}
    ${data}=    Create Dictionary    status=cancelled
    ${response}=    PUT   ${base_URL}${Change_parcel_status_endpoint1}${parcel_id}${Change_parcel_status_endpoint2}   headers=${headers}  json=${data}

