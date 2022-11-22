import React, { Component } from 'react'
import News from './News'

export class Entertainment extends Component {
    render() {
        return (
            <News category={"Entertainment"} pagenum={10}/>
        )
    }
}

export default Entertainment