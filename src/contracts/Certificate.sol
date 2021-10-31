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

    uint public certificate_counter;
    string[] public certificates;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //certification public newCert;
    //address owner;

    // A custom data structure used to define elements of BCG Certificate
    struct certification {
        
         uint employeeId;
        string employeeName; 
        // The Program
        string program;
        // Certificate Issuance Date
        uint timeOfIssue;
        address issuer;
        //address recipient;
    } 


        struct employee {
         uint employeeId;
        string program;
    } 

    employee[] public employeeCertificate;

    mapping(string => bool)  _certificateExists;
    mapping(address => string)  Issuer;
    mapping(address => string[])  recipient;
    mapping(uint => certification)  certificateIdentifier;
    //mapping(address => uint[])  recipientCertificates;
    mapping(uint => uint[])  recipientCertificates;

    //uint[] recipientCertificates1;
    mapping(address => uint[]) public issuerCertificates;

    // Events

    //event CertificateIssued(uint indexed employeeId, string indexed employeeName, string indexed program, address indexed issuer, address indexed recipient);
    
    // Event which will be raised anytime the current certificate information is updated.
    event certificationEvent(uint certificationEvent_employeeId, string certificationEvent_employeeName, string certificationEvent_program, address certificationEvent_issuer, string  certificationEvent_tokenURI);
    // Event which will be raised anytime the current Certificate information is updated.
    event errorEvent(string errorEvent_Description);

 constructor() ERC721("Certificate", "BGC") {
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


// // TEST FUNCTIONS
//     // Returns the current certificate information
//     function getCertificate() public view returns (uint, string memory, string memory, address) {
//         return (newCert.employeeId,newCert.employeeName,newCert.program,newCert.recipient);
//     } // getCertificate
    
//     // Set the certificate information
//     function setCertificate(uint _employeeId, string memory _employeeName, string memory _program, address _recipient) public {
//         newCert.employeeId = _employeeId;
//         newCert.employeeName = _employeeName;
//         newCert.program = _program;
//         newCert.timeOfIssue = block.timestamp;
//         newCert.issuer = owner();
//         newCert.recipient = _recipient;
//         emit certificationEvent(newCert.employeeId,newCert.employeeName,newCert.program);
//     } // setCertificate



function issueCertificate(uint _employeeId, string memory _employeeName, string memory _program, address _issuer,  string memory _tokenURI) public onlyOwner {
   
    require(owner() == _issuer, "Issuer do not have permission to issue a certificate");
    require(isExist(_employeeId,_program) == false, "Requested certificate is already issued to the employee.");
   
    uint id = mintNFT(_issuer, _tokenURI);
    
    // The current certification information
    certification memory cert;

        cert.employeeId = _employeeId;
        cert.employeeName = _employeeName;
        cert.program = _program;
        cert.timeOfIssue = block.timestamp;
        cert.issuer = owner();
        //cert.recipient = _recipient;

        certificateIdentifier[id] = cert;
        //recipientCertificates[_recipient].push(id);
        recipientCertificates[_employeeId].push(id);
        issuerCertificates[owner()].push(id);

        employee memory newEmployee = employee(_employeeId,_program);
        employeeCertificate.push(newEmployee);
        
      emit certificationEvent(cert.employeeId,cert.employeeName,cert.program, cert.issuer, _tokenURI);
    }

      function isExist (uint _employeeId, string memory _program) private view returns (bool){
      if(employeeCertificate.length == 0)
      {
          return false;
      }    
      for (uint i = 0; i< employeeCertificate.length; i++){
          if (employeeCertificate[i].employeeId ==_employeeId && keccak256(abi.encodePacked(employeeCertificate[i].program)) ==keccak256(abi.encodePacked(_program)))
               return true;
         //break;
         
      }
      return false;

  }

// function retrieveCertificate(address _recipient) public view returns (uint, string memory, string memory,uint, address, address, string memory){
//     uint _latest = recipientCertificates[_recipient].length;
//     uint _lastTokenId = recipientCertificates[_recipient][_latest-1];
//     certification memory cert = certificateIdentifier[_lastTokenId];
//     return (cert.employeeId,cert.employeeName,cert.program, cert.timeOfIssue, cert.issuer, cert.recipient, tokenURI(_lastTokenId));

//     }

    function retrieveCertificate(uint _employeeId) public view returns (uint, string memory, string memory,uint, address, string memory){
    require(_employeeId > 0,'Require a valid Employee Id');
    require(recipientCertificates[_employeeId].length > 0,'No certification to retrieve for the Employee Id');
    uint _latest = recipientCertificates[_employeeId].length;
    uint _lastTokenId = recipientCertificates[_employeeId][_latest-1];
    certification memory cert = certificateIdentifier[_lastTokenId];
    return (cert.employeeId,cert.employeeName,cert.program, cert.timeOfIssue, cert.issuer, tokenURI(_lastTokenId));

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