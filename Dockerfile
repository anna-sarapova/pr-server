# Use the official gradle image to create a build artifact.
# https://hub.docker.com/_/gradle
FROM gradle:7.2 as builder

# Copy local code to the container image.
COPY build.gradle.kts .
COPY src ./src

# Build a release artifact.
RUN gradle build -x test --no-daemon --stacktrace

#CMD ["tail", "-f", "/dev/null"]

# Use the Official OpenJDK image for a lean production stage of our multi-stage build.
# https://hub.docker.com/_/openjdk
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM adoptopenjdk/openjdk11:ubi

# Copy the jar to the production image from the builder stage.\
COPY --from=builder /home/gradle/build/libs/gradle-0.0.1-SNAPSHOT.jar /dininghall.jar

# Run the web service on container startup.
CMD [ "java", "-jar", "-Djava.security.egd=file:/dev/./urandom", "/dininghall.jar" ]