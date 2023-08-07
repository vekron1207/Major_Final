# Secured Authentication System for Product Verification: Integrating Blockchain and Secure Data Management

## Flow Diagram

![FlowDiagram (2)](https://github.com/AmritaCSN/ProductAuth_VarunKashyap/assets/43084249/d64edfc7-5951-4336-a5d8-1f3089fd7e8d)

## Ntwork Diagram

![Network](https://github.com/AmritaCSN/Secured-Authentication-System-for-Product-Verification_VarunKashyap/assets/43084249/9e2ab2d6-8dd7-4f5a-98aa-deffbef064e1)



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

# Getting Started

Follow the instructions below to set up the Android app.

## Prerequisites

Ensure you have the following installed on your local development machine:

- [Android Studio](https://developer.android.com/studio/index.html) (version 3.x or above)
- [Java JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) (version 11 or above)
- [Android SDK](https://developer.android.com/studio/intro/update#sdk-manager) (API 21 or above)

## Setting Up the Android Application

1. **Clone the repository:** Clone the Android app repository to your local machine.

2. **Open the project in Android Studio:** Launch Android Studio, and from the **Welcome to Android Studio** window, select **Open an existing Android Studio project**. Navigate to the cloned repository and select it.

3. **Sync Gradle:** After the project has opened in Android Studio, sync the project with gradle by clicking on `Sync Project with Gradle Files` in the toolbar or from the `File` menu.

4. **Build the project:** Once Gradle sync is finished, build the project by selecting `Build -> Make Project` from the menu.

5. **Run the app:** Connect your Android device or open your desired emulator. Then, click on the green play button, or `Run -> Run 'app'`, to start the application.

Follow the instructions below to set up the prodAuth environment and listener app.

## Setting Up the prodAuth Environment

1. Create a `startNetwork.sh` file and put the following code into it:

```bash
#!/bin/bash

echo "Bootstraping..."
minifab netup -s couchdb -e true -o manufacturer.auth.com
sleep 10
echo "Channel Creation..."
minifab create -c authchannel
sleep 10
echo "Channel Joining"
minifab join -c authchannel
sleep 10
echo "Anchor Update"
minifab anchorupdate
sleep 10
echo "Profile Creation..."
minifab profilegen -c authchannel
```

2. Install your chaincode:

```bash
./minifab install -n your_chaincode_name -v 1.0 -l node -p ./chaincode/your_chaincode_name
```

3. Approve, commit, and initialize your chaincode:

```bash
./minifab approve,commit,initialize -n your_chaincode_name -v 1.0 -l node -p ./chaincode/your_chaincode_name
```

4. Invoke a function from your chaincode:

```bash
./minifab invoke -n your_chaincode_name -t your_function_name -p '[arg1,arg2,arg3]'
```

## Setting Up the Listener App

1. Create the fabric-firebase-logger directory:

```bash
mkdir fabric-firebase-logger
cd fabric-firebase-logger
```

2. Initialize the npm project and install the necessary dependencies:

```bash
npm init -y
npm install --save firebase-admin fabric-network
```

Your project directory should look like this:

```plaintext
fabric-firebase-logger
├── node_modules
├── package.json
└── app.js
```

3. Start the app:

```bash
node app.js
```

## Workflow
1. Node.js app starts up and begins listening for changes in Firebase, specifically the "isAuthenticated" field.
2. When the "isAuthenticated" field changes to true in Firebase, the Node.js app detects this change.
3. The Node.js app then calls the **`createProduct`** function on the chaincode, passing the appropriate product data.
4. The chaincode executes the **`createProduct`** function which creates a new transaction on the blockchain, effectively logging the product authentication in the ledger.

It's important to note that the chaincode and the Firebase listener are two separate components, both orchestrated by the Node.js application. The chaincode is only responsible for managing the state of the blockchain (i.e., creating and reading transactions), while the Firebase listener is responsible for detecting changes in the external database and triggering the appropriate actions in response.

In other words, the chaincode is not actively "listening" for changes; instead, it is invoked by the Node.js application when a relevant change is detected in Firebase.


## Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated. Here are the steps to contribute:

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.
