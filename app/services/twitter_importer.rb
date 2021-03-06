# _dw write tests
class TwitterImporter

  attr_reader :tweet

  def initialize(tweet)
    @tweet = tweet
  end

  def import!
    RawTweet.create( tweet_id: tweet.id,
                     user_id: tweet.user.id,
                     username: tweet.user.screen_name,
                     hashtags: hashtags(tweet), # _dw _JON use the find_or_create_by hashtags and create a table.
                     text: tweet.text,
                     image: image_url(tweet)
                    )
  end

private

  def hashtags(t)
    tags = t.hashtags.map { |h| h.attrs[:text] }.join(",")
    if tags.present?
      tags
    else
      ""
    end
  end

  def image_url(t)
    if t.media.present?
      t.media.first.media_url_https.to_s
    else
      ""
    end
  end
end
