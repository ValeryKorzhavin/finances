FROM java:8-jre
MAINTAINER Valery Korzhavin <korzhavin.valery@gmail.com>

COPY ./target/*.jar /app/gateway.jar
CMD ["java", "-Xmx200m", "-jar", "/app/gateway.jar"]

