pragma solidity ^0.4.21;

/**
 * author: Alberto Serrano
 *
 * purpose: Create a template for an official, business document.
 *          Provide way for multiple parties to edit state of contract,
 *          set payouts if certain conditions are met (all parties must sign).
 *          Every edit to contract will be made public (by nature of tech).
 **/

contract Document
{
    // Info for every owner of the contract.
    // Can edit contract if owner == true
    struct Owner
    {
        string name;
        bool owner;
        bool signed;
        uint signDate;
    }

    // Info for every section of contract
    struct Section
    {
        uint SectionNumber;
        string Title;
        string MoreInfo;
        // Add more important info about section
    }

    mapping(address => Owner) private owners;
    uint private numOwners = 0;
    uint private signatures = 0;

    // Store contract sections
    Section[] private sections;

    // editable is true if no one has signed; becomes false when at least
    // one person has signed.
    bool private editable = true;

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

    // Announce new signature
    event NewSignature
    (
        string NameOfSigner,
        address AddOfSigner,
        uint date
    );

    // Constructor
    function Document(string _name) public
    {
        owners[msg.sender].name = _name;
        owners[msg.sender].owner = true;
        numOwners++;
    }

    function AddSection(string _title, string _description) public
    {
        if( !owners[msg.sender].owner ) return;
        if( !editable )                 return;

        sections.push(Section(
        {
            SectionNumber: sections.length + 1,
            Title: _title,
            MoreInfo: _description
        }));
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

    // Allow an owner to sign document
    function SignDocument() public
    {
        if( !owners[msg.sender].owner && owners[msg.sender].signed ) return;

        if( signatures == 1) editable = false;

        owners[msg.sender].signed = true;
        owners[msg.sender].signDate = now;
        signatures++;
        emit NewSignature(owners[msg.sender].name, msg.sender, owners[msg.sender].signDate);
    }
}
