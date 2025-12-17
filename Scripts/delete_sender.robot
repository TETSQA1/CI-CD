*** Settings ***
Resource    Delete_config.robot

*** Test Cases ***
Delete the sender (no.of times)
    FOR    ${index}    IN RANGE    1    ${TIMES}+1
    ${Admin_token}=
    ${sender_id}=
    Deleting the sender    ${sender_id}    ${Admin_token}
    END