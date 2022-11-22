import React, { Component } from 'react'

export class NewsItem extends Component {
    
    render() {  
        let {title,description,imgUrl,newsUrl}=this.props; 
        return (
            <div>
                <div className="card">
                <img src={imgUrl} className="card-img-top" alt="..."  style={{height: "196px"}}/>
                    <div className="card-body">         
                    <h5 className="card-title">{this.props.title}</h5>
                        <p className="card-text">{this.props.description}</p>
                        <a href={newsUrl} target="_blank" className="btn btn-sm btn-primary">Read more</a>
                    </div>
                </div>
            </div>
        )
    }
}

export default NewsItem
