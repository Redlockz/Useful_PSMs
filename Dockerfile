# Use the official PowerShell image as base
FROM mcr.microsoft.com/powershell:latest

# Install additional tools if needed
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository from GitHub
RUN git clone https://github.com/Redlockz/Useful_PSMs.git /tmp/Useful_PSMs

# Copy the contents of the repository into the image
RUN cp -r /tmp/Useful_PSMs/* /root/

# Set the default command to execute when the container starts
CMD [ "pwsh" ]
