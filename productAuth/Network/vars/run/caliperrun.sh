#!/bin/sh
# Script to query blocks
rm -rf /hyperledger/caliper/workspace/caliper.log

# npx install --only=prod @hyperledger/caliper-cli@0.4.0

# npx caliper bind --caliper-bind-sut fabric:2.1.0

npx caliper launch manager --caliper-workspace ./ \
  --caliper-bind-sut fabric:2.1.0 \
  --caliper-flow-only-test --caliper-fabric-gateway-enabled \
  --caliper-fabric-gateway-discovery \
  --caliper-fabric-gateway-localhost false

