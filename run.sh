echo "Decoding config file..."

echo $GENESIS_JSON > genesis.b64

base64 -d genesis.b64 > genesis.json

echo "Starting geth..."

cat genesis.json

geth init --datadir data genesis.json

sh -c "geth -- $GETH_ARGS"
