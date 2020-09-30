package ru.valerykorzh.finances.account.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.valerykorzh.finances.account.domain.Account;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {

}

