FROM maven:3.8.5-openjdk-17-slim AS build

# WORKDIR /usr/src/app

# COPY pom.xml /usr/src/app/
# COPY ./src/test/java /usr/src/app/src/test/java

# CMD [mvn test]

# on terminal run: "docker build -t karatetest"
# on terminal run: "docker run -it karatetest"