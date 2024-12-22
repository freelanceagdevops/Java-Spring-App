package com.example.docker.spring_app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SpringAppApplication {

    @GetMapping("/")
    public String home() {
        return "Dockerizing Spring Boot Application";
    }

    @GetMapping("/login")
    public String login() {
        return "<h1>This is where you will see the login page</h1>";
    }

    public static void main(String[] args) {
        SpringApplication.run(SpringAppApplication.class, args);
    }
}
