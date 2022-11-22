
import './App.css';
import Navbar from './components/Navbar';
import Business from './components/Business';
import Entertainment from './components/Entertainment';
import General from './components/General';
import Health from './components/Health';
import Science from './components/Science';
import Sports from './components/Sports';
import Technology from './components/Technology';
import React, { Component } from 'react'
import News from './components/News';
import { 
  BrowserRouter as Router, Route, Link, Switch} 
        from "react-router-dom";


export default class App extends Component {
  render() {
    return (
      <>
      <Router>
      <Navbar />
        <Switch>
        <Route exact path="/">
        <News pagenum={10} category="general" country={"in"}/>
          </Route>
          <Route exact path="/Business">
            <Business/>
          </Route>
          <Route exact path="/Entertainment">
            <Entertainment/>
          </Route>
          <Route exact path="/General">
            <General/>
          </Route>
          <Route exact path="/Health">
            <Health/>
          </Route>
          <Route exact path="/Science">
            <Science/>
          </Route>
          <Route exact path="/Sports">
            <Sports/>
          </Route>
          <Route exact path="/Technology">
            <Technology/>
          </Route>
        </Switch>
      </Router>

      </>
    )
  }
}

