*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/Counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the accepted derivation parcels were delivered to the recipient
    [Tags]    Deliver_accepted_derivation_to_recipient
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Creating a new derivation
    ${derivation_id}  ${code}  ${Derivation_recipient_name}  ${Derivation_recipient_phone_number}=    Create a new derivation    ${Admin_token}
    #Creating new call-bot provider
    ${callbot_id}=    Create a new call-bot provider    ${Admin_token}
    ${apiKey}    ${apiSecret}=    get callbot apiKey    ${Admin_token}     ${callbot_id}
    #Login call-bot
    ${callbot_token}=    Login as Call-bot    ${apiKey}    ${apiSecret}
    #Assiging the derivation to call bot
    Assign the call-bot for the derivation    ${Admin_token}
    #Accepting the derivation
    Accepting the derivation by call-bot    ${callbot_token}    ${derivation_id}
    #Check the status of the derivation
    Check the status of the derivation    ${callbot_token}    ${derivation_id}
    #Counter login (check counter is a correct one or not)
    ${requestId}=   Login As Counter first step    ${Derivation_KP_Phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Getting the parcels by id by EAN
    ${parcel_id}   ${derivation_recipient_id}   ${derivation_recipient_name}  ${derivation_recipient_Phone_number}=   Get derivation parcel id by EAN code    ${counter_token}    ${code}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}
    #Assigning the verification code for the recipient
    Assigning verification code for the new recipient user    ${Admin_token}    ${derivation_recipient_Phone_number}
    #Login recipient
    ${requestId_recipient}=    Login as Recipient first step    ${derivation_recipient_Phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #getting the group id
    ${group_id}=    Get the group id    ${recipient_token}    ${Derivation_Counter_ID}
    #changing the parcel status to collecting
    Change the status of the parcel into collecting    ${Counter_token}    ${group_id}    ${parcel_id}
    #Getting the parcel id from the group API
    Getting the parcel id using group    ${counter_token}    ${group_id}
    #Getting parcel monies detail
    ${monies}=      Getting parcels monies details    ${counter_token}    ${parcel_id}
    #Updating recipient signature and profile
    Updating the recipient signature and profile    ${recipient_token}    ${Derivation_recipient_name}
    #changing the parcel status into collected
    Validating the parcel and changing the parcel status into collected    ${counter_token}    ${parcel_id}    ${monies}