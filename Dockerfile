FROM openjdk

VOLUME /tmp
ADD maven/demo-0.0.2-SNAPSHOT.jar demo-0.0.2-SNAPSHOT.jar
RUN sh -c 'touch /demo-0.0.2-SNAPSHOT.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/demo-0.0.2-SNAPSHOT.jar"]
