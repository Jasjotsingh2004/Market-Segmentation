import React, { Component } from 'react'
import News from './News'

export class Science extends Component {
    render() {
        return (
            <News category={"Science"} pagenum={10}/>
        )
    }
}

export default Science