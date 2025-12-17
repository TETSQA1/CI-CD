*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the multiple parcels is delivered to the counter by courier
    [Tags]     Deliver_courier_multiple_parcels
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=  Create multiple parcels by driver using recipient    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcel id
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${Recipient_Phone_number}
    #Getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #changing the parcel status
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}

Verify that the multiple parcels with the pin is delivered to the counter by courier
    [Tags]     Deliver_courier_multiple_parcels_with_pin
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=  Create multiple parcels by driver using recipient with pin    ${driver_token}  ${recipient_id}  ${recipient_name}  ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcel id
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${Recipient_Phone_number}
    #Getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #changing the parcel status
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}

Verify that the multiple parcels with the monies is delivered to the counter by courier
    [Tags]     Delivered_courier_multiple_parcels_with_monies
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=  Create multiple parcels by driver using recipient with monies   ${driver_token}  ${recipient_id}  ${recipient_name}  ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcel id
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${Recipient_Phone_number}
    #Getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #changing the parcel status
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}

Verify that the multiple parcels with the pin and monies is delivered to the counter by courier
    [Tags]     Deliver_courier_multiple_parcels_with_pin_and_monies
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating multiple parcels
    ${parcel_id_1}  ${parcel_id_2}=  Create multiple parcels by driver using recipient with Pin and monies   ${driver_token}  ${recipient_id}  ${recipient_name}  ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #getting the parcel id
    Get multiple parcels ids    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${Recipient_Phone_number}
    #Getting parcel monies details
    ${monies_1}    ${monies_2}=  Getting multiple parcels monies details    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}
    #changing the parcel status
    Validating the multiple parcel and changing the parcels status into drop-off    ${counter_token}    ${parcel_id_1}    ${parcel_id_2}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}    ${monies_1}    ${monies_2}