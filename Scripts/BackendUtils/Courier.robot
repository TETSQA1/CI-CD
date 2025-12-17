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

*** Variables ***
${Tutorial_URL}     https://docs.evostream.com/sample_content/assets/bun33s.mp4

*** Keywords ***
Add new courier
    [Arguments]     ${Admin_token}
    ${Courier_name}=  Generate random courier name
    ${Cif}=     Generate Random number
    ${Phone}=   Generate Random Phone Number
    ${headers}=     Create Dictionary    content-Type=application/json       Authorization=${Admin_token}
    ${data}=    Create Dictionary   name=${courier_name}    pronunciation=${Courier_name}   cif=${Cif}  phone=${Phone}  logo=company logo   carrierId=${null}   expireDays=10   isQrReturn=${True}  isMandatoryQrCollect=${True}    maxPinTriesCount=3  defaultDerivationDays=1    metabaseDashboardId=${null}  isLabellessReturn=${True}   isRecipientMandatoryInReturnFlow=${True}    country=ES  type=internal
    ${response}=    POST    ${base_URL}${Add_courier_endpoint}   headers=${headers}   json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertions
    Should Be True    'id' in ${response_json}    ID is missing in the response
    Should Be True    'name' in ${response_json}    name is missing in the response
    Should Be True    'logo' in ${response_json}    logo is missing in the response
    Should Be True    'cif' in ${response_json}    cif is missing in the response
    Should Be True    'phone' in ${response_json}    phone is missing in the response
    Should Be True    'carrierId' in ${response_json}    carrierId is missing in the response
    Should Be True    'carrier' in ${response_json}    carrier is missing in the response
    Should Be True    'deliveryDriver' in ${response_json}    deliveryDriver is missing in the response
    Should Be True    'maxPinTriesCount' in ${response_json}    maxPinTriesCount is missing in the response
    Should Be True    'expireDays' in ${response_json}    expireDays is missing in the response
    Should Be True    'defaultDerivationDays' in ${response_json}    defaultDerivationDays is missing in the response
    Should Be True    'apiKey' in ${response_json}    apiKey is missing in the response
    Should Be True    'pronunciation' in ${response_json}    pronunciation is missing in the response
    Should Be True    'metabaseDashboardId' in ${response_json}    metabaseDashboardId is missing in the response
    #Assertions should match values
    Should Be Equal    ${response_json['isQrReturn']}    ${True}
    Should Be Equal    ${response_json['isRecipientMandatoryInReturnFlow']}    ${True}
    Should Be Equal    ${response_json['isMandatoryQrCollect']}    ${True}
    Should Be Equal    ${response_json['isLabellessReturn']}    ${True}
    Should Be Equal    ${response_json['country']}    ES
    Should Be Equal    ${response_json['type']}    internal
    #Returning the values
    ${Courier_Id}=   Set Variable   ${response_json['id']}
    ${New_courier_name}=    Set Variable    ${response_json['name']}
    Log    Courier_id:${Courier_Id}
    Log    New_courier_name:${New_courier_name}
    RETURN  ${Courier_Id}   ${New_courier_name}
    
Add tutorial for courier in english language
    [Arguments]     ${Admin_token}  ${Courier_Id}
    ${Title}=   Generate Random contents
    ${description}=  Generate Random contents
    ${headers}=     Create Dictionary     Content-Type=application/json     Authorization=${Admin_token}
    ${data}=    Create Dictionary   courierId=${Courier_Id}     languageId=en_US    title=${Title}      description=${description}      url=${Tutorial_URL}     metaTemplate=xxx
    ${response}=    POST    ${base_URL}${Add_courier_tutorial_endpoint}     headers=${headers}      json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertions
    Should Be True    'id' in ${response_json}    id is missing in the response
    Should Be True    'metaTemplate' in ${response_json}    metaTemplate is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['languageId']}    en_US
    Should Be Equal    ${response_json['title']}    ${Title}
    Should Be Equal    ${response_json['description']}    ${description}
    Should Be Equal    ${response_json['url']}    ${Tutorial_URL}

Add tutorial for courier in Spanish language
    [Arguments]     ${Admin_token}  ${Courier_Id}
    ${Title}=   Generate Random contents
    ${description}=  Generate Random contents
    ${headers}=     Create Dictionary     Content-Type=application/json     Authorization=${Admin_token}
    ${data}=    Create Dictionary   courierId=${Courier_Id}     languageId=es_ES    title=${Title}      description=${description}      url=${Tutorial_URL}     metaTemplate=xxx
    ${response}=    POST    ${base_URL}${Add_courier_tutorial_endpoint}     headers=${headers}      json=${data}
    ${response_json}=   Evaluate    json.loads($response.content)   json
    #Assertions
    Should Be True    'id' in ${response_json}    id is missing in the response
    Should Be True    'metaTemplate' in ${response_json}    metaTemplate is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['languageId']}    es_ES
    Should Be Equal    ${response_json['title']}    ${Title}
    Should Be Equal    ${response_json['description']}    ${description}
    Should Be Equal    ${response_json['url']}    ${Tutorial_URL}

Activate the KP and courier relation as potential
    [Arguments]     ${Admin_token}    ${kanguroPointId}     ${Courier_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${Admin_token}
    ${data}=    Create Dictionary   courierId=${Courier_id}     status=potential    username=${None}   password=${None}    externalId=${None}   checkTutorialSent=${True}   checkValidatedByCourier=${False}    checkSentToCourier=${False}   checkCourierAccountCreated=${False}      checkCourierTutorialSent=${False}     checkCourierTutorialViewed=${False}     checkTutorialViewed=${False}    checkVoiceConfirmation=${False}
    ${response}=    PUT   ${base_URL}${Update_courier_KP_endpoint1}${kanguroPointId}${Update_courier_KP_endpoint2}  headers=${headers}    json=${data}
    ${response_json}=    Evaluate    json.loads($response.content)    json
    #Assertions
    Should Be True    'kanguroPointId' in ${response_json}    kanguroPointId is missing in the response
    Should Be True    'courierId' in ${response_json}  courierId is missing in the response
    Should Be True    'courierLogo' in ${response_json}    courierLogo is missing in the response
    Should Be True    'username' in ${response_json}    username is missing in the response
    Should Be True    'password' in ${response_json}    password is missing in the response
    Should Be True    'externalId' in ${response_json}    externalId is missing in the response
    #Asserting specific values
    Should Be Equal    ${response_json['courierType']}    internal  the courier type was not internal
    Should Be Equal    ${response_json['status']}    potential  the courier status was still Active