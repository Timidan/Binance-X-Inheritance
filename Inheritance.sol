pragma solidity ^0.6.0;

contract Inheritance{
    
    address public _owner;
    
    address public inheritor;
    
    uint256 public expiryTime;
    

    
    event deposited(uint _amount,uint time);
    
    event refreshed(uint time);
    
    //make sure only the owner can call the function
    modifier onlyOwner(){
        require (msg.sender==_owner,"you are not the owner");
        _;
    }
    
    //make sure only the inheritor can call the function
    modifier onlyInheritor(){
        require(msg.sender==inheritor,"you are not the inheritor");
        _;
    }
    
    //accepts the address of the inheritor
    //accepts ether and starting balance must be equal to or more than 0.1 ether
    
    constructor(address _inheritor) public payable{
        require (msg.value>=0.1 ether);
      (bool success, ) = address(this).call{value:msg.value}("");
        require(success, "Deposit failed.");
        _owner=msg.sender;
        inheritor=_inheritor;
        expiryTime=now+30 days;
        
    }
    
    //allow the owner to deposit more ether
    function depositMore() public payable onlyOwner {
       // require(success, "Deposit failed.");
        emit deposited(msg.value,now);
        
    }
    
    //allow the owner to change the inheritor
    function changeInheritor(address _newInheritor) public onlyOwner returns(address){
        inheritor=_newInheritor;
    }
    
    //internal function to transfer the ownership
    function transferOwnership(address _newOwner) internal {
        _owner=_newOwner;
    }
    
    //internal function to transfer the inheritor
     function transferInheritor(address _newPerson) internal {
        inheritor=_newPerson;
    }
    
    //allows the owner to withdraw from the contract
    function withdraw(uint _amount) public onlyOwner{
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Withdraw failed.");
    }
    
    
    //internal function to refresh the expirytime
    function refresh() internal onlyOwner{
        expiryTime=now + 30 days;
        emit refreshed(now);
    }
    
    //allows the inheritor to become the owner provided the contract has not been refreshed for 30 days
    //resets the expiryTime to 30days
    function takeOver(address _newInheritor) public onlyInheritor returns (address newInheritor){
        require (now>=expiryTime,"contract has not expired");
        transferOwnership(msg.sender);
        transferInheritor(_newInheritor);
        expiryTime=now+30 days;
        return _newInheritor;
    } 
    
    //This allows the owner to withdraw zero ether and refresh the contract
    function withdrawZeroAndRefresh() public onlyOwner{
         (bool success, ) = msg.sender.call{value:0}("");
        require(success, "Transfer failed.");
        refresh();
        
    }
    
    //thisreturns the current balance of the contract
    function checkBalance() public view returns(uint){
        return address(this).balance;
    }
    
        
    
    
    
    
    
    
}
