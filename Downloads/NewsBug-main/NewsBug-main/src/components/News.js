import React, { Component } from "react";
import PropTypes from 'prop-types'

import NewsItem from "./NewsItem";
import spinner from "./spinner";
export class News extends Component {
  static defaultProps={
       country:"in",
       category:"general",
       pagenum:1
  }
  static propTypes={
    country:PropTypes.string,
    category:PropTypes.string,
    pagenum:PropTypes.number
}  
 
  constructor(props) {
    super(props);
    this.state = {
      articles:[],
      loading:false,
      page:1,
    }
  }
   async componentDidMount(){
      let url=`https://newsapi.org/v2/everything?q=${this.props.category}&apiKey=f968f5afb67744079b3fb6876a7ec03e&pageSize=${this.props.pagenum}`;
      let data=await fetch(url);
      let parseData=await data.json();
      console.log(parseData)
      this.setState({
        articles:parseData.articles,
        page:1,
        totalArticle:parseData.totalResults
      })
    }
    handlenext=async ()=>{
    if(Math.ceil(this.state.totalArticle/this.props.pagenum)>this.state.page){
      let url=`https://newsapi.org/v2/top-headlines?q=${this.props.category}&apiKey=f968f5afb67744079b3fb6876a7ec03e&page=${this.state.page+1}&pageSize=${this.props.pagenum}`;
      let data=await fetch(url);
      let parseData=await data.json();
      this.setState({
        page:this.state.page+1,
        articles:parseData.articles,
      })
    }
    }
    handleprev=async ()=>{
      let url=`https://newsapi.org/v2/top-headlines?q=${this.props.category}&apiKey=f968f5afb67744079b3fb6876a7ec03e&page=${this.state.page-1}&pageSize=${this.props.pagenum}`;
      let data=await fetch(url);
      let parseData=await data.json();
      this.setState({
        page:this.state.page-1,
        articles:parseData.articles,
      })
          }
  render() {
    return(
      <div className="container my-4">
       
        <h2 className="text-center">NewsBug -{this.props.category} Section</h2>
        <div className="row my-3">
          {this.state.articles.map((element)=>{ 
            return <div className="col-md-4" key={element.url?element.url:element.urlToImage}><br></br>
                <NewsItem
                  title={element.title}
                  description={element.description} imgUrl={element.urlToImage?element.urlToImage:"https://www.bing.com/images/search?view=detailV2&ccid=VYBdXKXs&id=635E3652ACC1465F8A541BE51C0E74EC2243F8FF&thid=OIP.VYBdXKXsZgErD_YAwvOzvwHaE8&mediaurl=https%3a%2f%2fwesternnews.media.clients.ellingtoncms.com%2fimg%2fphotos%2f2018%2f08%2f07%2fBreaking_news_red.jpg&exph=4000&expw=6000&q=breaking+news+image&simid=608028633294521080&FORM=IRPRST&ck=2F6D5E82CC6F3294FE342A47127794B6&selectedIndex=2"} newsUrl={element.url}/>
              </div>
                })}
        </div>
        <div className="container d-flex justify-content-between">
        <button disabled={this.state.page<=1} type="button" className="btn btn-info" onClick={this.handleprev}> Previous</button>
        <button disabled={this.state.page==Math.ceil(this.state.totalArticle/this.props.pagenum)} type="button" className="btn btn-primary" onClick={this.handlenext}>Next</button>
        </div>
      </div>
    )
  }
}

export default News;