#the image set is the penultime stable version of debian
FROM	debian:bullseye

#the args that are needed from the .env file
ARG		DOMAIN_NAME
ARG		CERTS_CRT
ARG		CERTS_KEY

#updates the package lists
RUN		apt-get update && apt-get upgrade -y && \
		apt-get install -y nginx openssl gettext-base && \
		rm -rf /var/lib/apt/lists/*

# Create SSL certificate folder
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate (for development)
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=42/ST=SP/L=SP/O=Global Security/OU=Inception/CN=$DOMAIN_NAME"

#the only port availabe according to the subject
EXPOSE	443

# Copy Nginx configuration
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

#nginx config folder
RUN		mkdir -p /run/nginx

#The CMD instruction specifies the default command to run when the container is started
CMD		["nginx", "-g", "daemon off;"]


# -------------------------------------
# ✅ Step 1: Select Base Image
# -------------------------------------

# Use the second-latest stable version of Debian (bullseye)
# This ensures stability and long-term support.
FROM debian:bullseye

# -------------------------------------
# ✅ Step 2: Define Build-Time Variables (Passed from .env File)
# -------------------------------------

# These variables allow us to pass the domain name and SSL certificate paths dynamically.
ARG DOMAIN_NAME
ARG CERTS_CRT
ARG CERTS_KEY

# -------------------------------------
# ✅ Step 3: Install Required Packages
# -------------------------------------

# - `apt-get update && apt-get upgrade -y` → Updates system package lists and upgrades existing packages.
# - `nginx` → Installs the Nginx web server.
# - `openssl` → Used to generate SSL certificates.
# - `gettext-base` → Utility for handling environment variables in configuration files.
# - `rm -rf /var/lib/apt/lists/*` → Cleans up package cache to reduce image size.
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl gettext-base && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------------
# ✅ Step 4: Set Up SSL Certificates
# -------------------------------------

# Create a directory to store SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate a self-signed SSL certificate (valid for 1 year)
# - `-newkey rsa:4096` → Creates a new RSA key with 4096-bit encryption.
# - `-x509 -sha256 -days 365` → Creates an X.509 certificate valid for 365 days.
# - `-nodes` → Skips password encryption (needed for automation).
# - `-out /etc/nginx/ssl/inception.crt` → Saves the certificate.
# - `-keyout /etc/nginx/ssl/inception.key` → Saves the private key.
# - `-subj "/C=42/ST=SP/L=SP/O=Global Security/OU=Inception/CN=$DOMAIN_NAME"` → Fills in certificate details.
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=42/ST=SP/L=SP/O=Global Security/OU=Inception/CN=$DOMAIN_NAME"

# -------------------------------------
# ✅ Step 5: Expose Port for HTTPS
# -------------------------------------

# Nginx listens on port 443 for secure HTTPS connections.
EXPOSE 443

# -------------------------------------
# ✅ Step 6: Copy Nginx Configuration
# -------------------------------------

# Copy the custom Nginx configuration file into the container.
# This ensures that the server is correctly set up with HTTPS and PHP handling.
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# -------------------------------------
# ✅ Step 7: Prepare Nginx for Startup
# -------------------------------------

# Create a directory for Nginx runtime files (e.g., PID files, logs).
RUN mkdir -p /run/nginx

# -------------------------------------
# ✅ Step 8: Start Nginx When Container Runs
# -------------------------------------

# CMD defines the default command that runs when the container starts.
# `nginx -g "daemon off;"` keeps Nginx running in the foreground so Docker can manage it.
CMD ["nginx", "-g", "daemon off;"]