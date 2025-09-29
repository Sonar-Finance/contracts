// SPDX-License-Identifier: MIT
//
//  ░▒▓███████▓▒░░▒▓██████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░
//  ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
// ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
//  ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓███████▓▒░
//        ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
//       ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
// ░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
//
// https://sonar.trading

pragma solidity ^0.8.20;
import {ISignatureTransfer} from "./interfaces/ISignatureTransfer.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

enum Votes {
    YES,
    NO
}

contract SelfTokenForwarder {
    ISignatureTransfer public immutable PERMIT2;
    IERC20 public token_address;

    mapping(address => uint256) private total_deposits;
    mapping(address => mapping(uint256 => mapping(Votes => uint256)))
        private user_votes;

    event VoteCast(
        address indexed voter,
        uint256 indexed market_id,
        Votes vote,
        uint256 amount
    );

    constructor(ISignatureTransfer _permit2, IERC20 _token_address) {
        PERMIT2 = _permit2;
        token_address = _token_address;
    }

    function vote_with_signature(
        uint256 market_id,
        Votes vote,
        uint256 amount,
        ISignatureTransfer.PermitTransferFrom calldata permit0,
        ISignatureTransfer.SignatureTransferDetails calldata details0,
        bytes calldata sig0
    ) external {
        PERMIT2.permitTransferFrom(permit0, details0, msg.sender, sig0);

        // We emit an event to simulate the vote being cast
        emit VoteCast(msg.sender, market_id, vote, amount);
        user_votes[msg.sender][market_id][vote] += amount;
        total_deposits[msg.sender] += amount;
    }

    function get_user_deposits(
        address user
    ) external view returns (uint256 deposits) {
        deposits = total_deposits[user];
    }

    function market_balance(
        uint256 market_id
    ) public view returns (uint256 yes, uint256 no) {
        yes = user_votes[msg.sender][market_id][Votes.YES];
        no = user_votes[msg.sender][market_id][Votes.NO];
    }

    function claim_balance(uint256 market_id) external {
        (uint256 yes, uint256 no) = market_balance(market_id);
        uint256 total_claiming = yes + no;
        require(total_claiming > 0, "NothingToClaim");
        require(
            token_address.transfer(msg.sender, total_claiming),
            "TransferFailed"
        );

        // Reset user votes after claiming
        user_votes[msg.sender][market_id][Votes.YES] = 0;
        user_votes[msg.sender][market_id][Votes.NO] = 0;
    }
}
