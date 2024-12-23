package com.example.docker.spring_app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Main application class for the Spring Boot application.
 * <p>
 * This class is responsible for running the Spring Boot application
 * and contains REST endpoints for the home page and login page.
 * </p>
 */
@SpringBootApplication
@RestController
public class SpringAppApplication {

    /**
     * Handles GET requests to the root URL ("/").
     * <p>
     * This method returns a simple string message indicating that the
     * application has been Dockerized.
     * </p>
     * 
     * @return A string message "Dockerizing Spring Boot Application".
     */
    @GetMapping("/")
    public final String home() {
        return "Dockerizing Spring Boot Application";
    }

    /**
     * Handles GET requests to the "/login" URL.
     * <p>
     * This method returns a simple HTML string that represents the
     * login page placeholder.
     * </p>
     * 
     * @return A string containing HTML for a login page placeholder.
     */
    @GetMapping("/login")
    public final String login() {
        return "<h1>This is where you will see the login page</h1>";
    }

    /**
     * Main entry point for the Spring Boot application.
     * <p>
     * This method starts the Spring Boot application.
     * </p>
     * 
     * @param args Command-line arguments passed to the application.
     */
    public static void main(final String[] args) {
        SpringApplication.run(SpringAppApplication.class, args);
    }
}
