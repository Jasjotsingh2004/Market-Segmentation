import React, { Component } from 'react'
import News from './News'

export class Health extends Component {
    render() {
        return (
            <News category={"Health"} pagenum={10}/>
        )
    }
}

export default Health