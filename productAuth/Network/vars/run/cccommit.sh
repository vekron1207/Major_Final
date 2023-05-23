#!/bin/bash
# Script to instantiate chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.233.129:7002
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/peers/peer1.manufacturer.auth.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=manufacturer-auth-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/users/Admin@manufacturer.auth.com/msp
export ORDERER_ADDRESS=192.168.233.129:7006
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/auth.com/orderers/orderer1.auth.com/tls/ca.crt
SID=$(peer lifecycle chaincode querycommitted -C authchannel -O json \
  | jq -r '.chaincode_definitions|.[]|select(.name=="samplecc")|.sequence' || true)

if [[ -z $SID ]]; then
  SEQUENCE=1
else
  SEQUENCE=$((1+$SID))
fi

peer lifecycle chaincode commit -o $ORDERER_ADDRESS --channelID authchannel \
  --name samplecc --version 1.0 --sequence $SEQUENCE \
  --peerAddresses 192.168.233.129:7002 \
  --tlsRootCertFiles /vars/keyfiles/peerOrganizations/manufacturer.auth.com/peers/peer1.manufacturer.auth.com/tls/ca.crt \
  --peerAddresses 192.168.233.129:7003 \
  --tlsRootCertFiles /vars/keyfiles/peerOrganizations/user.auth.com/peers/peer1.user.auth.com/tls/ca.crt \
  --init-required \
  --cafile $ORDERER_TLS_CA --tls
