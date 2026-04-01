# Change the first line to this:
FROM tomcat:10.1-jdk21-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*
COPY web/ /usr/local/tomcat/webapps/ROOT/
EXPOSE 8080
CMD ["catalina.sh", "run"]
