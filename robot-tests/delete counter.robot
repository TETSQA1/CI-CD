*** Settings ***
Resource    Delete_config.robot

*** Test Cases ***
Delete the counter user from back office (no.of times)
    FOR    ${index}    IN RANGE    1    ${TIMES}+1
    ${Admin_token}=     Login into the back office
    ${user_phone}=  Getting the counter users list    ${Admin_token}
    Deleting the user    ${user_phone}  ${Admin_token}
    END