pragma solidity >=0.4.16 <0.9.0;

contract Contract{
    
    enum State {Working, Completed, Delay, Done_1, Done_2, Forfeit}
    
    struct Paylock{
        int disc;
        State st;
    }
    
    Paylock paylock;
    
    
    constructor() public {
    paylock.st = State.Working;
    paylock.disc = 0;
    }
    
    function signal() external {
    require( paylock.st == State.Working );
    paylock.st = State.Completed;
    paylock.disc = 10;
    }
    
    function collect_1_Y() external {
    require( paylock.st == State.Completed );
    paylock.st = State.Done_1;
    paylock.disc = 10;
    }
    
    function collect_1_N() external {
    require( paylock.st == State.Completed );
    paylock.st = State.Delay;
    paylock.disc = 5;
    }
    
    function collect_2_Y() external {
    require( paylock.st == State.Delay );
    paylock.st = State.Done_2;
    paylock.disc = 5;
    }
    
    function collect_2_N() external {
    require( paylock.st == State.Delay );
    paylock.st = State.Forfeit;
    paylock.disc = 0;
    }

}

