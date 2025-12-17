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
#Manually generate business identifier number in Spain using thirdparty tools (https://generator.avris.it/ES)
${business_identifier_Add}      65036421B
${business_identifier_Update}      F86601044

*** Keywords ***
Add a new account details
    [Arguments]   ${Admin_token}   ${business_identifier}
    ${Account_name}=    Generate Random account name
    ${email}=   Generate Random Email
    ${Phone}=   Generate Random Phone Number
    ${key}=    Set Variable  facebook
    ${value}=   Set Variable     facebook.com
    ${Social_media_item}=     Create Dictionary   key=${key}     value=${value}
    ${social_media}=    Create List     ${Social_media_item}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary    businessIdentifier=${business_identifier}  name=${Account_name}    socialMedia= ${social_media}  email=${email}  origin=campaings    quitReason=null     billForParcels=true     countryId=ES    province=Barcelona  phone=${Phone}  website=google.com
    ${response}=    POST  ${base_URL}${Add_account_endpoint}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    #Assertions
    Should Be True    'id' in ${response_json}       Id is missing in the response
    Should Be True    'businessIdentifier' in ${response_json}       businessIdentifier is missing in the response
    Should Be True    'name' in ${response_json}       name is missing in the response
    Should Be True    'email' in ${response_json}       email is missing in the response
    Should Be True    'quitReason' in ${response_json}       quitReason is missing in the response
    Should Be True    'billForParcels' in ${response_json}       billForParcels is missing in the response
    Should Be True    'countryId' in ${response_json}       countryId is missing in the response
    Should Be True    'province' in ${response_json}       province is missing in the response
    Should Be True    'phone' in ${response_json}       phone is missing in the response
    Should Be True    'socialMedia' in ${response_json}       socialMedia is missing in the response
    Should Be True    'website' in ${response_json}       website is missing in the response
    Should Be True    'createdAt' in ${response_json}       createdAt is missing in the response
    Should Be True    'billingInfo' in ${response_json}       billingInfo is missing in the response
    Should Be True    'contracts' in ${response_json}       contracts is missing in the response
    #Assertions for matching values
    Should Be Equal    ${response_json['status']}    active
    Should Be Equal    ${response_json['origin']}    campaings
    #Return values
    ${Account_id}=  Set Variable    ${response_json['id']}
    Log    Account_id:${response_json['id']}
    RETURN   ${Account_id}

Add a new contract
    [Arguments]  ${Admin_token}  ${Account_id}
    ${Date}=    Get Current Date
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   status=sent     dateSent=${Date}    externalId=xxx
    ${response}=    POST  ${base_URL}${Add_contract_endpoint1}${Account_id}${Add_contract_endpoint2}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json
    ${Contract_id}=  Set Variable    ${response_json['contracts'][0]['id']}
    Log    Contract_id:${response_json['contracts'][0]['id']}
    RETURN   ${Contract_id}

Updating the contract
    [Arguments]  ${Admin_token}  ${Account_id}  ${Contract_id}
    ${Date}=    Get Current Date
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   status=declined  url=url.com   dateSent=${Date}
    ${response}=    PUT  ${base_URL}${Update_contract_endpoint1}${Account_id}${Update_contract_endpoint2}${Contract_id}    headers=${HEADERS}    json=${data}
    ${response_json}=        Evaluate    json.loads($response.content)    json

