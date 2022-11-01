FROM adoptopenjdk/openjdk11:alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
VOLUME /tmp
ARG JAR_FILE
ADD ${JAR_FILE} /usr/app/app.jar
COPY ./application.properties /usr/app/
ENTRYPOINT ["java","-jar","/usr/app/app.jar", "--spring.config.location=/usr/app/application.properties"]