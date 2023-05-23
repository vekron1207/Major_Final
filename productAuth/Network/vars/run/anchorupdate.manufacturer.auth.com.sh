#!/bin/bash
# Script to instantiate chaincode
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=192.168.233.129:7002
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/peers/peer1.manufacturer.auth.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=manufacturer-auth-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/manufacturer.auth.com/users/Admin@manufacturer.auth.com/msp
export ORDERER_ADDRESS=192.168.233.129:7006
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/auth.com/orderers/orderer1.auth.com/tls/ca.crt

# 1. Fetch the channel configuration
peer channel fetch config config_block.pb -o $ORDERER_ADDRESS \
  --cafile $ORDERER_TLS_CA --tls -c authchannel

# 2. Translate the configuration into json format
configtxlator proto_decode --input config_block.pb --type common.Block \
  | jq .data.data[0].payload.data.config > authchannel_current_config.json
echo "--<<-->>--"

# 3. Update the current config in json with the organization anchor peer we want to add
jq '.channel_group.groups.Application.groups."manufacturer-auth-com".values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "192.168.233.129","port": 7002}]},"version": "0"}}' authchannel_current_config.json > authchannel_modified_anchor_config.json

# 4. Translate the current config in json format to protobuf format
configtxlator proto_encode --input authchannel_current_config.json \
  --type common.Config --output config.pb

# 5. Translate the desired config in json format to protobuf format
configtxlator proto_encode --input authchannel_modified_anchor_config.json \
  --type common.Config --output modified_config.pb

# 6. Calculate the delta of the current config and desired config
configtxlator compute_update --channel_id authchannel \
  --original config.pb --updated modified_config.pb \
  --output authchannel_anchor_update.pb

# 7. Decode the delta of the config to json format
configtxlator proto_decode --input authchannel_anchor_update.pb \
  --type common.ConfigUpdate | jq . > authchannel_anchor_update.json

# 8. Now wrap of the delta config to fabric envelop block
echo '{"payload":{"header":{"channel_header":{"channel_id":"authchannel", "type":2}},"data":{"config_update":'$(cat authchannel_anchor_update.json)'}}}' | jq . > authchannel_anchor_update_envelope.json

# 9. Encode the json format into protobuf format
configtxlator proto_encode --input authchannel_anchor_update_envelope.json \
  --type common.Envelope --output authchannel_anchor_update_envelope.pb

# 10. Need to sign anchor update envelop by org admin
peer channel update -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA \
  -f authchannel_anchor_update_envelope.pb -c authchannel
