pragma solidity >=0.4.16 <0.9.0;

contract Paylock{
    
    enum State {Working, Completed, Delay, Done_1, Done_2, Forfeit}
    
    struct Paylock_struct{
        State st;
        int disc;
    }
    
    int clock;
    Paylock_struct paylock;
    string outputMessage;
    
    address timeAdd = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    address supp1Add;
    
    event Situation(State _s, int _disc, int _c, string _message);
    
    constructor() public {
        paylock.st = State.Working;
        paylock.disc = 0;
    }
    
    function tick() external{
        require( msg.sender == timeAdd );
        clock++;
    }
    
    function signal() external {
        require( paylock.st == State.Working );
        paylock.st = State.Completed;
        paylock.disc = 10;
        clock = 0;
        supp1Add = msg.sender;
    }
    
    function collect_1_Y() external {
        require( paylock.st == State.Completed );
        require( clock < 4, "Deadline 1 has not come yet!");
        paylock.st = State.Done_1;
        paylock.disc = 10;
        
        outputMessage = "You met the first deadline!";
        emit Situation (paylock.st, paylock.disc, clock, outputMessage);
    }
    
    function collect_1_N() external {
        require( paylock.st == State.Completed );
        require ( clock == 4 );
        paylock.st = State.Delay;
        paylock.disc = 5;
        
        clock = 0;
        outputMessage = "You missed the first deadline. Try not to miss the second one!";
        emit Situation (paylock.st, paylock.disc, clock, outputMessage);
    }
    
    function collect_2_Y() external {
        require( paylock.st == State.Delay );
        require ( clock < 4, "Deadline 2 has not come yet!");
        paylock.st = State.Done_2;
        paylock.disc = 5;
        
        outputMessage = "You met the second deadline!";
        emit Situation (paylock.st, paylock.disc, clock, outputMessage);
    }
    
    function collect_2_N() external {
        require( paylock.st == State.Delay );
        require ( clock == 4);
        paylock.st = State.Forfeit;
        paylock.disc = 0;
        
        outputMessage = "Your order is forfeited!";
        emit Situation (paylock.st, paylock.disc, clock, outputMessage);
    }

}

contract Supplier {

    Paylock p;
        
    enum State { Working , Completed , Done_1 , Delay , Done_2 , Forfeit, Acquisition, Return }    
    
    State st;
    
    Rental r;
    
    constructor(address pp, address payable add) public {
        p = Paylock(pp);
        st = State.Working;
        r = Rental(add);
    }
    
    function signal_paylock() external {
    }
    
    function getpaid_1_Y() external {
        st = State.Done_1;
        p.collect_1_Y();
    }
    
    function getpaid_1_N() external {
    }
    
    function getpaid_2_Y() external {
        st = State.Done_2;
        p.collect_2_Y();
    }
    
    function getpaid_2_N() external {
    }
    
    function acquire_resource() external {
        r.rent_out_resource.value(r.deposit())();
        st = State.Acquisition;
    }
    
    function return_resource() external{
        r.retrieve_resource();
        st = State.Return;
    }
    
    receive() external payable{
        if(r.report_balance() > r.deposit()){
            r.retrieve_resource();
        }
    }

}

contract Rental {

    uint256 public deposit = 1 wei;
    
    address resource_owner;
    bool resource_available;
    
    constructor() public {
        resource_available = true;
    }
    
    function rent_out_resource() external payable {
        require(resource_available == true);
        require(msg.value == deposit);
        resource_owner = msg.sender;
        resource_available = false;
    }
    
    function retrieve_resource() external {
        require(resource_available == false && msg.sender == resource_owner);
        resource_available = true;
        (bool sucess,) = resource_owner.call.value(deposit)("");
        require(sucess);
    }
    
    function report_balance() external view returns(uint256) {
        return address(this).balance;
    }
    
    receive() external payable {
    }

}
