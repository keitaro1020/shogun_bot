cronJob = require('cron').CronJob

module.exports = (robot) ->
    date = new Date
    new cronJob '0 45 12 * * 1-5', () =>
        envelope = room: "bento_shogun"
        robot.send envelope, '@channel: そろそろ将軍様が参られますぞ:shogun:'
    , null, true, "Asia/Tokyo"
    robot.respond /来た/, (msg) ->
        date = new Date
        if date.getHours() > 11 and date.getHours() < 14
            envelope = room: "bento_shogun"
            robot.send envelope, '@channel: 将軍様のおなーりー:shogun:'
        else
            msg.reply 'こんな時間に？'
