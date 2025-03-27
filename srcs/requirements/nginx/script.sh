#If you don’t already have SSL certificates, you can generate a self-signed certificate using OpenSSL.
openssl req -newkey rsa:2048 -nodes -keyout nginx.key -x509 -out nginx.crt -days 365

# Build the Docker image using the following command:
docker build -t nginx-tls3 .

# Get the current working directory
current_path=$(pwd)

# Now, run the container, making sure to map the certificate files properly:
docker run -d \
  -p 443:443 \
  -v $(current_path)/to/nginx.crt:/secrets/ssl/certs/nginx.crt \
  -v $(current_path)/to/nginx.key:/secrets/ssl/private/nginx.key \
  nginx-tls3


# Verify TLS 1.3 Support (on 127.0.0.1 loopback IPv4)
# -> curl -Iv https://127.0.0.1 --tlsv1.3
