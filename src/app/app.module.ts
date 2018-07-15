import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {BrowserModule} from '@angular/platform-browser';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {HttpClientModule, HTTP_INTERCEPTORS} from '@angular/common/http';

import {MomentModule} from 'ngx-moment';

import {AppComponent} from './app.component';
import {routing} from './app.routing';

import {
  Web3Service
} from './_services';

import {
  PageNotFoundComponent,
  BattleComponent,
  CreateComponent,
  EventsComponent,
  PagesComponent
} from './pages';


@NgModule({
  declarations: [
    AppComponent,
    PageNotFoundComponent,
    BattleComponent,
    CreateComponent,
    EventsComponent,
    PagesComponent
  ],
  imports: [
    BrowserModule,
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    HttpClientModule,
    MomentModule,
    routing
  ],
  providers: [
    Web3Service
  ],
  bootstrap: [AppComponent]
})
export class AppModule {
}
