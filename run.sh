if [ -f "genesis.json" ]; then
    echo "Container was already started and cannot be restarted."
    exit 1
fi

echo "Decoding genesis file..."
echo $GENESIS_JSON > genesis.b64
base64 -d genesis.b64 > genesis.json

# create account
geth account new --password passwordfile

ACCOUNTSTR=$(geth account list)
ACCOUNTSTR="0x"$(echo $ACCOUNTSTR | cut -d '{' -f 2 | cut -d '}' -f 1)

if [ -n "$IS_BOOTSTRAP" ]; then
    # update genesis.json
    sed -i "s/ACCOUNT_HERE/$ACCOUNTSTR/g" genesis.json
fi

# echo "Intializing geth..."
# geth init --datadir data genesis.json

# echo "Starting geth..."
# geth $GETH_ARGS
# --networkid=???
