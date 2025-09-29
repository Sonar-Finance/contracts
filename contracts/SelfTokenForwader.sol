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

enum Votes {
    YES,
    NO
}

contract SelfTokenForwarder {
    ISignatureTransfer public immutable PERMIT2;
    address public token_address;

    mapping(address => mapping(uint256 => mapping(Votes => uint256)))
        public user_votes;

    event VoteCast(
        address indexed voter,
        uint256 indexed market_id,
        Votes vote,
        uint256 amount
    );

    constructor(ISignatureTransfer _permit2, address _token_address) {
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

        // We return the tokens to the sender
        // This is a simple forwarder contract for testing purposes
        // In a real contract, you would have more complex logic here
    }
}
