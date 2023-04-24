const web3 = require('web3')
const fs = require('fs');
var Accounts = require('web3-eth-accounts');
var accounts = new Accounts('ws://localhost:8081');

const readFile = (file, onContent) => {
    console.log("read file: " + file);
    fs.readFile(file, 'utf8', (err, data) => {
        console.log("reading...");
        if (err) {
          console.log(err);
          return;
        }
        console.log("data: " + data);
        onContent(data);
    });
}

const getJson = (onJson) => {
    const keystore = "/root/.ethereum/keystore/";
    console.log("read dir: " + keystore);
    fs.readdir(keystore, (err, files) => {
        if (err) {
            console.log(err);
            return;
        }
        files.forEach(file => {
            if (file.startsWith("UTC"))
            {
                console.log("found: " + file);
                readFile(keystore + file, onJson);
            }
        });
    });
}

const decode = (json,pass) =>{
    let output = accounts.decrypt(json,pass);
    return output;
}

readFile("/passwordfile", content => {
    const pass = content
        .replace("\n", "")
        .replace("\r", "");
        
    console.log("pass: '" + pass + "'");
    getJson(json => {
        const parsed = JSON.parse(json)
        console.log("json: '" + parsed + "'");
        const result = decode(parsed, pass);
    
        fs.writeFile('/private.key', result.privateKey, err => {
            if (err) {
              console.log(err);
            }
        });
    });    
});
