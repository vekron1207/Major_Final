#!/bin/bash
cd $FABRIC_CFG_PATH
# cryptogen generate --config crypto-config.yaml --output keyfiles
configtxgen -profile OrdererGenesis -outputBlock genesis.block -channelID systemchannel

configtxgen -printOrg manufacturer-auth-com > JoinRequest_manufacturer-auth-com.json
configtxgen -printOrg user-auth-com > JoinRequest_user-auth-com.json
