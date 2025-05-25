*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}      chrome
${URL}      %{URL}
${USER}     %{USER}
${PASS}     %{PASS}

*** Test Cases ***
User Can Register
    Open Browser To Start
    Go To    ${URL}=register.php
    Run Keyword    Register New User
    [Teardown]    Close Browser

User Can Login
    Open Browser To Start
    Go To    ${URL}=login.php
    Run Keyword    Login To Mutillidae
    [Teardown]    Close Browser

*** Keywords ***
Open Browser To Start
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --ignore-certificate-errors
    Open Browser    about:blank    ${BROWSER}    options=${options}

Register New User
    Input Text    name=username    ${USER}
    Input Text    name=password    ${PASS}
    Input Text    name=confirm_password    ${PASS}
    Input Text    name=firstname    security
    Input Text    name=lastname    science
    Input Text    name=my_signature    securityscience
    Click Button    name=register-php-submit-button
    Wait Until Page Contains   inserted    timeout=10s

Login To Mutillidae
    Input Text    name=username    ${USER}
    Input Text    name=password    ${PASS}
    Click Button    name=login-php-submit-button
    Wait Until Page Contains    Logout    timeout=10s
