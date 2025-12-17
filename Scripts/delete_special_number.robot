*** Settings ***
Resource    Delete_config.robot

*** Variables ***
${search_key}      +886

*** Test Cases ***
Delete the special number in backoffice (no.of times)
    Opening the browser and navigate to URL
    Login into the back office
    Click configuration side menu
    Click special telephone option
    FOR    ${index}    IN RANGE    1    ${TIMES}+1
    Click advanced filter option
    Click column drop-down in filter
    Click phone option in the column
    Enter the search key    ${search_key}
    Click apply filter button locator
    Deleting the special phone numbers
    END
    Close Browser

Delete special phones by API
    ${Admin_token}=  Admin login
    FOR    ${index}    IN RANGE    1    ${TIMES}+1
    ${special_phone_id}=    Getting special phone list via API    ${Admin_token}
    Delete special schedule    ${Admin_token}    ${special_phone_id}
    END