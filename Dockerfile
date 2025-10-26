FROM nginx:alpine

# Copy React build folder into nginx directory
COPY build/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
