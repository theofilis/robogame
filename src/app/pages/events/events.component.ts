import {ChangeDetectorRef, Component, OnInit} from '@angular/core';

import {Web3Service} from '../../_services';

declare let require: any;
const game_artifacts = require('../../../../build/contracts/RobotMinting.json');

@Component({templateUrl: 'events.component.html'})
export class EventsComponent implements OnInit {
  RobotGame: any;
  events: Array<any>;

  constructor(
    private cd: ChangeDetectorRef,
    private webService: Web3Service) {
    this.events = [];
  }

  ngOnInit(): void {
    this.webService.artifactsToContract(game_artifacts)
      .then((RobotGameAbstraction) => {
        this.RobotGame = RobotGameAbstraction;
        this.watchEvents();
      });
  }

  async watchEvents() {
    if (!this.RobotGame) {
      return;
    }

    const deployedRobotGame = await this.RobotGame.deployed();

    // Code here
  }
}
