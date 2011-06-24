module SiteHelper
  def color_code_sentiment(sentiment)
    sentiment = sentiment.to_f
    if sentiment < -2 then 
      return "doing_bad"
    elsif sentiment > -2 && @last_sentiment < 2 
      return "doing_ok"
    else
      return"doing_good"
    end
  end
end
