*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot
Resource    ../../Resources/BackendUtils/LabellessReturn.robot

*** Test Cases ***
Verify that the recipient is able to return the labelless-parcels to the courier
    [Tags]    Returning_labelless_parcel
    ${Admin_token}=     Login as admin backend
    #login counter
    ${requestId_counter}=    Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=    Login As Counter Second Step    ${requestId_counter}
    #creating labelless sender
    ${labelless_sender}=    Creating a labelless sender    ${Admin_token}
    #Adding the labelless sender to the courier
    ${Courier_sender_id}=   Adding the labelless sender to the courier    ${Admin_token}    ${Courier_id}    ${labelless_sender}
    #create labelles parcel
    ${parcel_id}=       Creating labelless parcels    ${counter_token}    ${Courier_sender_id}
    #login DD
    ${requestId_driver}=    Login As Driver
    ${driver_token}=   Login As Driver Second Step    ${requestId_driver}
    #recipient login
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #updating the recipient for the parcel
    Assigning the recipient for the parcel    ${counter_token}    ${parcel_id}    ${recipient_id}    ${recipient_name}    ${recipient_email}
    #Assigning the EAN for the parcel
    Assigning the EAN for the parcel    ${counter_token}    ${parcel_id}
    #getting parcel monies details
    ${monies}=    Getting parcels monies details    ${counter_token}    ${parcel_id}
    #validate the parcel and change parcel status to drop-off recipient
    Validating the parcel and changing the parcel status into drop-off recipient    ${counter_token}    ${parcel_id}    ${monies}
    #Creating the return group
    ${group_id}=     Create the return group for the parcel    ${counter_token}    ${Courier_id}
    #getting the parcel id using group id
    Getting the parcel id using the group id    ${counter_token}    ${group_id}
    #validating the parcel and changing the parcel status into returned
    Validating the return parcel and changing the status to returned    ${counter_token}    ${parcel_id}    ${monies}