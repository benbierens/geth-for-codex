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
ACCOUNTSTR=$(echo $ACCOUNTSTR | cut -d '{' -f 2 | cut -d '}' -f 1)
echo "0x"$ACCOUNTSTR > account_string.txt

BOOTSTRAP_ARGS=""
if [ -n "$IS_BOOTSTRAP" ]; then
    # update genesis.json
    sed -i "s/ACCOUNT_HERE/$ACCOUNTSTR/g" genesis.json
    BOOTSTRAP_ARGS="--mine --miner.etherbase 0x$ACCOUNTSTR"
fi

echo "Intializing geth..."
geth init genesis.json

echo "Starting geth..."
geth --networkid 789988 --http --http.addr 0.0.0.0 --allow-insecure-unlock --http.vhosts '*' --unlock "0x$ACCOUNTSTR" $BOOTSTRAP_ARGS $GETH_ARGS < passwordfile
