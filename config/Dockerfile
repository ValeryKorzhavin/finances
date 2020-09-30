FROM java:8-jre
MAINTAINER Valery Korzhavin <korzhavin.valery@gmail.com>

COPY ./target/*.jar /app/config.jar
CMD ["java", "-Xmx200m", "-jar", "/app/config.jar"]

