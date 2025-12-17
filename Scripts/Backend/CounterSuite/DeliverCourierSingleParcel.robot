*** Settings ***
Library    Collections
Resource    ../../resources/BackendUtils/Admin.robot
Resource    ../../resources/BackendUtils/driver.robot
Resource    ../../resources/BackendUtils/recipient.robot
Resource    ../../resources/BackendUtils/counter.robot
Resource    ../../Resources/BackendUtils/BackendAuth.robot

*** Test Cases ***
Verify that the single parcel is deliver to the counter by courier
    [Tags]    Deliver_courier_single_parcel
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}  ${EAN2}=   Create Parcel By Driver using recipient   ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}

Verify that the single parcel with a pin is delivered to the counter by courier
    [Tags]    Deliver_courier_single_parcel_with_pin
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}=   Create Parcel By Driver using recipient with pin    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}

Verify that the single parcel with the monies is delivered to the counter by courier
    [Tags]    Deliver_courier_single_parcel_with_monies
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}=   Create Parcel By Driver using recipient with monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}

Verify that the single parcel with the pin and monies is delivered to the counter by courier
    [Tags]    Deliver_courier_single_parcel_with_pin_and_monies
    #Admin login
    ${Admin_token}=     Login as admin backend
    #Driver login
    ${requestId}=    Login As Driver
    ${driver_token}=    Login As Driver Second Step    ${requestId}
    #Creating a new parcel
    ${parcel_id}   ${EAN}=   Create Parcel By Driver using recipient with pin and monies    ${driver_token}    ${recipient_id}    ${recipient_name}    ${recipient_phone_number}
    #Counter login
    ${requestId}=   Login As Counter first step    ${Counter_phone_number}
    ${counter_token}=   Login As Counter Second Step    ${requestId}
    #Getting the parcels by id
    Get Parcel By Id    ${counter_token}    ${parcel_id}    ${Delivery_driver_Phone_number}    ${recipient_phone_number}
    #Updating the parcel status to drop-off
    Validating the parcel and changing the parcel status into drop-off    ${counter_token}    ${parcel_id}