package com.example.docker.spring_app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Entry point for the Spring Boot application.
 * This class serves as the main application class and contains
 * REST endpoints.
 */
@SpringBootApplication
@RestController
public final class SpringAppApplication {

    /**
     * Home endpoint.
     * Provides a message indicating the application is running.
     *
     * @return A welcome message for the home endpoint.
     */
    @GetMapping("/")
    public final String home() {
        return "Dockerizing Spring Boot Application";
    }

    /**
     * Login endpoint.
     * Displays a placeholder for the login page.
     *
     * @return A simple login page HTML message.
     */
    @GetMapping("/login")
    public final String login() {
        return "<h1>This is where you will see the login page</h1>";
    }

    /**
     * The main method, which serves as the entry point for the application.
     *
     * @param args The command-line arguments for the application.
     */
    public static void main(final String[] args) {
        SpringApplication.run(SpringAppApplication.class, args);
    }
}
