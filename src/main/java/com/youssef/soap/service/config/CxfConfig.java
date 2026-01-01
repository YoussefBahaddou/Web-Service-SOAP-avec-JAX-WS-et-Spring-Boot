package com.youssef.soap.service.config;

import com.youssef.soap.service.webservice.*;
import lombok.AllArgsConstructor;
import org.apache.cxf.Bus;
import org.apache.cxf.jaxws.EndpointImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@AllArgsConstructor
public class CxfConfig {

    private BankAccountSoapService BankAccountSoapService;
    private Bus bus;

    @Bean
    public EndpointImpl endpoint() {
        EndpointImpl endpoint = new EndpointImpl(bus, BankAccountSoapService);
        endpoint.publish("/ws");
        return endpoint;
    }
}
