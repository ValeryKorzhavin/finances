package ru.valerykorzh.finances.account.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@FeignClient("auth-service")
public interface AuthClient {

    @RequestMapping(method = RequestMethod.GET, value = "/auth/hello")
    void invokeAuth();
}
