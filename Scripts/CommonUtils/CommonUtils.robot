*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    json
Library    String
Library    DateTime
Library    OperatingSystem
Library    BuiltIn
Library    Process

*** Variables ***
# Delivery Driver
${Delivery_driver_id}    039cbfea-712e-4bb1-9371-94c0c8efa95a
${Delivery_driver_Phone_number}     +886-7485962314
${Delivery_driver_email}     dart@yh.com
${Courier_id}       09eb60e7-50fc-48ab-af6a-3c89dc40b683
${Courier_name}     ontime

# Kanguro point
${Kanguro_point_id}             21c5161a-413b-4466-8190-11e18140c7c3
${Counter_id}                   fc9120f0-fdb2-4342-9cdc-1cabbd8d8046
${Counter_email}                williow@th.com
${Counter_phone_number}         +886-522448965
${Original_address}             Av. Diagonal, 661-671, Les Corts, 08028 Barcelona, Spain
${Existing_accout_id}           aef0a99a-b5c2-4276-b598-cd7991c9675b
${KP_address}     Av. Diagonal, 609, Les Corts, España 08028, Barcelona, España 08028, Barcelona
${Zip_code}     08015
${City}         Spain
${Province}     Barcelona
${Latitude}     41.37938673493241
${Longitute}    2.154531768174992
${Pin}          123456

# Recipient
${Recipient_ID}                 07bc1483-331f-4995-8180-d1967df6f3cb
${Recipient_name}               david
${Recipient_phone_number}       +886-22448966497
${Recipient_email}              davidben@yh.com

# Admin
${Admin_email}      test@kanguro.com
${Admin_password}       password

${Derivation_KP_ID}             17e49272-ae2b-4fc9-99ec-833c5dbdc3bf
${Derivation_KP_Phone_number}       +886-748965896
${Derivation_Counter_ID}            57f0ae6d-e3e7-4d8e-aef4-1e180d253934

${Assign_verification_code}          1234

#Postal code
${Postal_code}   08021

#Email
${LENGTH}    8

#Back office variables
${Existing_Counter_name}        Willow wood automation counter

