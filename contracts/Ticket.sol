// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Ticketing {
    address private admin;
    uint256 public totalTickets;
    uint256 public totalTicketsSold;
    uint256 public ticketPrice;
    uint256 private totalRevenue;
    string public standard = "TICKETINGSYSTEM-0.1";
    mapping(uint256 => address) public seatsToAttendees;
    mapping(address => uint256) public attendeesToSeats;

    event TicketPurchaseEvent(address indexed _attendee, uint256 _amount);

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    function TicketSystem(uint256 inTotalTickets, uint256 inTicketPrice)
        public
    {
        admin = msg.sender;
        totalRevenue = 0;
        totalTicketsSold = 0;
        totalTickets = inTotalTickets;
        ticketPrice = inTicketPrice;
    }

    function getUserTicketCount() public view returns (uint256) {
        return attendeesToSeats[msg.sender];
    }

    function purchaseTicket(uint256 amount) public payable returns (bool) {
        uint256 transactionTotal = amount * ticketPrice;

        if (
            (amount + totalTicketsSold <= totalTickets) &&
            (amount > 0) &&
            (msg.value > transactionTotal)
        ) {
            totalRevenue += transactionTotal;

            for (
                uint256 i = totalTicketsSold + 1;
                i < totalTicketsSold + amount + 1;
                i++
            ) {
                seatsToAttendees[i] = msg.sender;
            }
            attendeesToSeats[msg.sender] += amount;
            totalTicketsSold += amount;
            totalTickets -= amount;
            emit TicketPurchaseEvent(msg.sender, amount);
            return true;
        } else {
            return false;
        }
    }

    function withdrawAll() public payable onlyAdmin returns (bool) {
        uint256 amount = totalRevenue;
        totalRevenue = 0;
        msg.sender.transfer(amount);
        return true;
    }
}
