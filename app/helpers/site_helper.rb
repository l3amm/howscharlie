module SiteHelper
  def color_code_sentiment(sentiment)
    sentiment = sentiment.to_f
    if sentiment < 0.36 then 
      return "doing_bad"
    elsif sentiment > 0.36 && @last_sentiment < 1.58 
      return "doing_ok"
    else
      return"doing_good"
    end
  end
end
