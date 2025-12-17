*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the derivations were accepted by the call-bot
    [Tags]    Accepting_derivation_by_call-bot
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Creating a new derivation
    ${derivation_id}  ${code}  ${Derivation_recipient_name}  ${Derivation_recipient_phone_number}=    Create a new derivation    ${Admin_token}
    #Creating new call-bot provider
    ${callbot_id}=    Create a new call-bot provider    ${Admin_token}
    ${apiKey}    ${apiSecret}=    Get callbot apiKey    ${Admin_token}     ${callbot_id}
    #Login call-bot
    ${callbot_token}=    Login as Call-bot    ${apiKey}    ${apiSecret}
    #Assiging the derivation to call bot 
    Assign the call-bot for the derivation    ${Admin_token}
    #Accepting the derivation
    Accepting the derivation by call-bot    ${callbot_token}    ${derivation_id}
    #Check the status of the derivation
    Check the status of the derivation    ${callbot_token}    ${derivation_id}