###############################
# Stage 1: Build with Gradle
###############################
FROM gradle:8.7-jdk21 AS builder

WORKDIR /app

# 소스 전체 복사
COPY . .

# Gradle Wrapper 실행 권한 부여
RUN chmod +x gradlew

# Spring Boot Jar 빌드
RUN ./gradlew clean bootJar --no-daemon


###############################
# Stage 2: Run with JRE
###############################
FROM eclipse-temurin:21-jre

WORKDIR /app

# Builder 단계에서 만든 JAR 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# 포트 개방
EXPOSE 9090

# 앱 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
