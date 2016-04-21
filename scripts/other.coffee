# Description:
#   sandbox
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot 仕事しろ - work
#   hubot :shogun: - :shogun:
#   hubot 手動 - ....
#   hubot 今何時 - servertime(JST)
#
# Author:
#   shishido
moment = require('moment')

module.exports = (robot) ->
  date = new Date
  robot.respond /仕事しろ/, (msg) ->
    if date.getHours() >= 19
      msg.reply 'もう定時すぎたぞ'
    else
      msg.reply 'お前もな'
  robot.hear /:shogun:/, (msg) ->
    msg.reply '呼んだ？:shogun:'
  robot.hear /手動/, (msg) ->
    msg.reply 'あかんのか？'
  robot.respond /ありがとう/, (msg) ->
    msg.reply 'ええんやで'
  robot.respond /おかえり/, (msg) ->
    msg.reply '戻ったぞ'
  robot.respond /TEST/, (msg) ->
    msg.reply 'またテストか'
  robot.respond /今何時/, (msg) ->
    date = moment().utcOffset("Asia/Tokyo").local().toDate()
    msg.reply date
