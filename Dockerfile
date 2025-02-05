# Use the latest LTS version of Node.js based on Alpine for a lightweight build environment
FROM node:lts-alpine as build

 # Copy all files from the current directory to the /build directory in the container
COPY . /build

# Set the working directory to /build for subsequent commands
WORKDIR /build

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies and build the application
RUN npm install && npm run build

# Use Nginx 1.27 based on Alpine for serving the built application
FROM nginx:1.27-alpine

# Add metadata labels for organization and author information
LABEL org="qtdevops" author="venkat"

# Create a non-root user with a home directory and shell
ARG USERNAME=venkat

# Create a non-root user with a home directory and shell
RUN adduser -D -h /build -s /bin/sh ${USERNAME}

# switch the default user to current user
USER ${USERNAME}

# Copy built files from the previous stage and set ownership
COPY --from=build --chown=${USERNAME}:${USERNAME} /build/dist /usr/share/nginx/html


# Optional step to include a custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for incoming traffic to the Nginx server
EXPOSE 80

# Start Nginx in the foreground to keep the container running
CMD [ "nginx", "-g", "daemon off;" ]
