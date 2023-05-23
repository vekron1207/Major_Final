#!/bin/bash
# Script to install chaincode onto a peer node
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.233.129:7003
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/user.auth.com/peers/peer1.user.auth.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=user-auth-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/user.auth.com/users/Admin@user.auth.com/msp
cd /go/src/github.com/chaincode/samplecc


if [ ! -f "samplecc_go_1.0.tar.gz" ]; then
  cd go
  GO111MODULE=on
  go mod vendor
  cd -
  peer lifecycle chaincode package samplecc_go_1.0.tar.gz \
    -p /go/src/github.com/chaincode/samplecc/go/ \
    --lang golang --label samplecc_1.0
fi

peer lifecycle chaincode install samplecc_go_1.0.tar.gz
