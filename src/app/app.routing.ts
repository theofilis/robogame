import {Routes, RouterModule} from '@angular/router';

import {
  PageNotFoundComponent,
  BattleComponent,
  CreateComponent,
  EventsComponent,
  PagesComponent
} from './pages';

const appRoutes: Routes = [
  {
    path: 'pages',
    component: PagesComponent,
    children: [
      {
        path: 'home',
        component: CreateComponent
      },
      {
        path: 'events',
        component: EventsComponent
      },
      {
        path: 'battle',
        component: BattleComponent
      }
    ]
  },
  {path: '', redirectTo: '/pages/home', pathMatch: 'full' },
  {path: '**', component: PageNotFoundComponent}
];

export const routing = RouterModule.forRoot(appRoutes);
