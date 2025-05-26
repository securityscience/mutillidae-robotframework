## Mutillidae Robot Framework Automation

This project provides an automated test suite using **Robot Framework** and **Selenium** to interact with a **Mutillidae** web application. It also includes a **Dockerized** environment, allowing to run the tests cleanly and consistently on any machine.


## Project Overview

- **Tests**: Basic registration and login functionality tests against Mutillidae.
- **Frameworks Used**: Robot Framework + SeleniumLibrary.
- **Containerization**: All tools and dependencies are bundled inside a Docker image.
- **Flexibility**: Supports passing different Mutillidae server addresses, users, and passwords via environment variables.

This project is primarily designed for [Sec-Sci AutoPT](https://www.security-science.com/sec-sci-autopt) security testing simulation, CI pipelines, and hands-on automation practice.


## Prerequisites

Before starting, make sure following are in placed:

- [Docker](https://www.docker.com/get-started) installed on the system.
- Access to a running instance of the **Mutillidae** web application (e.g., on a local VM, internal network, or cloud).
  - Install [Mutillidae](https://www.security-science.com/ethical-hacking/owasp-mutillidae-ii) if needed. 
- (Optional) [Python](https://www.python.org/) installed and `pip install robotframework` if aiming to run tests manually without Docker.


## Running Tests Locally (Without Docker)

It can be run the tests directly on local machine:

```bash
robot --variable URL:http://<Mutillidae-IP-Address>/index.php?page --variable USER:<username> --variable PASS:<password> test_cases/register_then_login.robot
```

**Example:**

```bash
robot --variable URL:http://192.168.1.11/index.php?page --variable USER:user1 --variable PASS:pass1 test_cases/register_then_login.robot
```

- `URL`: The base URL pointing to Mutillidae instance, ending with `index.php?page`.
- `USER`: The username to register/login.
- `PASS`: The password to register/login.


## Building the Docker Image

To build the Docker image that contains everything:

```bash
docker build -t mutillidae-robotframework:local .
```

This command will:
- Pull the official `python:3.11-slim` image.
- Install Robot Framework and SeleniumLibrary.
- Copy test scripts inside the image.
- Add and Trust a Burp Suite CA certificate (optional, for intercepting HTTPS traffic).


## Pull From Docker Hub

The pre-built docker image can be pulled from [Docker Hub](https://hub.docker.com/r/securityscience/mutillidae-robotframework) using the following command.

```bash
docker pull securityscience/mutillidae-robotframework:latest
```

## Running the Docker Container

There are two ways to run the Docker container depending on how to pass environment variables.

### Method 1: Pass Environment Variables Inline (-e flags)

```bash
docker run --rm \
  -e URL="http://<Mutillidae-IP-Address>/index.php?page" \
  -e USER="<username>" \
  -e PASS="<password>" \
  mutillidae-robotframework:local
```

or

```bash
docker run --rm \
  -e URL="http://<Mutillidae-IP-Address>/index.php?page" \
  -e USER="<username>" \
  -e PASS="<password>" \
  securityscience/mutillidae-robotframework:latest
```

Example:

```bash
docker run --rm \
  -e URL="http://192.168.1.11/index.php?page" \
  -e USER="user1" \
  -e PASS="pass1" \
  mutillidae-robotframework:local
```

or

```bash
docker run --rm \
  -e URL="http://192.168.1.11/index.php?page" \
  -e USER="user1" \
  -e PASS="pass1" \
  securityscience/mutillidae-robotframework:latest
```

### Method 2: Using an `.env` File

1. Create a `.env` file (e.g., `mutillidae.env`):

   ```
   URL=http://<Mutillidae-IP-Address>/index.php?page
   USER=user1
   PASS=pass1
   ```

2. Then run:

   ```bash
   docker run --rm --env-file mutillidae-dkr.env mutillidae-robotframework:local
   ```
   
   or
   
   ```bash
   docker run --rm --env-file mutillidae-dkr.env securityscience/mutillidae-robotframework:latest
   ```
   
Using an `.env` file is much cleaner, especially when dealing with multiple test environments.


## Example `.env` File

```
URL=http://192.168.1.11/index.php?page
USER=user1
PASS=pass1
```

**Important:**  
- Do not add quotes `"` in the `.env` file unless explicitly needed.
- Make sure the URL ends with `page`, without a trailing `=` or anything extra.


## Project Structure

```
.
├── Dockerfile
├── test_cases/
│   └── register_then_login.robot
├── burp_cacert.crt  (optional)
├── README.md
├── requirements.txt
└── mutillidae-dkr.env   (optional)
```


## Additional Notes

- **Registration Test**: The Robot Framework test waits for the text **inserted** to appear after registration to confirm success.
- **Login Test**: The Robot Framework test waits for the text **Logout** to appear after login to confirm success.
- If using **Burp Suite** to intercept traffic:
  - Ensure the container trusts the Burp CA cert.
  - Interception rules should not block redirects or modify server responses.

## Troubleshooting

Here are some common issues and their solutions:

| Problem | Possible Cause | Suggested Fix                                                                            |
|:-------|:---------------|:-----------------------------------------------------------------------------------------|
| **Test passes even if page is wrong** | The text wait check is too weak, or Burp intercepted page contents | Add stricter checks (e.g., validate page title or response status).                      |
| **Test fails after login when using Burp proxy** | Burp may delay or alter redirects (302) | Disable interception temporarily after login, or ensure the Burp certificate is trusted. |
| **Error: "Could not find element"** | Page is not fully loaded before interaction | Add explicit `Wait Until Element Is Visible` or increase timeout.                        |
| **SSL errors in container** | Burp Suite CA not properly installed | Ensure Burp cert is copied and `update-ca-certificates` is run inside Dockerfile.        |
| **Timeout waiting for page contents** | Mutillidae server slow or Burp delaying responses | Increase the `timeout` value in `Wait Until Page Contains`.                              |
| **Wrong ChromeDriver version** | Selenium requires the ChromeDriver to match Chrome version exactly | Use the correct `selenium/standalone-chrome` tag matching with the Chrome version.       |


## Summary

This setup provides a lightweight, fast, and flexible way to automate security lab setups like Mutillidae. With a fully Dockerized environment, consistent results across machines are guaranteed — whether testing manually, integrating into CI/CD, or setting up training labs.

**Note**: If using BurpSuite or intercepting traffic, be careful with SSL/TLS and redirects!


## Penetration Testing Simulation for Sec-Sci AutoPT

These RobotFramework is designed to simulate penetration testing using [Sec-Sci AutoPT](https://www.security-science.com/sec-sci-autopt), an automated penetration testing framework.


## Support

If encounter issues, bugs or suggestions:

- Submit an [Issue](https://github.com/securityscience/Mutillidae-RobotFramework/issues)
- Contact: [RnD@security-science.com](mailto:RnD@security-science.com)
- Or [https://www.security-science.com/contact](https://www.security-science.com/contact)