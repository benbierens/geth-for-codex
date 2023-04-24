echo "Extracting private key..."

mkdir extract
cp *.js extract
cd extract

npm install web3
node extract_privatekey.js

echo "Done!"