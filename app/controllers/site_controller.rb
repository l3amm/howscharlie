class SiteController < ApplicationController
  def index
  end

  def about
  end

  def search
    api_url = "http://:0gV8oFvfEuktVu@defgo.api.indextank.com"
    api = IndexTank::Client.new api_url
    index = api.indexes "howscharlie"
    index.functions(0, "-doc.var[0]").add
    
    results = index.search(params["query"], :function => 0, :fetch => "*");

    @num_matches = results['matches']
    @search_results = results['results']
    
    @dates = @search_results.collect { |s| [s["date"], Time.at(s["date"].to_i).strftime("%m/%d/%Y")] }
    @sentiment = @search_results.collect { |s| s["sentiment"] }
    @urls = @search_results.collect { |u| u["url"] }

    @last_sentiment = @sentiment.last.to_f
    
    if @last_sentiment < -2 then 
      @how_is = "bad"
      @how_is_class = "doing_bad"
    elsif @last_sentiment > -2 && @last_sentiment < 2 
      @how_is = "ok"
      @how_is_class = "doing_ok"
    else
      @how_is = "good"
      @how_is_class = "doing_good"
    end
    
    @latest_date = @dates.last[1]
  end
end
