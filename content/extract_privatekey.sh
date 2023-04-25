echo "Extracting private key..."

unzip -qq extract.zip

cd extract
node extract_privatekey.js

echo "Done!"