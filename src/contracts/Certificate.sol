// Contract will be compiled on version 0.8.1 or greater
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//import "src/contracts/DateTime.sol";

contract Certificate is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {

    string[] public certificates;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // A custom data structure used to define elements of BCG Certificate
    struct certification {
        
        address recipient;
        string recipientName; 
        // The Program
        string program;
        address issuer;
        // Certificate Issuance Date
        uint timeOfIssue;
    } 

    mapping(string => bool)  _certificateExists;
    mapping(address => string)  Issuer;
    mapping(address => string[])  recipient;
    //mapping(string => address[]) allRecipientOfCertificate;
    mapping(uint => certification)  certificateIdentifier;
    mapping(address => uint[])  recipientCertificates;
    mapping(address => uint[]) public issuerCertificates;

    // Events

    //event CertificateIssued(address indexed recipientAddress, string indexed recipientName, string indexed program, address indexed issuer, address indexed recipient);
    
    // Event which will be raised anytime the current certificate information is updated.
    event certificationEvent(address certificationEvent_recipientAddress, string certificationEvent_recipientName, string certificationEvent_program, address certificationEvent_issuer, string  certificationEvent_tokenURI);
    // Event which will be raised anytime the current Certificate information is updated.
    event errorEvent(string errorEvent_Description);

//Blockchain Certificate Management
 constructor() ERC721("Certificate", "BCM") {
        //owner = msg.sender;
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

function issueCertificate(address _recipient, string memory _recipientName, string memory _program, address _issuer,  string memory _tokenURI) public onlyOwner {
   
    require(owner() == _issuer, "Issuer do not have permission to issue a certificate");
    require(isExist(_recipient,_program) == false, "Requested certificate is already issued to the recipient.");
   

    uint id = mintNFT(_issuer, _tokenURI);
    
    // The current certification information
    certification memory cert;
        cert.recipient = _recipient;
        cert.recipientName = _recipientName;
        cert.program = _program;
        cert.issuer = owner();
        cert.timeOfIssue = block.timestamp;

        certificateIdentifier[id] = cert;
        recipientCertificates[_recipient].push(id);
        issuerCertificates[owner()].push(id);
        
      emit certificationEvent(cert.recipient,cert.recipientName,cert.program, cert.issuer, _tokenURI);
    }

      function isExist (address _recipient, string memory _program) private view returns (bool){
      if(recipientCertificates[_recipient].length == 0)
      {
          return false;
      }    
      for (uint i = 0; i< recipientCertificates[_recipient].length; i++){
          uint _TokenId = recipientCertificates[_recipient][i];
          if (keccak256(abi.encodePacked(certificateIdentifier[_TokenId].program)) == keccak256(abi.encodePacked(_program)))
               return true;
         //break;
        
      }
      return false;

  }

function retrieveCertificate(address _recipient) public view returns (address, string memory, string memory, address, string memory, uint){
    require(_recipient == address(_recipient),"Invalid address");
    require(recipientCertificates[_recipient].length > 0,'No certification to retrieve for the recipient');
    uint _latest = recipientCertificates[_recipient].length;
    uint _lastTokenId = recipientCertificates[_recipient][_latest-1];
    certification memory cert = certificateIdentifier[_lastTokenId];
    return (cert.recipient,cert.recipientName,cert.program, cert.issuer,tokenURI(_lastTokenId),cert.timeOfIssue);

    }

      
    // function getIssuer(address _issuer) public view returns (string memory) {
    //     return Issuer[_issuer];
    // }

    // function getRecipient(address _recipient) public view returns (string memory) {
    //     return recipient[_recipient];
    // }

    // function getRecipientCertificates(address _recipient) public view returns (uint[] memory) {
    //     return recipientCertificates[_recipient];
    // }

    // function getIssuerCertificates(address _issuer) public view returns (uint[] memory) {
    //     return issuerCertificates[_issuer];
    // }


    // // Safely mints `tokenId` and transfers it to the recepient.
    // function safeMint(address to) public onlyOwner {
    //     _safeMint(to, _tokenIds.current());
    //     _tokenIds.increment();
    // }

    //Restrict ownership of function to Owner or Admin
   function mintNFT(address _issuer, string memory _tokenURI)
        private
        onlyOwner 
        returns (uint256)
    {
        //safeMint(_recipient);
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        
        _mint(_issuer, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        return tokenId;
    }
}