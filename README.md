# Authenti-Kator-2.0, fabric-firebase-logger, and productAuth 

## Table of Contents

- [Overview](#overview)
- [Authenti-Kator-2.0](#authenti-kator-20)
- [fabric-firebase-logger](#fabric-firebase-logger)
- [productAuth](#productauth)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Overview
This repository contains three inter-related applications namely Authenti-Kator-2.0, fabric-firebase-logger, and productAuth, aimed at providing authentication and logging services for products. 

## Authenti-Kator-2.0
Authenti-Kator-2.0 is an Android application that allows users to scan QR codes and authenticate the products. The application offers login and signup functionality which are implemented using Firebase DB for storing user credentials.

## fabric-firebase-logger
fabric-firebase-logger is an application that listens for changes in the Firebase DB, particularly the change in product status (isAuthenticated). The DB structure is as follows:

```json
"product_1": {
    "isAuthenticated": false,
    "product_type": "sneakers",
    "serial_number": 116708,
    "authenticated_by": null,
    "authenticated_at": null
}
```

Whenever there is a change detected in the DB, it triggers the `createProduct` method in the chain code.

## productAuth
productAuth is a logging system designed to log the changes of DB in the Hyperledger Fabric. It utilizes chain code to track and log these changes into the Hyperledger Explorer.

## Getting Started
Details on how to use these applications will be provided soon.

## Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated. Here are the steps to contribute:

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.
