pragma solidity ^0.4.21;

/**
 * author: Alberto Serrano
 *
 * purpose: Create a template for an official, business contract.
 *          Provide way for multiple parties to edit state of contract,
 *          set payouts if certain conditions are met (all parties must sign).
 *          Every edit to contract will be made public (by nature of tech).
 **/

contract ActualContract
{
    // Info for every owner of the contract.
    // Can edit contract if owner == true
    struct Owner
    {
        string name;
        bool owner;
        bool signed;
    }

    /* Contract attributes:
        + Contents
        +

    */

    struct Section
    {
        uint SectionNumber;
        string Title;
        string MoreInfo;
        // Add more important info about seciton
    }

    mapping(address => Owner) private owners;
    uint private numOwners = 0;
    uint private signatures = 0;

    // Announce new owner
    event NewOwner
    (
        string addedName,
        address addedAddress
    );

    // Announce a new modification by specific owner.
    // Add description of modification.
    event NewModification
    (
        string NameOfModder,
        address AddOfModder,
        string description
    );

    event NewSignature
    (
        string NameOfSigner,
        address AddOfSigner
    );

    // Constructor
    function ActualContract(string _name) public
    {
        owners[msg.sender].name = _name;
        owners[msg.sender].owner = true;
        numOwners++;
    }

    // Only an owner of the document can add another owner
    // Announce new owner
    function AddOwner(address to, string _name) public
    {
        if( !owners[msg.sender].owner ) return;

        owners[to].owner = true;
        owners[to].name = _name;
        emit NewOwner(_name, to);
        numOwners++;
    }

    function SignDocument() public
    {
        if( !owners[msg.sender].owner && owners[msg.sender].signed ) return;

        owners[msg.sender].signed = true;
        signatures++;
        emit NewSignature(owners[msg.sender].name, msg.sender);
    }

}
