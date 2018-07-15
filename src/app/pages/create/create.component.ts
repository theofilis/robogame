import { ChangeDetectorRef, Component, OnInit } from '@angular/core';

import { Web3Service } from '../../_services';

declare let require: any;
const game_artifacts = require('../../../../build/contracts/RobotMinting.json');

@Component({ templateUrl: 'create.component.html' })
export class CreateComponent implements OnInit {
  RobotGame: any;
  account: string;
  robots: Array<number>;
  name: string;
  show: boolean;
  transfer: any;

  constructor(
    private cd: ChangeDetectorRef,
    private webService: Web3Service) {
    this.robots = [];
    this.show = true;
    this.transfer = {
      address: ''
    };
  }

  ngOnInit(): void {
    this.getAccounts();
    this.webService.artifactsToContract(game_artifacts)
      .then((RobotGameAbstraction) => {
        this.RobotGame = RobotGameAbstraction;
      });
  }

  getAccounts() {
    this.webService.getAccounts()
      .subscribe((accounts) => {
        this.account = accounts[0];
        this.getRobots();
      });
  }

  async getRobots() {
    if (!this.RobotGame) {
      return;
    }

    const deployedRobotGame = await this.RobotGame.deployed();
    // Code here
    this.cd.detectChanges();
  }

  async createNewRobot() {
    if (!this.RobotGame) {
      return;
    }

    const deployedRobotGame = await this.RobotGame.deployed();

    try {
      // Code here
    } catch (error) {
      console.log(error);
    }
  }

  async transferRobot() {
    if (!this.RobotGame) {
      return;
    }

    const deployedRobotGame = await this.RobotGame.deployed();

    try {
      // Code here
    } catch (error) {
      console.log(error);
    }
  }

  async levelUp(id: number) {
    const fee = this.webService.getWei(0.001);
    if (!this.RobotGame) {
      return;
    }
    const deployedRobotGame = await this.RobotGame.deployed();

    try {
      // Code here

    } catch (error) {
      console.log(error);
    }
  }
}
