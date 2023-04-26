unzip -qq extract.zip

if [ -n "$IS_BOOTSTRAP" ]; then
    echo "Starting bootstrap geth..."
    cat passwordsource >> passwordfile
    ACCOUNTSTR="68554188b8dcb8fb51fe35301cb0dc985e8ae8d6"
    echo "0x"$ACCOUNTSTR > account_string.txt
    BOOTSTRAP_ARGS="--mine --miner.etherbase 0x$ACCOUNTSTR"
    sh extract_privatekey.sh
    geth --networkid 789988 --http --http.addr 0.0.0.0 --allow-insecure-unlock --http.vhosts '*' --unlock "0x$ACCOUNTSTR" --password passwordfile $BOOTSTRAP_ARGS $GETH_ARGS
    exit 0
fi

echo "Starting companion geth..."
rm -Rf /root/.ethereum

# Create passwordfile
for i in $(seq 1 $NUMBER_OF_ACCOUNTS);
do
    cat passwordsource >> passwordfile
done

# Create accounts, extract keys
UNLOCKSTR=""
for i in $(seq 1 $NUMBER_OF_ACCOUNTS);
do
    echo "Creating account #"$i
    geth account new --password passwordfile --keystore key_$i

    ACCOUNTSTR=$(geth account list --keystore key_$i)
    ACCOUNTSTR=$(echo $ACCOUNTSTR | cut -d '{' -f 2 | cut -d '}' -f 1)
    echo "0x"$ACCOUNTSTR > account_string_$i.txt

    sh extract_privatekey.sh /key_$i /private_$i.key
    UNLOCKSTR="$UNLOCKSTR 0x$ACCOUNTSTR,"
done

# Move keys to geth keystore
mkdir /root/.ethereum/keystore/
for i in $(seq 1 $NUMBER_OF_ACCOUNTS);
do
    cp key_$i/* /root/.ethereum/keystore/
done

# Go go go!
echo "Intializing geth..."
geth init genesis.json
geth --networkid 789988 --http --http.addr 0.0.0.0 --allow-insecure-unlock --http.vhosts '*' --unlock "$UNLOCKSTR" --password passwordfile $GETH_ARGS
