//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "./PiggyBankFundraise.sol";

contract PiggyBankFundraiseFactory {

event ContractCreated(address _contractOwner, address _contractAddress, string _summary, uint _fundingGoal);

PiggyBankFundraise[] private piggyBankFundraiseCampaigns; 
mapping(address => uint256) private addressToIndex; 

struct contractTimeFrame {
    uint _startAt;
    uint _recoverFundsAt;
    uint _retainFundsAt; 
}

struct contractState {
    bool _recoverFundsAvailable;
    bool _retainFundsAvailable;
    uint currentTime;
}

struct availableWithdrawMethods {
    bool _recoverFundsAvailable;
    bool _retrainFundsAvailable;
}

function createPiggyBankFundraiseContract(
    uint _fundingGoalWei, 
    string memory _fundingSummary, 
    uint _getBackFundsMin, 
    uint _clearContractMin
) public {
    PiggyBankFundraise piggyBankFundraise = new PiggyBankFundraise(msg.sender,_fundingGoalWei,_fundingSummary, _getBackFundsMin,_clearContractMin);
    piggyBankFundraiseCampaigns.push(piggyBankFundraise);
    uint256 arrayIndex = piggyBankFundraiseCampaigns.length-1; 
    addressToIndex[address(piggyBankFundraise)] = arrayIndex;

    emit ContractCreated(msg.sender,address(piggyBankFundraise),_fundingSummary,_fundingGoalWei);

}

function getCurrentBlockTimestamp() public view returns (uint256){
    return block.timestamp;
}

function getAddressFromIndex(uint256 _storageIndex)
    public
    view
    returns(address)
    {
        return address(piggyBankFundraiseCampaigns[_storageIndex]);
    }

function getIndexFromAddress(address _address)
    public
    view
    returns(uint256)
    {
        return addressToIndex[_address];
    }

function contractsMade() public view returns (uint256){
    return piggyBankFundraiseCampaigns.length;
}


function callGetBalance(uint256 _storageIndex)
    public
    view
    returns(uint256)    
{
    return address(piggyBankFundraiseCampaigns[_storageIndex]).balance;
}


function amountDonatedInContract(address _client, uint _storageIndex) public view returns (uint256){
return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).addressToDonation(_client);
}

function callGetBackFunds(address _client, uint256 _storageIndex) public {
return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).getBackFunds(_client);
}

function callWithdrawAll(address _client, uint256 _storageIndex) public { 
return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).withdrawAll(_client);
}

function callDisburseFunds(address _client, uint256 _storageIndex) public {
return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).disburseFunds(_client);
}

function getContractOwner(uint256 _storageIndex) public view returns (address) {
    return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).owner();
}

function getFundingGoal(uint256 _storageIndex) public view returns (uint) {
    return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).fundingGoal();
}

function getFundingSummary(uint256 _storageIndex) public view returns (string memory){
    return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).fundingSummary();
}

function getCheckFundsWithdrawn(uint256 _storageIndex) public view returns (bool){
    return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).fundsWithdrawn();
}


function getGoldenDoner(uint256 _storageIndex) public view returns (address) {
    return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).goldenDoner();
}

function getTargetReached(uint256 _storageIndex) public view returns (bool) {
    return PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).goldenDonerSet();
}

function getContractTimeFrames(uint256 _storageIndex) public view returns(contractTimeFrame memory){

    contractTimeFrame memory timeframe = contractTimeFrame(
        PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).startAt(),
        PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).recoverFundsAt(),
        PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).retainFundsAt()
    );
    return timeframe;
}

function getAvailableWithdrawMethods(uint256 _storageIndex) public view returns (availableWithdrawMethods memory){
    availableWithdrawMethods memory withdrawMethods = availableWithdrawMethods(
        PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).isRecoverFundsAvailable(),
        PiggyBankFundraise(piggyBankFundraiseCampaigns[_storageIndex]).isRetrainFundsAvailable()
    );

    return withdrawMethods;
}


}