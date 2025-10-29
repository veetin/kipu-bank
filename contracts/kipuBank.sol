// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract kipuBank {
        
    address immutable internal owner;
    uint256 immutable internal deposit_limit;
    uint256 immutable internal transaction_limit;

    mapping(address => uint256) internal balances;

    uint256 internal counter_deposit;
    uint256 internal counter_withdraw;
    
    bool locked;

    error NotZeroValue();
    error TransactionLimitReached();
    error DepositLimitReached();
    error NotAuthorized();
    error InsufficientBalance();
    error AddressNotZero();


    event Deposit(address indexed addr, uint256 amount);
    event Withdraw(address indexed addr, uint256 amount);


    modifier nonReentrant(){
        if (locked){
            revert NotAuthorized();
        }
        locked = true;
        _;
        locked = false;

    }

    modifier AmountNotZero(uint256 _amount){
        if (_amount == 0) {
            revert NotZeroValue();
        }
        _;
    }

    modifier MaxTransactionLimitVerify() {
        if (msg.value > transaction_limit){
            revert TransactionLimitReached();
        }
        _;
    }

    modifier MaxDepositLimitVerify() {
        if (address(this).balance > deposit_limit){
            revert DepositLimitReached();
        }
        _;
    }

    modifier AddressNotZeroVerify(address addr) {
        if (addr == address(0)){
            revert AddressNotZero();
        }
        _;
    }

    modifier BalanceCheck(uint256 _amount) {
        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance();
        }
        _;
    }

    constructor(uint256 _deposit_limit, uint256 _transaction_limit) {
        owner = msg.sender;
        deposit_limit = _deposit_limit * 1e18;
        transaction_limit = _transaction_limit * 1e18;
    }

    function deposit() external payable AmountNotZero(msg.value)
        nonReentrant
        MaxTransactionLimitVerify
        MaxDepositLimitVerify {
        
        balances[msg.sender] += msg.value;
        counter_deposit += 1;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public
        nonReentrant
        AddressNotZeroVerify(msg.sender)
        AmountNotZero(_amount)
        BalanceCheck(_amount) {
        
        balances[msg.sender] -= _amount;
        counter_withdraw += 1;
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount);
    }

    function get_owner() public view returns (address) {
        return owner;
    }

    function get_balance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function get_deposit_limit() public view returns (uint256) {
        return deposit_limit;
    }
    
    function get_transaction_limit() public view returns (uint256) {
        return transaction_limit;
    }

    function get_counter_withdraw() public view returns (uint256) {
        return counter_withdraw;
    }

    function get_counter_deposit() public view returns (uint256) {
        return counter_deposit;
    }

}