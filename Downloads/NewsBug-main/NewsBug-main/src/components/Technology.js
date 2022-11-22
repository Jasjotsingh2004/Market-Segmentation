import React, { Component } from 'react'
import News from './News'

export class Technology extends Component {
    render() {
        return (
            <News category={"Technology"} pagenum={10}/>
        )
    }
}

export default Technology