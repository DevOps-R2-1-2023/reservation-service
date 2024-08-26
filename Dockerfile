# Base image with Maven and JDK 21 Temurin
FROM eclipse-temurin:21-jdk as build

# Set working directory
WORKDIR /home/reservation-service

# Copy Maven wrapper
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

# Copy the source code
COPY src ./src

# Build the project
RUN ./mvnw package -DskipTests

# Using Eclipse Temurin JDK 21 for the runtime
FROM eclipse-temurin:21-jre

# Set the deployment directory
WORKDIR /app

# Copy the built JAR from the previous stage
COPY --from=build /home/reservation-service/target/reservation-service-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port
EXPOSE 8082

# Define the entry point
ENTRYPOINT ["java", "-Xms256m", "-Xmx3072m", "-jar", "app.jar"]