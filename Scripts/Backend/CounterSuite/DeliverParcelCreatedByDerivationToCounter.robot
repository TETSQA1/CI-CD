*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the user is able to deliver the parcels created by derivation to the counter
    [Tags]   Deliver_parcel_created_by_derivation_to_counter
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Login recipient
    ${requestId_recipient}=    Login as Recipient first step    ${Recipient_phone_number}
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
    #Accepting the derivation
    Accepting the derivation by call-bot    ${callbot_token}    ${derivation_id}
    #Check the status of the derivation
    Check the status of the derivation    ${callbot_token}    ${derivation_id}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Derivation_KP_Phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Assigning the EAN code
    ${EAN}=  Set Variable  ${code}
    #Getting the parcel details by EAN code
    ${parcel_id}=      Get parcel id by EAN    ${counter_token}    ${EAN}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}