Add contacts for accounts
   [Arguments]  ${Admin_token}
   ${dni}=  Generate Random number
   ${email}=  Generate Random Email
   ${mobile}=  Generate Random Phone Number
   ${phone}=  Generate Random Phone Number
   ${name}=  Generate Random String
   ${headers}=  Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
   ${data}=  Create Dictionary      position=manager    responsibleForContact=false  dni=${dni}  email=${email}  mobile=${mobile}  Phone=${phone}   firstName=${name}   lastName=${name}    saluation=null  languageId=es_ES
   ${response}=     POST    ${base_URL}${Add_contacts_endpoint1}${Existing_accout_id}${Add_contacts_endpoint2}  headers=${headers}      json=${data}
   ${response_json}=     Evaluate    json.loads($response.content)      json
   #Assertions
   Should Be True    'id' in ${response_json}       Id is missing in the response
   Should Be True    'position' in ${response_json}       position is missing in the response
   Should Be True    'responsibleForContact' in ${response_json}       responsibleForContact is missing in the response
   Should Be True    'dni' in ${response_json}       dni is missing in the response
   Should Be True    'email' in ${response_json}       email is missing in the response
   Should Be True    'mobile' in ${response_json}       mobile is missing in the response
   Should Be True    'phone' in ${response_json}       phone is missing in the response
   Should Be True    'firstName' in ${response_json}       firstName is missing in the response
   Should Be True    'lastName' in ${response_json}       lastName is missing in the response
   Should Be True    'saluation' in ${response_json}       saluation is missing in the response
   Should Be True    'languageId' in ${response_json}       languageId is missing in the response
   Should Be True    'createdAt' in ${response_json}       createdAt is missing in the response
   Should Be True    'kanguroPoint' in ${response_json}       kanguroPoint is missing in the response
   #Return values
   ${Contact_id}=   Set Variable    ${response_json['id']}
   Log    ${Contact_id}
   RETURN   ${Contact_id}

Update contacts for accounts
   [Arguments]  ${Admin_token}   ${Contact_id}
   ${dni}=  Generate Random number
   ${email}=  Generate Random Email
   ${mobile}=  Generate Random Phone Number
   ${phone}=  Generate Random Phone Number
   ${name}=  Generate Random String
   ${headers}=  Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
   ${data}=  Create Dictionary      position=manager    responsibleForContact=false  dni=${dni}  email=${email}  mobile=${mobile}  Phone=${phone}   firstName=${name}   lastName=${name}    saluation=null  languageId=es_ES   kanguroPointId=${null}
   ${response}=     PUT    ${base_URL}${Update_contact_endpoint1}${Existing_accout_id}${Update_contact_endpoint2}${Contact_id}  headers=${headers}      json=${data}
   ${response_json}=     Evaluate    json.loads($response.content)      json
   #Assertions
   Should Be True    'id' in ${response_json}       Id is missing in the response
   Should Be True    'position' in ${response_json}       position is missing in the response
   Should Be True    'responsibleForContact' in ${response_json}       responsibleForContact is missing in the response
   Should Be True    'dni' in ${response_json}       dni is missing in the response
   Should Be True    'email' in ${response_json}       email is missing in the response
   Should Be True    'mobile' in ${response_json}       mobile is missing in the response
   Should Be True    'phone' in ${response_json}       phone is missing in the response
   Should Be True    'firstName' in ${response_json}       firstName is missing in the response
   Should Be True    'lastName' in ${response_json}       lastName is missing in the response
   Should Be True    'saluation' in ${response_json}       saluation is missing in the response
   Should Be True    'languageId' in ${response_json}       languageId is missing in the response
   Should Be True    'createdAt' in ${response_json}       createdAt is missing in the response
   Should Be True    'kanguroPoint' in ${response_json}       kanguroPoint is missing in the response
   #Return values
   ${Contact_id}=   Set Variable    ${response_json['id']}
   Log    ${Contact_id}
   RETURN   ${Contact_id}

Delete account contact
   [Arguments]  ${Admin_token}   ${Contact_id}
   ${headers}=  Create Dictionary   Content-Type=application/json   Authorization=${Admin_token}
   ${response}=     DELETE    ${base_URL}${Delete_contact_endpoint1}${Existing_accout_id}${Delete_contact_endpoint2}${Contact_id}  headers=${headers}
   Log    Response Body: ${response.content}
   #Assertions
   Should Be Equal As Strings    ${response.status_code}    204