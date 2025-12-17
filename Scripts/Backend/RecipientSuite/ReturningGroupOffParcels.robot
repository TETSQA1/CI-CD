*** Settings ***
Library     Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot
Resource    ../../Resources/BackendUtils/LabellessReturn.robot
Resource    ../../Resources/BackendUtils/ReturnGroupOfParcels.robot

*** Test Cases ***
Verify that the recipient can return the group of parcels successfully
    [Tags]   Returning_group_of_parcels
    ${Admin_token}=     Login as admin backend
    #Login counter
    ${requestId_counter}=    Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=    Login As Counter Second Step    ${requestId_counter}
    #creating labelless sender
    ${labelless_sender}=    Creating a labelless sender    ${Admin_token}
    #Adding the labelless sender to the courier
    ${Courier_sender_id}=   Adding the labelless sender to the courier    ${Admin_token}    ${Courier_id}    ${labelless_sender}
    #create a group of labelles parcels
    ${parcel_id_1}  ${parcel_id_2}=     Creating group of label-less parcels    ${counter_token}    ${Courier_sender_id}
    #Driver login
    ${requestId_driver}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId_driver}
    #Recipient login
    ${requestId_recipient}=     Login as Recipient first step    ${Recipient_phone_number}
    ${recipient_token}=     Login As Recipient second step    ${requestId_recipient}
    #Assigning the recipient for the parcel
    Assign recipient for the group of parcels    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${recipient_id}    ${recipient_name}    ${recipient_email}
    #Assigning the EAN for the parcel
    Assigning EAN for the group of parcels    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #getting parcel monies detail
    ${monies_1}    ${monies_2}=     Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #Getting the group id by passing parcel id in create group for recipient to deliver API
    ${group_id_deliver}=    Creating group for recipient to deliver    ${driver_token}    ${parcel_id_1}    ${parcel_id_2}
    #Getting the possible actions
    Get possible actions for the group of return parcels    ${group_id_deliver}    ${counter_token}
    #Change the parcel status into dropping-recipient
    Change the parcel status into dropping-recipient    ${group_id_deliver}    ${counter_token}
    #Validating the parcels and changing parcel into drop-off recipient
    Validating multiple return group of parcels and changing parcel status into drop-off-recipient    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}
    #Creating the return group for the parcels
    ${group_id}=  Create the return group for the parcel    ${counter_token}    ${Courier_id}
    #getting the parcel id using group id
    Get the multiple parcel id using group id    ${counter_token}    ${group_id}
    #Changing the parcel status to returning
    Change the group of parcels status into returning    ${Counter_token}    ${group_id}    ${parcel_id1}    ${parcel_id2}
    #Validating the multiple parcel and changing parcel status into returned
    Validating multiple return group of parcels and changing parcel status into returned    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${monies_1}    ${monies_2}