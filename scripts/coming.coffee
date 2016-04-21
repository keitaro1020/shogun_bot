# Description:
#   comming API
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot 来た - bento shogun come here
#
# Author:
#   shishido

cronJob = require('cron').CronJob
moment = require('moment')

module.exports = (robot) ->
    new cronJob '0 40 12 * * 1-5', () =>
        envelope = room: "bento_shogun"
        robot.send envelope, '@channel: そろそろ将軍様が参られますぞ:shogun:'
    , null, true, "Asia/Tokyo"
    robot.respond /来た/, (msg) ->
        date = moment().utcOffset("Asia/Tokyo").local().toDate()
        if date.getHours() > 11 and date.getHours() < 14
            envelope = room: "bento_shogun"
            robot.send envelope, '@channel: 将軍様のおなーりー:shogun:'
        else
            msg.reply 'こんな時間に？'
