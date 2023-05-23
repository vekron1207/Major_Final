#!/bin/bash
# Script to create channel block 0 and then create channel
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars
configtxgen -profile OrgChannel \
  -outputCreateChannelTx authchannel.tx -channelID authchannel

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.233.129:7002
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/peers/peer1.manufacturer.auth.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=manufacturer-auth-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/users/Admin@manufacturer.auth.com/msp
export ORDERER_ADDRESS=192.168.233.129:7007
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/auth.com/orderers/orderer2.auth.com/tls/ca.crt
peer channel create -c authchannel -f authchannel.tx -o $ORDERER_ADDRESS \
  --cafile $ORDERER_TLS_CA --tls
