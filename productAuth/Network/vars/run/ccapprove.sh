#!/bin/bash
# Script to approve chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.233.129:7002
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/peers/peer1.manufacturer.auth.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=manufacturer-auth-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/users/Admin@manufacturer.auth.com/msp
export ORDERER_ADDRESS=192.168.233.129:7006
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/auth.com/orderers/orderer1.auth.com/tls/ca.crt

peer lifecycle chaincode queryinstalled -O json | jq -r '.installed_chaincodes | .[] | select(.package_id|startswith("samplecc_1.0:"))' > ccstatus.json

PKID=$(jq '.package_id' ccstatus.json | xargs)
REF=$(jq '.references.authchannel' ccstatus.json)

SID=$(peer lifecycle chaincode querycommitted -C authchannel -O json \
  | jq -r '.chaincode_definitions|.[]|select(.name=="samplecc")|.sequence' || true)
if [[ -z $SID ]]; then
  SEQUENCE=1
elif [[ -z $REF ]]; then
  SEQUENCE=$SID
else
  SEQUENCE=$((1+$SID))
fi


export CORE_PEER_LOCALMSPID=manufacturer-auth-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/peers/peer1.manufacturer.auth.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/users/Admin@manufacturer.auth.com/msp
export CORE_PEER_ADDRESS=192.168.233.129:7002

# approved=$(peer lifecycle chaincode checkcommitreadiness --channelID authchannel \
#   --name samplecc --version 1.0 --init-required --sequence $SEQUENCE --tls \
#   --cafile $ORDERER_TLS_CA --output json | jq -r '.approvals.manufacturer-auth-com')

# if [[ "$approved" == "false" ]]; then
  peer lifecycle chaincode approveformyorg --channelID authchannel --name samplecc \
    --version 1.0 --package-id $PKID \
  --init-required \
    --sequence $SEQUENCE -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA
# fi

export CORE_PEER_LOCALMSPID=user-auth-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/user.auth.com/peers/peer1.user.auth.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/user.auth.com/users/Admin@user.auth.com/msp
export CORE_PEER_ADDRESS=192.168.233.129:7003

# approved=$(peer lifecycle chaincode checkcommitreadiness --channelID authchannel \
#   --name samplecc --version 1.0 --init-required --sequence $SEQUENCE --tls \
#   --cafile $ORDERER_TLS_CA --output json | jq -r '.approvals.user-auth-com')

# if [[ "$approved" == "false" ]]; then
  peer lifecycle chaincode approveformyorg --channelID authchannel --name samplecc \
    --version 1.0 --package-id $PKID \
  --init-required \
    --sequence $SEQUENCE -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA
# fi
