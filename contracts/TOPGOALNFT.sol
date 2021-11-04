// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./OERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract TOPGOALNFT is OERC721Enumerable, Pausable {
    using Strings for uint256;

    string private baseURI;
    mapping(address => bool) private blacklist;

    event BlacklistAdded(address indexed addr);
    event BlacklistRemoved(address indexed addr);

    constructor(
        address admin_,
        string memory baseURI_,
        string memory name_,
        string memory symbol_
    ) OERC721(admin_, name_, symbol_) {
        baseURI = string(abi.encodePacked(baseURI_));
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /**
     * override tokenURI(uint256), remove restrict for tokenId exist.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    function setPause() external onlyOwner {
        _pause();
    }

    function unsetPause() external onlyOwner {
        _unpause();
    }

    function changeBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = string(abi.encodePacked(newBaseURI));
    }

    function addBlacklistAddress(address addr) external onlyOwner {
        require(!blacklist[addr], "address must not be blacklisted");
        require(addr != owner(), "adding owner!");

        blacklist[addr] = true;
        emit BlacklistAdded(addr);
    }

    function removeBlacklistAddress(address addr) external onlyOwner {
        require(blacklist[addr], "not blacklisted address");

        blacklist[addr] = false;
        emit BlacklistRemoved(addr);
    }

    function getBlacklistStatus(address addr) public view returns (bool) {
        return blacklist[addr];
    }

    /**
     * @dev See {ERC721-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused and from must not be blacklisted
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        require(!paused(), "OERC721Pausable: token transfer while paused");
        require(!blacklist[from], "address blacklisted");
    }
}