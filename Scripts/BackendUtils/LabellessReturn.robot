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
Creating a labelless sender
    [Arguments]     ${Admin_token}
    ${sender_name}=  Generate Random sender Name
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Admin_token}
    ${data}=        Create Dictionary       name=${sender_name}
    ${response}=        POST     ${base_URL}${Create_labelless_sender_endpoint}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'name' in ${response_json}    name is missing in the response
    ${labelless_sender}=   Set Variable   ${response_json['id']}
    Log    labelless sender: ${labelless_sender}
    RETURN     ${labelless_sender}

Adding the labelless sender to the courier
    [Arguments]     ${Admin_token}   ${Courier_id}   ${labelless_sender}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Admin_token}
    ${data}=        Create Dictionary    courierId=${Courier_id}    senderId=${labelless_sender}    country=ES    isRecipientPaying=${True}  cost=10  currency=EUR
    ${response}=        POST     ${base_URL}${Add_labelless_sender_to_courier_endpoint}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    #Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'id' in ${response_json['sender']}    sender id is missing in the response
    Should Be True  'name' in ${response_json['sender']}    sender name is missing in the response
    Should Be True  'courier' in ${response_json}    courier section is missing in the response
    Should Be True  'country' in ${response_json}    country is missing in the response
    Should Be True  'isRecipientPaying' in ${response_json}    isRecipientPaying is missing in the response
    Should Be True  'cost' in ${response_json}    cost is missing in the response
    Should Be True  'currency' in ${response_json}    currency is missing in the response
    Should Be Equal As Strings    ${response.status_code}    200
    ${Courier_sender_id}=   Set Variable   ${response_json['id']}
    Log    Courier sender ID: ${Courier_sender_id}
    RETURN     ${Courier_sender_id}

Creating labelless parcels
    [Arguments]     ${Counter_token}    ${sender_id}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=        Create Dictionary       courierLabellessSenderId=${sender_id}
    ${response}=        POST     ${base_URL}${create_labelless_parcel_endpoint}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings              ${response_json['EAN']}   ${null}
    Should Be Equal As Strings    ${response_json['status']}    created-recipient
    Should Be Equal As Strings   ${response_json['pinRequired']}    False
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    False
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    False
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    Should Be Equal As Strings              ${response_json['recipient']}   ${null}
    #Assertions
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'deliveryDriver'  in ${response_json} Driver section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    #Saving the parcel id
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
   # RETURN the parcel ID if needed
    RETURN    ${parcel_id}

Creating group of label-less parcels
    [Arguments]     ${Counter_token}   ${Courier_sender_id}
    @{parcel_ids}=    Create List    # Initialize an empty list to store parcel IDs
    FOR    ${index}    IN RANGE    2  # Create two parcels
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=        Create Dictionary       courierLabellessSenderId=${Courier_sender_id}
    ${response}=        POST     ${base_URL}${create_labelless_parcel_endpoint}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    #Asserting specific values
    Should Be Equal As Strings              ${response_json['EAN']}   ${null}
    Should Be Equal As Strings    ${response_json['status']}    created-recipient
    Should Be Equal As Strings   ${response_json['pinRequired']}    False
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    False
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    False
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Should Be Equal As Strings              ${response_json['deliveryDriver']}   ${null}
    Should Be Equal As Strings              ${response_json['recipient']}   ${null}
    #Assertions
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'deliveryDriver'  in ${response_json} Driver section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    #Saving the parcel id
    ${parcel_id}=    Set Variable    ${response_json['id']}
    Log    Created Parcel ID: ${parcel_id}
    # Append the parcel ID to the list
    Append To List    ${parcel_ids}    ${parcel_id}
    END
    # RETURN the parcel IDs
    ${parcel_id_1}=    Get From List    ${parcel_ids}    0
    ${parcel_id_2}=    Get From List    ${parcel_ids}    1
    RETURN    ${parcel_id_1}    ${parcel_id_2}

Assigning the recipient for the parcel
    [Arguments]     ${Counter_token}    ${parcel_id}    ${recipient_id}  ${recipient_name}  ${recipient_email}
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=        Create Dictionary       recipientId=${recipient_id}     name=${recipient_name}  email=${recipient_email}
    ${response}=        PUT     ${base_URL}${update_recipient_endpoint1}${parcel_id}${update_recipient_endpoint2}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
    # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True    'createdAt' in ${response_json}  created at is missing in the response
    Should Be True    'updatedAt' in ${response_json}  updatedAt at is missing in the response

    #Asserting specific values
    Should Be Equal As Strings              ${response_json['EAN']}   ${null}
    Should Be Equal As Strings    ${response_json['status']}    created-recipient
    Should Be Equal As Strings   ${response_json['pinRequired']}    False
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    False
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    False
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'recipient' in ${response_json}    Recipient section is missing in the response
    Should Be True  'deliveryDriver'  in ${response_json} Driver section is missing in the response
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response

Assigning the EAN for the parcel
     [Arguments]     ${Counter_token}    ${parcel_id}
    ${new_EAN}=    Generate Random EAN
    ${headers}=     Create Dictionary       content-Type=application/json       Authorization=${Counter_Token}
    ${data}=        Create Dictionary       EAN=${new_EAN}
    ${response}=        PUT     ${base_URL}${update_EAN_endpoint1}${parcel_id}${update_EAN_endpoint2}   headers=${headers}     json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    Log    Response Body: ${response.content}
     # Assertions
    Should Be True  'id' in ${response_json}    Id is missing in the response
    Should Be True  'counterId' in ${response_json}    counterId is missing in the response
    Should Be True  'originalAddress' in ${response_json}    originalAddress is missing in the response
    Should Be True    'createdAt' in ${response_json}  created at is missing in the response
    Should Be True    'updatedAt' in ${response_json}  updatedAt at is missing in the response
    #Asserting specific values
    Should Be Equal As Strings    ${response_json['status']}    created-recipient
    Should Be Equal As Strings    ${response_json['EAN']}    ${new_EAN}
    Should Be Equal As Strings   ${response_json['pinRequired']}    False
    Should Be Equal As Strings   ${response_json['adultSignatureRequired']}    False
    Should Be Equal As Strings   ${response_json['recipientOnlyRequired']}    False
    Should Be Equal As Strings   ${response_json['commercialInvoiceRequired']}    False
    Should Be Equal As Strings              ${response_json['expireTimestamp']}   ${null}
    #Assertions
    Should Be True  'deliveryDriver'  in ${response_json} Driver section is missing in the response
    Should Be True  'recipient' in ${response_json}    Recipient section is missing in the response
    Should Be True  'sender' in ${response_json}    Sender section is missing in the response
    Should Be True  'monies' in ${response_json}    monies is missing in the response
    Should Be True  'courier' in ${response_json}    Courier section is missing in the response
    Should Be True  'kanguroPoint' in ${response_json}    KanguroPoint section is missing in the response
    ${EAN}=    Set Variable    ${response_json['EAN']}
    Log    Created Parcel EAN: ${EAN}
   # RETURN the parcel ID if needed
    RETURN    ${EAN}