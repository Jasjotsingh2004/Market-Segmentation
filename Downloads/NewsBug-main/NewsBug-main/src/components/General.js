import React, { Component } from 'react'
import News from './News'

export class General extends Component {
    render() {
        return (
            <News category={"General"} pagenum={10}/>
        )
    }
}

export default General