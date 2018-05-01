#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

SOURCEDIR=`grep ^SOURCEDIR= settings.txt | sed "s/^.*=//"`

CROWDSALESOL=`grep ^CROWDSALESOL= settings.txt | sed "s/^.*=//"`
CROWDSALEJS=`grep ^CROWDSALEJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`
JSONSUMMARY=`grep ^JSONSUMMARY= settings.txt | sed "s/^.*=//"`
JSONEVENTS=`grep ^JSONEVENTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

START_DATE=`echo "$CURRENTTIME+45" | bc`
START_DATE_S=`date -r $START_DATE -u`
END_DATE=`echo "$CURRENTTIME+60*2" | bc`
END_DATE_S=`date -r $END_DATE -u`

printf "MODE               = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT    = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD           = '$PASSWORD'\n" | tee -a $TEST1OUTPUT
printf "SOURCEDIR          = '$SOURCEDIR'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALESOL       = '$CROWDSALESOL'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALEJS        = '$CROWDSALEJS'\n" | tee -a $TEST1OUTPUT
printf "DEPLOYMENTDATA     = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS          = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT        = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS       = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT
printf "JSONSUMMARY        = '$JSONSUMMARY'\n" | tee -a $TEST1OUTPUT
printf "JSONEVENTS         = '$JSONEVENTS'\n" | tee -a $TEST1OUTPUT
printf "CURRENTTIME        = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "START_DATE         = '$START_DATE' '$START_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "END_DATE           = '$END_DATE' '$END_DATE_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
`cp $SOURCEDIR/$CROWDSALESOL .`

`perl -pi -e "s/require\( TOKEN_PRESALE_CAP\.mul\(BONUS\) \/ 100 \=\= MAX_BONUS_TOKENS \);/\/\/ require\( TOKEN_PRESALE_CAP\.mul\(BONUS\) \/ 100 \=\= MAX_BONUS_TOKENS \);/" $CROWDSALESOL`


DIFFS1=`diff $SOURCEDIR/$CROWDSALESOL $CROWDSALESOL`
echo "--- Differences $SOURCEDIR/$CROWDSALESOL $CROWDSALESOL ---" | tee -a $TEST1OUTPUT
echo "$DIFFS1" | tee -a $TEST1OUTPUT

solc_0.4.23 --version | tee -a $TEST1OUTPUT

echo "var saleOutput=`solc_0.4.23 --optimize --pretty-json --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS

exit;

geth --verbosity 3 attach $GETHATTACHPOINT << EOF1 | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:EnergisToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:EnergisToken"].bin;

console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
console.log("DATA: tokenBin=" + JSON.stringify(tokenBin));

