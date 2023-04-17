if [ -n "$IS_BOOTSTRAP" ]; then
    echo "Starting bootstrap geth..."
    ACCOUNTSTR="68554188b8dcb8fb51fe35301cb0dc985e8ae8d6"
    BOOTSTRAP_ARGS="--mine --miner.etherbase 0x$ACCOUNTSTR"
    geth --networkid 789988 --http --http.addr 0.0.0.0 --allow-insecure-unlock --http.vhosts '*' --unlock "0x$ACCOUNTSTR" $BOOTSTRAP_ARGS $GETH_ARGS < passwordfile
    exit 0
fi

echo "Starting companion geth..."
rm -Rf root/.ethereum

geth account new --password passwordfile

ACCOUNTSTR=$(geth account list)
ACCOUNTSTR=$(echo $ACCOUNTSTR | cut -d '{' -f 2 | cut -d '}' -f 1)
echo "0x"$ACCOUNTSTR > account_string.txt

echo "Intializing geth..."
geth init genesis.json
geth --networkid 789988 --http --http.addr 0.0.0.0 --allow-insecure-unlock --http.vhosts '*' --unlock "0x$ACCOUNTSTR" $GETH_ARGS < passwordfile
