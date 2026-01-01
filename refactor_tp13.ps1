$projectPath = "C:\DEV\Lechgar\DrissLechgarRepo\SeleniumScripts\downloads\TP-13 ( id 166 )\TP-13-Web-Service-SOAP-avec-JAX-WS-et-Spring-Boot-main"
$srcMainJava = "$projectPath\src\main\java"
$oldPackagePath = "$srcMainJava\com\example\demo\tp13"
$newPackagePath = "$srcMainJava\com\youssef\soap\service"

# 1. Create New Package Structure
New-Item -ItemType Directory -Force -Path "$newPackagePath\model" | Out-Null
New-Item -ItemType Directory -Force -Path "$newPackagePath\repository" | Out-Null
New-Item -ItemType Directory -Force -Path "$newPackagePath\webservice" | Out-Null
New-Item -ItemType Directory -Force -Path "$newPackagePath\config" | Out-Null

# 2. Move and Rename Core Files
# Main App
if (Test-Path "$oldPackagePath\Tp13Application.java") {
    Move-Item "$oldPackagePath\Tp13Application.java" "$newPackagePath\BankSoapApplication.java" -Force
}

# Entities
if (Test-Path "$oldPackagePath\entities\Compte.java") {
    Move-Item "$oldPackagePath\entities\Compte.java" "$newPackagePath\model\BankAccount.java" -Force
}
# Move any other entities
Get-ChildItem "$oldPackagePath\entities" -Filter "*.java" | Where-Object {$_.Name -ne "Compte.java"} | ForEach-Object {
    Move-Item $_.FullName "$newPackagePath\model" -Force
}

# Repositories
if (Test-Path "$oldPackagePath\repositories\CompteRepository.java") {
    Move-Item "$oldPackagePath\repositories\CompteRepository.java" "$newPackagePath\repository\BankAccountRepository.java" -Force
}

# Web Service Code (SEI and Impl)
if (Test-Path "$oldPackagePath\ws") {
    Get-ChildItem "$oldPackagePath\ws" -Filter "*.java" | ForEach-Object {
        $newName = $_.Name.Replace("Banque", "Bank").Replace("Service", "Service") # Normalize
        Move-Item $_.FullName "$newPackagePath\webservice\$newName" -Force
    }
}

# Config
if (Test-Path "$oldPackagePath\config") {
     Get-ChildItem "$oldPackagePath\config" -Filter "*.java" | ForEach-Object {
        Move-Item $_.FullName "$newPackagePath\config" -Force
    }
}

# 3. Remove Old Directories
Remove-Item "$srcMainJava\com\example" -Recurse -Force -ErrorAction SilentlyContinue

# 4. Content Replacement
$filesToUpdate = Get-ChildItem -Path "$newPackagePath" -Recurse -Filter "*.java"

foreach ($file in $filesToUpdate) {
    $content = Get-Content $file.FullName -Raw

    # Package Declarations
    $content = $content -replace "package com.example.demo.tp13;", "package com.youssef.soap.service;"
    $content = $content -replace "package com.example.demo.tp13.entities;", "package com.youssef.soap.service.model;"
    $content = $content -replace "package com.example.demo.tp13.repositories;", "package com.youssef.soap.service.repository;"
    $content = $content -replace "package com.example.demo.tp13.ws;", "package com.youssef.soap.service.webservice;"
    $content = $content -replace "package com.example.demo.tp13.config;", "package com.youssef.soap.service.config;"

    # Imports
    $content = $content -replace "import com.example.demo.tp13.entities.Compte;", "import com.youssef.soap.service.model.BankAccount;"
    $content = $content -replace "import com.example.demo.tp13.repositories.CompteRepository;", "import com.youssef.soap.service.repository.BankAccountRepository;"
    $content = $content -replace "import com.example.demo.tp13.ws.*;", "import com.youssef.soap.service.webservice.*;"

    # Class & Interface Renaming
    $content = $content -replace "Tp13Application", "BankSoapApplication"
    $content = $content -replace "BanqueService", "BankService"
    $content = $content -replace "BanqueSoapService", "BankService" # Fix inconsistency if existed
    $content = $content -replace "CompteRepository", "BankAccountRepository"
    $content = $content -replace "Compte", "BankAccount"
    
    # Variable Naming (French -> English)
    $content = $content -replace "solde", "balance"
    $content = $content -replace "dateCreation", "creationDate"
    $content = $content -replace "getCompte", "getBankAccount"
    $content = $content -replace "compte", "account"

    # Spring/CXF Annotations updates (if implicit naming was used)
    $content = $content -replace 'serviceName = "BanqueWS"', 'serviceName = "BankService"'
    $content = $content -replace 'portName = "BanqueServicePort"', 'portName = "BankServicePort"'

    Set-Content -Path $file.FullName -Value $content
    
    # Rename file if content changed mapping inside file but not filename (e.g. BanqueSoapService -> BankServiceImpl)
    if ($file.Name -eq "BanqueService.java") { Rename-Item $file.FullName "BankService.java" }
    if ($file.Name -eq "BanqueSoapService.java") { Rename-Item $file.FullName "BankServiceImpl.java" }
}

# 5. Update POM
$pomPath = "$projectPath\pom.xml"
if (Test-Path $pomPath) {
    (Get-Content $pomPath) -replace "com.example.demo", "com.youssef.soap" `
                           -replace "TP13", "bank-soap-service" `
                           -replace "<name>TP13</name>", "<name>Bank SOAP Service</name>" | Set-Content $pomPath
}

# 6. Create README
$readmeContent = "# Bank SOAP Service

## Overview
A SOAP Web Service using Apache CXF and Spring Boot.
Refactored by **Youssef Bahaddou**.

## Features
- **JAX-WS**: Java API for XML Web Services.
- **Apache CXF**: Integrated with Spring Boot.
- **WSDL Generation**: Auto-generated service description.

## Endpoints
- **WSDL**: \`http://localhost:8080/services/BankService?wsdl\`

## Operations
- \`getBankAccount(id)\`
- \`listAccounts()\`
- \`createAccount(balance, type)\`

## Run
\`\`\`bash
mvn spring-boot:run
\`\`\`

## Author
Youssef Bahaddou
"
Set-Content -Path "$projectPath\README.md" -Value $readmeContent

Write-Host "TP-13 Refactoring Complete!"
