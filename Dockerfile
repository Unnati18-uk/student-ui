# ---- Stage 1: Build ----
FROM amazonlinux as builder

# Install dependencies
RUN yum update -y && \
    yum install -y java-11-amazon-corretto-devel.x86_64 maven

# Set working directory inside the container
WORKDIR /student-ui

# Copy project files
COPY . /student-ui

# Build application (Creates the .war file in 'target' directory)
RUN mvn clean package

# ---- Stage 2: Deploy ----
FROM tomcat:latest

# Copy built artifact from builder stage to Tomcat webapps directory
COPY --from=builder /student-ui/target/*.war /usr/local/tomcat/webapps/

# Expose port 8080 (default Tomcat port)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
