# The Logbook contract

## Set up

* Make sure you have the foundry/forge CLI tools installed with a version of >=0.2.0 (see [the docs](https://book.getfoundry.sh/) for help)
* Run `forge install` to install necessary dependencies
* Create a `.env` file like the following...
````
RINKEBY_RPC_URL="https://eth-rinkeby.alchemyapi.io/v2/<YOUR_ALCHEMY_PROJECT_ID>"
MAINNET_RPC_URL="https://eth-mainnet.alchemyapi.io/v2/<YOUR_ALCHEMY_PROJECT_ID>"
PRIVATE_KEY=<DEPLOYER_PRIVATE_KEY>
ETHERSCAN_KEY=<YOUR_ETHERSCAN_KEY>
````
* Run `source .env`
* Check the constructor args in `script/deploy.s.sol`. 

## Deploy to rinkeby

* Deploy the contract by running `forge script script/deploy.s.sol:DeployWhitehat --rpc-url $RINKEBY_RPC_URL --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_KEY -vvvv`
* Wait a minute or two, and then verify the contract on Etherscan by running `forge script script/deploy.s.sol:DeployWhitehat --rpc-url $RINKEBY_RPC_URL --private-key $PRIVATE_KEY --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv`

## Deploy to mainnet

* Deploy the contract by running `forge script script/deploy.s.sol:DeployWhitehat --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY --broadcast --etherscan-api-key $ETHERSCAN_KEY -vvvv`
* Wait a minute or two, and then verify the contract on Etherscan by running `forge script script/deploy.s.sol:DeployWhitehat --rpc-url $MAINNET_RPC_URL --private-key $PRIVATE_KEY --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv`