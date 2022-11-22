import React, { Component } from 'react'
import loading from "./loading.gif"
export class spinner extends Component {
    
    render() {
        return(
            <div class="text-center">
        <img src={loading}></img>
        </div>
        )
    }
}

export default spinner