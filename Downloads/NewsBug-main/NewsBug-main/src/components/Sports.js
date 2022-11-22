import React, { Component } from 'react'
import News from './News'

export class Sports extends Component {
    render() {
        return (
            <News category={"Sports"} pagenum={10}/>
        )
    }
}

export default Sports