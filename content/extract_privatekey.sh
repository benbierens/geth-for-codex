echo "Extracting private key..."

cd extract
node extract_privatekey.js $1 $2

echo "Done: "$2
