
# Use lightweight Nginx image
FROM nginx:alpine

# Copy website files into Nginx directory
COPY index.html /usr/share/nginx/html/index.html

# Expose HTTP port
EXPOSE 80
