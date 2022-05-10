# Multi Arch Openjdk

Multi-architecture docker images for openjdk.

Sample java application dockerfile:

```dockerfile
FROM sralloza/openjdk:11-jre as build

WORKDIR /home/gradle

COPY src/ /home/gradle/src/
COPY gradle/ /home/gradle/gradle/
COPY build.gradle settings.gradle gradlew /home/gradle/

RUN ./gradlew build
RUN ./gradlew test --scan
RUN ./gradlew fat -i

FROM sralloza/openjdk:11-jre

RUN mkdir /app

COPY --from=build /home/gradle/build/libs/*.jar /app/app.jar

ENTRYPOINT [ "java", "-jar", "/app/app.jar" ]
```

Note: to create a fat jar, add this gradle task to your build.gradle:

```groovy
task fatJar(type: Jar) {
    duplicatesStrategy = DuplicatesStrategy.INCLUDE
    exclude 'META-INF/*.RSA', 'META-INF/*.SF', 'META-INF/*.DSA'

    manifest {
        attributes 'Main-Class': mainClassName
    }

    from { configurations.compileClasspath.collect { it.isDirectory() ? it : zipTree(it) } }
    with jar
}
```
