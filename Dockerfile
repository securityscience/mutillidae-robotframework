FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget curl unzip gnupg ca-certificates \
    fonts-liberation libnss3 libxss1 libappindicator3-1 \
    libatk-bridge2.0-0 libgtk-3-0 libgbm-dev libasound2 libx11-xcb1 \
    chromium chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# Set chrome and chromedriver aliases
ENV CHROME_BIN=/usr/bin/chromium
ENV CHROMEDRIVER=/usr/lib/chromium/chromedriver
ENV ROBOT_BROWSER=chrome

# Install robotframework and selenium
RUN pip install --no-cache-dir robotframework selenium robotframework-seleniumlibrary

# Copy test files
COPY . /tests/
WORKDIR /tests/

# Default command (can be overridden)
CMD ["robot", "--outputdir", "results", "test_cases/register_then_login.robot"]
