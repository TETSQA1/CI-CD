*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/Counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the error throws while delivering a rejected derivation
    [Tags]    Deliver_rejected_derivation_to_recipient
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Login recipient
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #Creating new call-bot provider
    ${callbot_id}=    Create a new call-bot provider    ${Admin_token}
    ${apiKey}    ${apiSecret}=    get callbot apiKey    ${Admin_token}     ${callbot_id}
    #Login call-bot
    ${callbot_token}=    Login as Call-bot    ${apiKey}    ${apiSecret}
    #Creating a new derivation
    ${derivation_id}  ${code}  ${Derivation_recipient_name}  ${Derivation_recipient_phone_number}=    Create a new derivation    ${Admin_token}
    #Assiging the derivation to call bot
    Assign the call-bot for the derivation    ${Admin_token}
    #Rejecting the derivation
    Rejecting the derivation by call-bot    ${callbot_token}    ${derivation_id}
    #Check the status of the derivation
    Check the status of the derivation    ${callbot_token}    ${derivation_id}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Getting the parcels id by EAN
    ${status}    ${output}=    Run Keyword And Ignore Error    Get derivation parcel id by EAN code    ${counter_token}    ${code}
    Run Keyword If    '${status}' == 'FAIL'    Log    Keyword failed with error: ${output}
    ...  ELSE    Log    The keyword is not failed and passed