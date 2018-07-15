import {Observable} from 'rxjs';
import {Injectable} from '@angular/core';

import * as contract from 'truffle-contract';

import Web3 from 'web3';

declare var window: any;

@Injectable()
export class Web3Service  {

  public web3: any;

  constructor() {
    this.checkAndInstantiateWeb3();
  }

  checkAndInstantiateWeb3 = () => {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof window.web3 !== 'undefined') {
      // Use Mist/MetaMask's provider
      this.web3 = new Web3(window.web3.currentProvider);
    }
  }

  public async artifactsToContract(artifacts) {
    if (!this.web3) {
      const delay = new Promise(resolve => setTimeout(resolve, 100));
      await delay;
      return await this.artifactsToContract(artifacts);
    }

    const contractAbstraction = contract(artifacts);
    contractAbstraction.setProvider(this.web3.currentProvider);
    return contractAbstraction;

  }

  getWei(value: number): number {
    return this.web3.utils.toBN(1000000000000000000 * value);
  }

  getAccounts(): Observable<Array<string>> {
    return Observable.create(observer => {
      this.web3.eth.getAccounts((err, accs) => {
        if (err != null) {
          observer.error('There was an error fetching your accounts.');
        }

        if (accs.length === 0) {
          observer.error('Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.');
        }

        observer.next(accs);
        observer.complete();
      });
    });
  }
}
