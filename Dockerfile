FROM selenium/standalone-chrome:latest

USER root

# Install necessary packages for handling certificates
RUN apt-get update && apt-get install -y ca-certificates curl

# Copy Burp Suite CA certificate to the container
COPY burp_cacert.crt /usr/local/share/ca-certificates/burp_cacert.crt

# Update the list of trusted certificates
RUN update-ca-certificates

# Install Robot Framework and Selenium Library
RUN pip install robotframework robotframework-seleniumlibrary

WORKDIR /tests

COPY . /tests

CMD ["robot", "--outputdir", "results", "test_cases/register_then_login.robot"]