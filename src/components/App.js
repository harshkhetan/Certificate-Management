import React, { Component } from 'react';
// import { Button, Container } from '@material-ui/core';
// import MenuIcon from '@material-ui/icons/Menu';
// import Grid from '@material-ui/core/Grid';
// import Paper from '@material-ui/core/Paper';
// import Link from '@material-ui/core/Link';
// import logo from '../logo.png';
import Web3 from 'web3';
//import Navigation from './Navigation';
import Certificate from '../abis/Certificate.json'
import './App.css';


class App extends Component {
  async componentWillMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  async loadWeb3() {
    
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum);
      await window.ethereum.enable();
    } else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider);
    } else {

// let infuraProjectId = "";
// let metsmaskWallet = "";
// let web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io/v3/" + infuraProjectId));
// web3.eth.getBalance(metsmaskWallet).then(balance =>console.log(balance));

      window.alert(
        'Non-Ethereum browser detected. You should consider trying MetaMask!'
      );
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3;
    // Load account
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts[0] });

 // Load smart contract
 const networkId = await web3.eth.net.getId()
 const networkData = Certificate.networks[networkId]
this.setState({networkId})

 if(networkData) {
   const abi = Certificate.abi
   const address = networkData.address
   const token = new web3.eth.Contract(abi, address)
   this.setState({ token })
   const totalSupply = await token.methods.totalSupply().call()
   this.setState({ totalSupply })
   // Load Tokens
   let balanceOf = await token.methods.balanceOf(accounts[0]).call()
   for (let i = 0; i < balanceOf; i++) {
     let id = await token.methods.tokenOfOwnerByIndex(accounts[0], i).call()
     let tokenURI = await token.methods.tokenURI(id).call()
     this.setState({
       tokenURIs: [...this.state.tokenURIs, tokenURI]
     })
   }
 } else {
   alert('Smart contract not deployed to detected network.')
 }
 


  }

  constructor(props) {
    super(props);
    this.state = {
      account: '0x0',
      token: null,
      totalSupply: 0,
      tokenURIs: [],
    };
  }

  render() {
    return (
      <div>
       <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
          <a
            className="navbar-brand col-sm-3 col-md-2 mr-0"
            href="http://www.google.com"
            target="_blank"
            rel="noopener noreferrer"
          >
          &nbsp; Certificate Management
          </a>
          <ul className="navbar-nav px-3">
            <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
              <small className="text-muted"><span id="account">{this.state.networkId}---{this.state.account} </span></small>
            </li>
          </ul>
        </nav>
      </div>
    );
  }
}

export default App;
