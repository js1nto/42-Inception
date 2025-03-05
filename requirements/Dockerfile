FROM debian:latest

RUN apt update && apt upgrade && apt install -y \
	nginx

# Expose the HTTP port
EXPOSE 80

# Start NGINX when the container runss
CMD ['nginx', "-g", "daemon off;"]
