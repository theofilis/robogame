import { ChangeDetectorRef, Component, OnInit } from '@angular/core';

import { Web3Service } from '../../_services';

declare let require: any;
const game_artifacts = require('../../../../build/contracts/RobotMinting.json');

@Component({ templateUrl: 'battle.component.html' })
export class BattleComponent implements OnInit {
  RobotGame: any;
  account: string;
  robots: Array<number>;
  robotsAll: Array<number>;
  isEnabled: boolean;
  ownRobot: number;
  alert = {
    show: false,
    msg: 'Battle finished'
  }

  constructor(
    private cd: ChangeDetectorRef,
    private webService: Web3Service) {
      this.robots = [];
      this.robotsAll = [];
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
        this.getAllRobots();
      });
  }

  async getRobots() {
    if (!this.RobotGame) {
      return;
    }

    // Code here

    this.cd.detectChanges();
  }

  async getAllRobots() {
    if (!this.RobotGame) {
      return;
    }

    const deployedRobotGame = await this.RobotGame.deployed();
    // Code here

    this.cd.detectChanges();
  }

  async attack(id) {
    if (!this.RobotGame) {
      return;
    }
    const deployedRobotGame = await this.RobotGame.deployed();

    try {
      // Code here
      this.alert = {
        show: true,
        msg: 'Battle finished'
      };
      this.cd.detectChanges();
    } catch (error) {
      console.log(error);
    }
  }

  async selectOwn(id: number) {
    this.ownRobot = id;
    this.cd.detectChanges();
  }

  async dismiss() {
    this.alert.show = !this.alert.show;
    this.cd.detectChanges();
  }
}
