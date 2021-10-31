// Contract will be compiled on version 0.8.1 or greater
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
//import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "src/contracts/DateTime.sol";

contract Certificate_old is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {

    uint public certificate_counter;

    // A custom data structure used to define elements of BCG Certificate
    struct certification {
        //string ipfsHash;
        
        // The employee Number
        uint employeeId;
        // Name of Employee
        string employeeName; 
        // The Guild Program
        string guildProgram;
        // Certificate Issuance Date
        uint timeOfIssue;
        // simple stub for whitelist system
        address issuer;
        address recipient;
    } // struct Certificate


    // Mappings
    // mapping(string => address) issuerOfCertificate;
    mapping(address => string) issuer;
    mapping(address => string) recipient;
    // mapping(string => address[]) allRecipientOfCertificate;
    mapping(uint => certification) certificateIdentifier;
    mapping(address => uint[]) recipientCertificates;
    mapping(address => uint[]) issuerCertificates;
    // mapping(address => bool) isIssuer;
    // mapping(address => bool) isRecipient;

    // Events
    // event IssuerRegistered(address indexed issuer, string IPFS_hash);
    // event RecipientRegistered(address indexed recipient, string IPFS_hash);
    // event CertificateRegistered(address indexed issuer, string IPFS_hash);
    event CertificateIssued(uint indexed certificate, address indexed issuer, address indexed recipient);

  string[] public certificates;
  mapping(string => bool) _certificateExists;

      // Event which will be raised anytime the current album information is updated.
    event certificationEvent(string certificationEvent_Description, uint certificationEvent_employeeId, string certificationEvent_employeeName, string certificationEvent_guildProgram);


    using Counters for Counters.Counter;

    //bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIds;



 constructor() ERC721("Certificate", "BGC") {
        // _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // _setupRole(MINTER_ROLE, msg.sender);
    }

    function safeMint(address to) public onlyOwner {
        _safeMint(to, _tokenIds.current());
        _tokenIds.increment();
    }

// The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }



// Functions
    // function registerIssuer(string memory IPFS_hash) public {
    //     require((isIssuer[msg.sender] == false), "Issuer already registered");
    //     issuer[msg.sender] = IPFS_hash;
    //     isIssuer[msg.sender] = true;
    //     emit IssuerRegistered(msg.sender, IPFS_hash);
    // }

    // function registerRecipient(string memory IPFS_hash) public {
    //     require(isRecipient[msg.sender] == false, "Recipient already registered");
    //     recipient[msg.sender] = IPFS_hash;
    //     isRecipient[msg.sender] = true;
    //     emit RecipientRegistered(msg.sender, IPFS_hash);
    // }

    // function registerCertificate(string memory IPFS_hash) public {
    //     require(isIssuer[msg.sender] == true, "Issuer not registered to register a certificate");
    //     issuerOfCertificate[IPFS_hash] = msg.sender;
    //     emit CertificateRegistered(msg.sender, IPFS_hash);
    //}

//function issueCertificate(uint _employeeId, string memory _employeeName, string memory _guildProgram, address _recipient, string memory _certificate_hash,string memory _tokenURI) public onlyRole(MINTER_ROLE) {

function issueCertificate(uint _employeeId, string memory _employeeName, string memory _guildProgram, address _recipient, string memory _tokenURI) public onlyOwner {
        // require(isIssuer[msg.sender] == true, "Issuer not registered to register a certificate");
        // require(isRecipient[_recipient] == true, "Recipient not registered to be issued a certificate");
        //require(issuerOfCertificate[_certificate_hash] == msg.sender, "Issuer not registered to issue this certificate");

//  _tokenIds.increment();
// uint id = _tokenIds.current();

 uint id = mintNFT(_recipient, _tokenURI);

    // The current certification information
    certification memory cert;

       // uint id = ++certificate_counter;
        
        //cert.ipfsHash = _certificate_hash;
        cert.employeeId = _employeeId;
        cert.employeeName = _employeeName;
        cert.guildProgram = _guildProgram;
        cert.timeOfIssue = block.timestamp;
        cert.issuer = msg.sender;
        cert.recipient = _recipient;

        certificateIdentifier[id] = cert;
        recipientCertificates[_recipient].push(id);
        issuerCertificates[msg.sender].push(id);
        //allRecipientOfCertificate[_certificate_hash].push(_recipient);
        emit CertificateIssued(id, msg.sender, _recipient);
    }

//    function getIssuerOfCertificate(string memory IPFS_hash) public view returns (address) {
//         return issuerOfCertificate[IPFS_hash];
//     }

    function getIssuer(address _issuer) public view returns (string memory) {
        return issuer[_issuer];
    }

    function getRecipient(address _recipient) public view returns (string memory) {
        return recipient[_recipient];
    }

    // function getAllRecipientOfCertificate(string memory IPFS_hash) public view returns (address[] memory) {
    //     return allRecipientOfCertificate[IPFS_hash];
    // }

    function getRecipientCertificates(address _recipient) public view returns (uint[] memory) {
        return recipientCertificates[_recipient];
    }

    function getIssuerCertificates(address _issuer) public view returns (uint[] memory) {
        return issuerCertificates[_issuer];
    }

    function getCertificateIdentifier(uint _id) public view returns (uint, address, address){
        certification memory cert = certificateIdentifier[_id];
        return (cert.timeOfIssue, cert.issuer, cert.recipient);
    }

    // function getCertificateIdentifier(uint _id) public view returns (string memory, uint, address, address){
    //     certification memory cert = certificateIdentifier[_id];
    //     return (cert.ipfsHash, cert.timeOfIssue, cert.issuer, cert.recipient);
    // }

   
//   // TODO Restrict ownership of function to Owner or Admin
//   function mint(string memory _certificate) public {
//     // Require unique certificate
//     require(!_certificateExists[_certificate]);
//     certificates.push(_certificate);
//     uint _id = certificates.length -1;
//     _mint(msg.sender, _id);
//     _certificateExists[_certificate] = true;
//     // Name - add it
//     // Call the mint function
//     // Name - track it
//   }

   function mintNFT(address _recipient, string memory _tokenURI)
        public
        onlyOwner 
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        
        _mint(_recipient, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        return tokenId;
    }
  
}