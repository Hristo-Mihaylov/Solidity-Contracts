pragma solidity >=0.4.16 <0.9.0;

contract Contract{
    
    enum State {Working, Completed, Delay, Done_1, Done_2, Forfeit}
    int disc;
    State st;
    

    constructor() public {
    st = State.Working;
    disc = 0;
    }
    
    function signal() external {
    require( st == State.Working );
    st = State.Completed;
    disc = 10;
    }
    
    function collect_1_Y() external {
    require( st == State.Completed );
    st = State.Done_1;
    disc = 10;
    }
    
    function collect_1_N() external {
    require( st == State.Completed );
    st = State.Delay;
    disc = 5;
    }
    
    function collect_2_Y() external {
    require( st == State.Delay );
    st = State.Done_2;
    disc = 5;
    }
    
    function collect_2_N() external {
    require( st == State.Delay );
    st = State.Forfeit;
    disc = 0;
    }

}

