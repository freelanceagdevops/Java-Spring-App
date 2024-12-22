package com.example.docker.spring_app;  // Ensure this package declaration is correct

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Main entry point for the Spring Boot application.
 * This class is responsible for initializing the application and handling the main endpoints.
 * It is marked as final to prevent subclassing, as it does not need to be extended.
 */
@SpringBootApplication
@RestController
public final class SpringAppApplication {  // Marked as final to prevent subclassing

    /**
     * Home method that handles the home page logic.
     * This method returns a simple string displayed on the home page.
     * @return A string message displayed on the home page.
     */
    @RequestMapping("/")
    public String home() {
        return "Dockerizing Spring Boot Application";
    }

    /**
     * Login method that handles the login page logic.
     * This method returns an HTML string for the login page.
     * @return A string containing HTML code for the login page.
     */
    @RequestMapping("/login")
    public String login() {
        return "<h1>This is where you will see the login page</h1>";
    }

    /**
     * Main method to run the Spring Boot application.
     * This method serves as the entry point for the application.
     * @param args command-line arguments (marked as final to prevent modification).
     */
    public static void main(final String[] args) {
        SpringApplication.run(SpringAppApplication.class, args);
    }
}
