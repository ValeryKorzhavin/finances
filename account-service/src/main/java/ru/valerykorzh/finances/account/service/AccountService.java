package ru.valerykorzh.finances.account.service;

import ru.valerykorzh.finances.account.domain.Account;

import java.util.List;
import java.util.Optional;

public interface AccountService {

    List<Account> findAll();

    void delete(Long id);

    void save(Account account);

    Optional<Account> findById(Long id);

}
