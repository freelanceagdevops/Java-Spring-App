FROM openjdk:18
WORKDIR /app
COPY ./target/spring-app-0.0.1-SNAPSHOT.jar /app
EXPOSE 8080
CMD ["java", "-jar", "spring-app-0.0.1-SNAPSHOT.jar"] 
