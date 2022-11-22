import React, { Component } from 'react'
import News from './News'

export class Business extends Component {
    render() {
        return (
            <News category={"Business"} pagenum={10}/>
        )
    }
}

export default Business