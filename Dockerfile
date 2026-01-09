# Stage 1: Build the application using Maven and OpenJDK 17
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run the application using Tomcat 9 (compatible with Java 17)
FROM tomcat:9.0-jdk17-openjdk-slim
# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the built WAR file to Tomcat's webapps folder as ROOT.war
# (This makes your app accessible at the root URL / instead of /Univent)
COPY --from=build /app/target/Univent-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]