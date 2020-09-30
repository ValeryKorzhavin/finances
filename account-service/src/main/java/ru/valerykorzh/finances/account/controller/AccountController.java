package ru.valerykorzh.finances.account.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.valerykorzh.finances.account.client.AuthClient;
import ru.valerykorzh.finances.account.domain.Account;
import ru.valerykorzh.finances.account.service.AccountService;

import java.util.List;

@AllArgsConstructor
@RestController
@RequestMapping(value = "/accounts", produces = MediaType.APPLICATION_JSON_VALUE)
public class AccountController {

    private final AccountService accountService;

    private final AuthClient authClient;

    @GetMapping
    public List<Account> findAll() {
        return accountService.findAll();
    }

    @GetMapping("/{id}")
    public Account findById(@PathVariable("id") Long id) {
        return accountService.findById(id)
                .orElseThrow(() -> new RuntimeException(String.format("User with id: %d not found", id)));
    }

    @PostMapping
    public void saveAccount(@RequestBody Account account) {
        accountService.save(account);
    }

    @GetMapping("/auth")
    public String invokeAuth() {
        authClient.invokeAuth();
        return "Auth module was called!";
    }
}


