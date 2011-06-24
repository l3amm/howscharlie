class SiteController < ApplicationController
  def index
  end

  def about
  end

  def no_results
  end
  
  def search
    api_url = "http://:0gV8oFvfEuktVu@defgo.api.indextank.com"
    api = IndexTank::Client.new api_url
    index = api.indexes "howscharlie"
    index.functions(0, "-doc.var[0]").add
    
    results = index.search(params["query"], :function => 0, :fetch => "*", :snippet => "text");

    @num_matches = results['matches']
    @search_results = results['results']
    
    if @search_results.length > 0
      @test_results = @search_results.sort {|x,y| x['date'] <=> y['date']}
      #week time interval 
      inter = 604800
      start_date = @test_results.first['date'].to_i
      end_date = @test_results.last['date'].to_i
      @week_data = Array.new((end_date - start_date)/inter) 
      @test_results.each {|res|
        week = (res['date'].to_i - start_date)/inter
        if @week_data[week].nil?
          @week_data[week] = [week, res['sentiment'].to_f, [res['docid']]]
        else
          @week_data[week][2].push(res['docid'])
          @week_data[week][1] += res['sentiment'].to_f
        end
      }
    
      @week_data.each {|date|
        if !(date.nil?)
          date[1] = date[1] / date[2].size
        end
      }
    
      @week_data = @week_data.compact.reject(&:blank?)
    
      #render :text => @week_data
    
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
    else
      redirect_to :action => "no_results"
    end
  end
end