unlockAccounts("$PASSWORD");
// printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTokenMessage = "Deploy Token";
// -----------------------------------------------------------------------------
console.log("RESULT: " + deployTokenMessage);
var tokenContract = web3.eth.contract(tokenAbi);
var tokenTx = null;
var tokenAddress = null;
var currentBlock = eth.blockNumber;
var token = tokenContract.new({from: contractOwnerAccount, data: tokenBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token");
        console.log("DATA: tokenAddress=" + tokenAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(tokenTx, deployTokenMessage);
printTxData("tokenTx", tokenTx);
printTokenContractDetails();
console.log("RESULT: ");

EOF1

grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA

TOKENADDRESS=`grep ^tokenAddress= $DEPLOYMENTDATA | sed "s/^.*=//"`

# --- Modify parameters ---
`perl -pi -e "s/START_DATE \= 1522749798;.*$/START_DATE = $START_DATE; \/\/ $START_DATE_S/" $CROWDSALESOL`
`perl -pi -e "s/FUNDS_WALLET \= address\(0\);.*$/FUNDS_WALLET \= 0xa22AB8A9D641CE77e06D98b7D7065d324D3d6976;/" $CROWDSALESOL`
`perl -pi -e "s/TOKEN_WALLET \= address\(0\);.*$/TOKEN_WALLET \= 0xa11AAE29840fBb5c86E6fd4cF809EBA183AEf433;/" $CROWDSALESOL`
`perl -pi -e "s/TOKEN_ADDRESS \= address\(0\);.*$/TOKEN_ADDRESS \= $TOKENADDRESS;/" $CROWDSALESOL`

DIFFS1=`diff $CROWDSALESOURCEDIR/$CROWDSALESOL $CROWDSALESOL`
echo "--- Differences $CROWDSALESOURCEDIR/$CROWDSALESOL $CROWDSALESOL ---" | tee -a $TEST1OUTPUT
echo "$DIFFS1" | tee -a $TEST1OUTPUT

echo "var crowdsaleOutput=`solc_0.4.21 --optimize --pretty-json --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS

geth --verbosity 3 attach $GETHATTACHPOINT << EOF2 | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("$CROWDSALEJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:EnergisToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:EnergisToken"].bin;
var crowdsaleAbi = JSON.parse(crowdsaleOutput.contracts["$CROWDSALESOL:PrivatePreSale"].abi);
var crowdsaleBin = "0x" + crowdsaleOutput.contracts["$CROWDSALESOL:PrivatePreSale"].bin;

console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
console.log("DATA: tokenBin=" + JSON.stringify(tokenBin));
console.log("DATA: crowdsaleAbi=" + JSON.stringify(crowdsaleAbi));
console.log("DATA: crowdsaleBin=" + JSON.stringify(crowdsaleBin));


unlockAccounts("$PASSWORD");
var tokenAddress = "$TOKENADDRESS";
var token = eth.contract(tokenAbi).at(tokenAddress);
addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var crowdsaleMessage = "Deploy Crowdsale Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: " + crowdsaleMessage);
var crowdsaleContract = web3.eth.contract(crowdsaleAbi);
var crowdsaleTx = null;
var crowdsaleAddress = null;
var crowdsale = crowdsaleContract.new({from: contractOwnerAccount, data: crowdsaleBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        crowdsaleTx = contract.transactionHash;
      } else {
        crowdsaleAddress = contract.address;
        addAccount(crowdsaleAddress, "Energis Private PreSale");
        addCrowdsaleContractAddressAndAbi(crowdsaleAddress, crowdsaleAbi);
        console.log("DATA: crowdsaleAddress=" + crowdsaleAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(crowdsaleTx, crowdsaleMessage);
printTxData("crowdsaleAddress=" + crowdsaleAddress, crowdsaleTx);
printCrowdsaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var approveTokensForSale_Message = "Approve Tokens For Sale";
var tokensForSale = "4000000000000000000000000";
// -----------------------------------------------------------------------------
console.log("RESULT: " + approveTokensForSale_Message);
var transferToAirdropper_1Tx = token.approve(crowdsaleAddress, tokensForSale, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(transferToAirdropper_1Tx, transferToAirdropper_1Tx + " - ac1 approve sale 4m");
printTxData("transferToAirdropper_1Tx", transferToAirdropper_1Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var whitelist_Message = "Whitelist Addresses";
// -----------------------------------------------------------------------------
console.log("RESULT: " + whitelist_Message);
var whitelist_1Tx = crowdsale.addToWhitelist(account3, {from: contractOwnerAccount, gas: 100000, gasPrice: defaultGasPrice});
var whitelist_2Tx = crowdsale.addToWhitelist(account4, {from: contractOwnerAccount, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whitelist_1Tx, whitelist_Message + " - crowdsale.addToWhitelist(account3)");
failIfTxStatusError(whitelist_2Tx, whitelist_Message + " - crowdsale.addToWhitelist(account4)");
printTxData("whitelist_1Tx", whitelist_1Tx);
printTxData("whitelist_2Tx", whitelist_2Tx);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("START_DATE", crowdsale.START_DATE(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
while (txpool.status.pending > 0) {
}
var sendContribution1_5Tx = eth.sendTransaction({from: account4, to: crowdsaleAddress, gas: 400000, value: web3.toWei("20", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 10 ETH");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 10 ETH");
passIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - ac5 10 ETH - Expecting failure as not whitelisted");
passIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - ac6 10 ETH- Expecting failure as not whitelisted");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 20 ETH");
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
printTxData("sendContribution1_5Tx", sendContribution1_5Tx);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var closeSale_Message = "Close Sale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + closeSale_Message);
var closeSale_1Tx = crowdsale.closeSale({from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(closeSale_1Tx, closeSale_Message);
printTxData("closeSale_1Tx", closeSale_1Tx);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var transfer1_Message = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + transfer1_Message);
var transfer1_1Tx = token.transfer(account7, "1000000000000", {from: account3, gas: 100000, gasPrice: defaultGasPrice});
var transfer1_2Tx = token.approve(account8,  "30000000000000000", {from: account4, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var transfer1_3Tx = token.transferFrom(account4, account9, "30000000000000000", {from: account8, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transfer1_1Tx", transfer1_1Tx);
printTxData("transfer1_2Tx", transfer1_2Tx);
printTxData("transfer1_3Tx", transfer1_3Tx);
failIfTxStatusError(transfer1_1Tx, transfer1_Message + " - transfer 0.000001 tokens ac3 -> ac7. CHECK for movement");
failIfTxStatusError(transfer1_2Tx, transfer1_Message + " - approve 0.03 tokens ac4 -> ac8");
failIfTxStatusError(transfer1_3Tx, transfer1_Message + " - transferFrom 0.03 tokens ac4 -> ac9 by ac8. CHECK for movement");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var burnTokens_Message = "Burn Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + burnTokens_Message);
var burnTokens_1Tx = token.burn("200000000000000", {from: account3, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("burnTokens_1Tx", burnTokens_1Tx);
failIfTxStatusError(burnTokens_1Tx, burnTokens_Message + " - ac3 burn 0.0002 tokens");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


EOF2
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
# grep "JSONSUMMARY: " $TEST1OUTPUT | sed "s/JSONSUMMARY: //" > $JSONSUMMARY
# cat $JSONSUMMARY
