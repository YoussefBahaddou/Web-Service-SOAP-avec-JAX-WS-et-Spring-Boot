package com.youssef.soap.service.webservice;

import com.youssef.soap.service.model.BankAccount;
import com.example.demo.tp13.enums.TypeBankAccount;
import com.youssef.soap.service.repository.BankAccountRepository;

import jakarta.jws.WebMethod;
import jakarta.jws.WebParam;
import jakarta.jws.WebService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

@Component
@WebService(serviceName = "BankService")
public class BankAccountSoapService {

    @Autowired
    private BankAccountRepository BankAccountRepository;

    @WebMethod
    public List<BankAccount> getBankAccounts() {
        return BankAccountRepository.findAll();
    }

    @WebMethod
    public BankAccount getBankAccountById(@WebParam(name = "id") Long id) {
        return BankAccountRepository.findById(id).orElse(null);
    }

    @WebMethod
    public BankAccount createBankAccount(@WebParam(name = "balance") double balance,
                               @WebParam(name = "type") TypeBankAccount type) {
        BankAccount BankAccount = new BankAccount(null, balance, new Date(), type);
        return BankAccountRepository.save(BankAccount);
    }

    @WebMethod
    public boolean deleteBankAccount(@WebParam(name = "id") Long id) {
        if (BankAccountRepository.existsById(id)) {
            BankAccountRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
