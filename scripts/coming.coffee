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
redis = require('redis')

if(process.env.REDIS_URL)
    rtg = url.parse(process.env.REDIS_URL)
    client = redis.createClient(rtg.port, rtg.hostname)
    client.auth(rtg.auth);
else
    client = redis.createClient()

module.exports = (robot) ->
    new cronJob '0 40 12 * * 1-5', () =>
        envelope = room: "bento_shogun"
        robot.send envelope, '@channel: そろそろ将軍様が参られますぞ:shogun:'
        date = moment().utcOffset("+09:00")
        target = (date.month() + 1) + '月' + date.date() + '日(' + days[date.day()] + ')'
        robot.logger.info 'getmenu target :' + target
        client.hget menukey, target, (err, reply) ->
            if err
                throw err
            else if reply
                robot.send envelope, '@channel: そろそろ将軍様が参られますぞ:shogun:'
    , null, true, "Asia/Tokyo"
    robot.respond /来た/, (msg) ->
        date = moment().utcOffset("+09:00")
        if date.hours() > 11 and date.hours() < 14
            envelope = room: "bento_shogun"
            robot.send envelope, '@channel: 将軍様のおなーりー:shogun:'
        else
            msg.reply 'こんな時間に？'

