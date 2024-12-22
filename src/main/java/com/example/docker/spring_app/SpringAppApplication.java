package com.example.docker.spring_app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Main application class for the Spring Boot application.
 * This class is not designed for extension.
 */
@SpringBootApplication
@RestController
public final class SpringAppApplication { // Marked as final to prevent subclassing

    /**
     * Handles the root URL ("/") and returns a greeting message.
     * 
     * @return a greeting message
     */
    @RequestMapping("/")
    public String home() {
        return "Dockerizing Spring Boot Application";
    }

    /**
     * Handles the "/login" URL and returns a message for the login page.
     * 
     * @return a message for the login page
     */
    @RequestMapping("/login")
    public String login() {
        return "<h1>This is where you will see the login page</h1>";
    }

    public static void main(String[] args) {
        SpringApplication.run(SpringAppApplication.class, args);
    }
}
