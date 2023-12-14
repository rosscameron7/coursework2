# Use an official Node.js runtime as a base image
FROM node:14

# Set the working directory in the container
WORKDIR /home/ubuntu/coursework2

# Copy the application files to the working directory
COPY server.js ./

# Expose the port on which your app will run
EXPOSE 8080

# Define the command to run your application
CMD ["node", "server.js"]
