// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSignatureWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public requiredConfirmations;
    
    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint confirmations;
    }
    
    Transaction[] public transactions;

    event Deposit(address indexed sender, uint value, uint indexed transactionId);
    event SubmitTransaction(address indexed owner, uint indexed transactionId, address indexed to, uint value, bytes data);
    event ConfirmTransaction(address indexed owner, uint indexed transactionId);
    event ExecuteTransaction(address indexed owner, uint indexed transactionId);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier transactionExists(uint transactionId) {
        require(transactionId < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint transactionId) {
        require(!transactions[transactionId].executed, "Transaction already executed");
        _;
    }

    constructor(address[] memory _owners, uint _requiredConfirmations) {
        require(_owners.length > 0, "Owners required");
        require(_requiredConfirmations > 0 && _requiredConfirmations <= _owners.length, "Invalid number of required confirmations");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Duplicate owner");
            owners.push(owner);
            isOwner[owner] = true;
        }

        requiredConfirmations = _requiredConfirmations;
    }

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value, transactions.length);
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint transactionId = transactions.length;
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
        }));
        emit SubmitTransaction(msg.sender, transactionId, _to, _value, _data);
    }

    function confirmTransaction(uint _transactionId) public onlyOwner transactionExists(_transactionId) notExecuted(_transactionId) {
        Transaction storage transaction = transactions[_transactionId];
        transaction.confirmations++;
        emit ConfirmTransaction(msg.sender, _transactionId);

        if (transaction.confirmations >= requiredConfirmations) {
            executeTransaction(_transactionId);
        }
    }

function executeTransaction(uint _transactionId) public onlyOwner transactionExists(_transactionId) notExecuted(_transactionId) {
    Transaction storage transaction = transactions[_transactionId];
    require(transaction.confirmations >= requiredConfirmations, "Not enough confirmations");
    
    (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
    
    require(success, "Transaction execution failed");
    transaction.executed = true;
    
    emit ExecuteTransaction(msg.sender, _transactionId);
}



    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }
}
