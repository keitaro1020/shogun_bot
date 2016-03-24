config = 
    baseURL: 'https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=bentoshogun&exclude_replies=false&include_rts=false',
    authorization: 'Bearer ' + process.env.TWITTER_BEARER_TOKEN


module.exports = (robot) ->
    date = new Date
    robot.hear /(公式ツイッター)/, (msg) ->
        msg.send 'https://twitter.com/bentoshogun'
    robot.respond /(最新ツイート|new tweet)/, (msg) ->
        request = robot.http(config.baseURL + "&count=1")
            .header('Authorization', config.authorization)
            .get() 
        request (err, res, body) ->
            jsonArray = JSON.parse(body)
            if jsonArray.length > 0
                tweetId = jsonArray[0]['id_str']
                tweetURL = 'https://twitter.com/bentoshogun/status/' + tweetId
                msg.send tweetURL
            else
                msg.send '取得出来ませんでした'
