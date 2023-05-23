#!/bin/bash
# Script to join a peer to a channel
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.233.129:7003
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/user.auth.com/peers/peer1.user.auth.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=user-auth-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/user.auth.com/users/Admin@user.auth.com/msp
export ORDERER_ADDRESS=192.168.233.129:7007
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/auth.com/orderers/orderer2.auth.com/tls/ca.crt
if [ ! -f "authchannel.genesis.block" ]; then
  peer channel fetch oldest -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA \
  --tls -c authchannel /vars/authchannel.genesis.block
fi

peer channel join -b /vars/authchannel.genesis.block \
  -o $ORDERER_ADDRESS --cafile $ORDERER_TLS_CA --tls
