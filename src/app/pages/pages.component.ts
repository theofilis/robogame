import {Component} from '@angular/core';
import {Router, ActivatedRoute} from '@angular/router';

@Component({templateUrl: 'pages.component.html'})
export class PagesComponent {
  constructor(
    private route: ActivatedRoute,
    private router: Router) {

  }
}
