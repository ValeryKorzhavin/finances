FROM java:8-jre
MAINTAINER Valery Korzhavin <korzhavin.valery@gmail.com>

COPY ./target/*.jar /app/auth-service.jar
CMD ["java", "-Xmx200m", "-jar", "/app/auth-service.jar"]
