FROM debian:latest

# Install OpenSSL to configure TLS settings (if not already included)
RUN apk add --no-cache openssl

RUN apt update && apt upgrade && apt install -y \
	nginx

# Expose the HTTP port
EXPOSE 80

# Start NGINX when the container runss
CMD ['nginx', "-g", "daemon off;"]
