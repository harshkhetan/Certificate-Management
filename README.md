# Certificate-Management

Certification management system, is implemented in blockchain. Blockchain makes the management decentralized, trustless, secure, and immutable.

#### **Certification Management system, is implemented in blockchain, as** 

* Data stored is of high importance, 
* Data stored is for a long term. 
* The security of records is guaranteed 

#### Smart Contract: 
Smart contract is a code which runs on blockchain, and is analogous to a traditional contract, but also automatically enforce the required obligations. A smart contract is a computer protocol intended to digitally facilitate, verify, or enforce the negotiation or performance of a contract. Smart contracts allow the performance of credible transactions without third parties. 
>Note: Smart contract can be also made open sourced, and available to all. 

#### Ganache Personal Blockchain: 
The dependency is a personal blockchain, which is a local development blockchain that we used to recreate the behavior of a public blockchain. In this case we used Ganache as our personal blockchain for Ethereum development. It also allowed us to deploy smart contracts, develop applications and run tests.

## **Architecture Overview** 
![Certificate Management Architecture Overview](/assets/images/Certificate-Management.jpg)

To certify any recipient, an issuer first mints the certificate as a Non-fungible token (NFT) token using the registered recipient’s address. At the recipient’s end, it can get the details of all the certificates he has received. 

If a third party wants to check the details of issuer, recipient, or the certificate, it can easily do so. The function for Issuing, or retrieving certificates is implemented in the form of transaction. The cost of any transaction done, is the “gas” cost. 

Gas is a transaction fee required when interacting with the smart contract. The gas depends on the logic implemented on the smart contract. 

The system also provides any user to access the data of who issued and when it was issued. This provides a way to check the authenticity of the certificate, the recipient, and the issuer.

#### Validations 
* Only identified issuer can issue certificate NFT tokens. If a non-issuer attempts to mint the NFT an error will be thrown, and the certificate will not be created. 
* The certificate which is issued, cannot be minted twice. If a certificate already exists for the unique identifier (recipient address) and Program an error will be thrown.

#### Users 
There are 3 types of users the system provides support to: 

* **Issuer:** This is the certifying authority, which mints new certificates, then issues the desired recipient that certificate. 
* **Recipient:** This is the recipient of the certificate. They have their own unique address; Issuer can also access recipient’s details from its address and issue certificate NFT tokens to the recipient. Whenever any recipient of the certificate must prove its certifications, he can simply send its address. 
* **Third Party:** This can be any anonymous user, which wants to verify the recipient’s certificate.

## **Advantages** 
* Implemented system provides a far better security, as there is no single point of attack. 
* Implemented system runs on blockchain, there is no central body which runs the system. It is decentralized, provides transparency to the participants, to make it an open and fair alternative to the current system. 
* Implemented system makes records available permanently and provides immutability(unalterable). These can be thought of as reliable proofs, online. 
* Implemented system provides transparency to its participants, where each user can access the system transactions. This also provides a good way for auditing the system. 
* All the transactions done on the system are safe, and verified by a vast P2P global network (Ethereum)

## **Limitations**

There is gas fees for each transaction while placing the bet depends on the smart contract code. So, if the code logic is complex(storage/memory-wise), the gas might be high

## **Tools Used** 
> Tools used for development and testing.

* **Version Control:** git (https://git-scm.com/) and GitHub (github.com) 
* **Code Editor:** Visual Studio Code (https://code.visualstudio.com/) 
* **Ethereum** 
* Remix (https://remix.ethereum.org/) 
* Truffle (https://www.trufflesuite.com/) 
* Ganache (https://www.trufflesuite.com/ganache) 
* Web3 (https://web3js.readthedocs.io/en/v1.5.2/) 
* Open Zeppelin (https://openzeppelin.com/contracts/) 

* **Development on Windows:** Windows Subsystem for Linux – Ubuntu & OSX 
* **Browser:** Google Chrome

## **Future Scope**
>Below are some of the highlights:

* Expand it to multiple issuers. All the issuers/ recipients register themselves to the system. 
* The profile details of the users are stored on IPFS, identified by some unique hash, which is stored in the blockchain.  
* A feature of revoking a certificate can be added which can also be used for time-valid certificates. 
* A system of privilege-based access to certificate can be implemented, where only the allowed users can access the certificates. 
* Migrate FE to React with Material UI theme
