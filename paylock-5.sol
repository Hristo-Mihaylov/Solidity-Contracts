pragma solidity >=0.4.16 <0.9.0;

contract Contract{
    
    enum State {Working, Completed, Delay, Done_1, Done_2, Forfeit}
    
    struct Paylock{
        State st;
        int disc;
    }
    
    int clock;
    Paylock paylock;
    string outputMessage;
    
    address timeAdd = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    
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
