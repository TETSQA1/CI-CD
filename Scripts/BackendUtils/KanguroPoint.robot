*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json
Resource   BackendMainconfig.robot
Resource   ../../Resources/CommonUtils/CommonUtils.robot

*** Variables ***
#KP address for the newly creating KP
${New_KP_Address}          Pg. Sant Antoni, Sants-Montjuïc, 08014 Barcelona, Spain
${New_KP_Postal_Code}      08014
${New_KP_Province}         Barcelona
${New_KP_City}             Barcelona
${New_KP_longitude}        2.1409248027951144
${New_KP_latitude}         41.379614700399614
${language_id}             en_US
${image_url}               https://www.kanguro.com/images/logo.png
${iban}                    DE89370400440532013000
${Country_ID}              ES
${timezone}                Europe/Madrid
${direction}               Pg. Sant Antoni
${status}                  lost

*** Keywords ***
Adding a new kanguro point
    [Arguments]     ${Admin_token}
    #Generating random CID number
    ${cid}=  Generate Random number
    #Generating random counter phone number
    ${New_Counter_phone_number}=    Generate Random Phone Number
    #Generating random counter name
    ${Counter_name}=    Generate random counter name
    #Generating random counter user name
    ${Counter_user_name}=   Generate Random Counteruser Name
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
    ${Address_Component}=  Create Dictionary   direction=${New_KP_Address}    postalCode=${New_KP_Postal_Code}    province=${New_KP_Province}     city=${New_KP_City}
    ${profile}=  Create Dictionary  name=${Counter_user_name}   phone=${New_Counter_phone_number}    imageUrl=${image_url}    languageId=${language_id}
    ${Counter_details}=    Create Dictionary   name=${Counter_name}    phone=${New_Counter_phone_number}    iban=${iban}   profile=${profile}   schedule=[]
    ${data}=    Create Dictionary   accountId=${Existing_accout_id}  type=internal   addressComponents=${Address_Component}   address=${New_KP_Address}  longitude=${New_KP_longitude}   latitude=${New_KP_latitude}    countryId=${Country_ID}    timeZone=${timezone}   isPrivate=false  cid=${cid}  attachments=[]  counter=${Counter_details}
    ${response}=   POST    ${base_URL}${New_KP_base_endpoint}    headers=${headers}      json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)  json
    #Assertions should be true
    Should Be True    "id" in ${response_json}  id is missing in the response
    Should Be True    "cid" in ${response_json}  cid is missing in the response
    Should Be True    "addressComponents" in ${response_json}  addressComponents is missing in the response
    Should Be True    "address" in ${response_json}  address is missing in the response
    Should Be True    "longitude" in ${response_json}  longitude is missing in the response
    Should Be True    "latitude" in ${response_json}  latitude is missing in the response
    Should Be True    "countryId" in ${response_json}  countryId is missing in the response
    Should Be True    "timeZone" in ${response_json}  timeZone is missing in the response
    Should Be True    "code" in ${response_json}  code is missing in the response
    Should Be True    "isPrivate" in ${response_json}  isPrivate is missing in the response
    Should Be True    "attachments" in ${response_json}  attachments is missing in the response
    Should Be True    "counter" in ${response_json}  counter is missing in the response
    #Assertions should be equal
    Should Be Equal    ${response_json['status']}    pendingToActivate
    Should Be Equal    ${response_json['type']}      internal
    Should Be Equal    ${response_json['containsUpsParcels']}    ${False}
    Should Be Equal As Strings    ${response.status_code}    200
    ${New_KP_ID}=   Set Variable    ${response_json['id']}
    ${New_counter_ID}=  Set Variable    ${response_json['counter']['id']}
    Log    ${New_KP_ID}
    Log    ${New_counter_ID}
    RETURN   ${New_KP_ID}    ${New_counter_ID}

Updating the new kanguro point
    [Arguments]  ${New_KP_ID}   ${Admin_token}
    #Generating random CID number
    ${cid}=  Generate Random number
    ${Address_Component}=  Create Dictionary  postalCode=${New_KP_Postal_Code}    province=${New_KP_Province}  direction=${direction}    city=${New_KP_City}
    ${data}=    Create Dictionary    addressComponents=${Address_Component}   address=${New_KP_Address}   longitude=${New_KP_longitude}   latitude=${New_KP_latitude}  countryId=${Country_ID}  timeZone=${timezone}  cid=${cid}  isPrivate=false   accountId=${Existing_accout_id}
    ${headers}=     Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
    ${response}=    PUT  ${base_URL}${New_KP_base_endpoint}/${New_KP_ID}    headers=${headers}  json=${data}
    ${response_json}=  Evaluate    json.loads($response.content)   json
    #Assertions should be true
    Should Be True    "id" in ${response_json}  id is missing in the response
    Should Be True    "status" in ${response_json}  status is missing in the response
    Should Be True    "cid" in ${response_json}  cid is missing in the response
    Should Be True    "addressComponents" in ${response_json}  addressComponents is missing in the response
    Should Be True    "address" in ${response_json}  address is missing in the response
    Should Be True    "longitude" in ${response_json}  longitude is missing in the response
    Should Be True    "latitude" in ${response_json}  latitude is missing in the response
    Should Be True    "countryId" in ${response_json}  countryId is missing in the response
    Should Be True    "timeZone" in ${response_json}  timeZone is missing in the response
    Should Be True    "code" in ${response_json}  code is missing in the response
    Should Be True    "isPrivate" in ${response_json}  isPrivate is missing in the response
    Should Be True    "attachments" in ${response_json}  attachments is missing in the response
    Should Be True    "counter" in ${response_json}  counter is missing in the response
    Should Be True    "account" in ${response_json}  counter is missing in the response
    #Assertions should be equal
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal    ${response_json['type']}      internal
    Should Be Equal    ${response_json['containsUpsParcels']}    ${False}

Changing the status of the Kanguro point
    [Arguments]  ${New_KP_ID}   ${Admin_token}
    ${headers}=  Create Dictionary  Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   status=${status}
    ${response}=    PATCH   ${base_URL}${New_KP_base_endpoint}/${New_KP_ID}${KP_Status_change_endpoint}  headers=${headers}  json=${data}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    204

Deleting the counter
    [Arguments]  ${New_counter_ID}   ${Admin_token}
    ${headers}=  Create Dictionary  Content-Type=application/json    Authorization=${Admin_token}
    ${response}=    DELETE   ${base_URL}${New_counter_base_endpoint}${New_counter_ID}  headers=${headers}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings    ${response.status_code}    200

Deleting the kanguro point
    [Arguments]  ${New_KP_ID}   ${Admin_token}
    ${headers}=  Create Dictionary  Content-Type=application/json    Authorization=${Admin_token}
    ${response}=    DELETE   ${base_URL}${New_KP_base_endpoint}/${New_KP_ID}  headers=${headers}
    Log    Response Body: ${response.content}
    #Assertions
    Should Be Equal As Strings   ${response.status_code}    204