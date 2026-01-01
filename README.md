# Bank SOAP Service

## Overview
A SOAP Web Service using Apache CXF and Spring Boot.
Refactored by **Youssef Bahaddou**.

## Features
- **JAX-WS**: Java API for XML Web Services.
- **Apache CXF**: Integrated with Spring Boot.
- **WSDL Generation**: Auto-generated service description.

## Endpoints
- **WSDL**: \http://localhost:8080/services/BankService?wsdl\

## Operations
- \getBankAccount(id)\
- \listAccounts()\
- \createAccount(balance, type)\

## Run
\\\ash
mvn spring-boot:run
\\\

## Author
Youssef Bahaddou

