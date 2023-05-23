const { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const fs = require('fs');
const admin = require('firebase-admin');
const serviceAccount = require('./db_service_account.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://authenti-kator2-default-rtdb.firebaseio.com/'
});

const db = admin.database();
const ref = db.ref('Nike_DB');

ref.on('child_changed', async (snapshot) => {
    const productKey = snapshot.key;
    const product = snapshot.val();
    
    if (product.isAuthenticated === true) {
        // Send transaction to Hyperledger Fabric
        await sendTransaction(productKey, product);
    }
});

async function sendTransaction(productKey, product) {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, '..', 'test-network', 'organizations', 'peerOrganizations', 'org1.example.com', 'connection-org1.json');
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const identity = await wallet.get('appUser');
        if (!identity) {
            console.log('An identity for the user "appUser" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: 'appUser', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('productAuth');

        // Submit the specified transaction.
        await contract.submitTransaction('createProduct', productKey, JSON.stringify(product));
        console.log(`Transaction has been submitted for product ${productKey}`);

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction for product ${productKey}: ${error}`);
        process.exit(1);
    }
}