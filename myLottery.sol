pragma solidity ^0.4.17;

contract Lottery{
    address public manager;
    address[] public players;

    function Lottery() public{
         manager = msg.sender;
    }

    function enter() public payable{
        require(msg.value > .01 ether);

        players.push(msg.sender);
    }

    function pickWinner() public restricted{

        uint index = 0;
        for (uint i=0 ; i < players.length ; i++){
            if(players[index].balance < players[i].balance){
                index = i;
            }
        }
            
        uint tenPurcent = this.balance * 10 / 100;
        manager.transfer(tenPurcent);
        players[index].transfer(this.balance);
        players = new address[](0);
    }

    function random() private view returns (uint){
        //get current block difficulty + time + participants' addresses
        return uint(keccak256(block.difficulty, now, players));
    }

    function getPlayers() public view returns (address[]){
        return players;
    }

    modifier restricted(){
      require(msg.sender == manager);
      _;
    }
}