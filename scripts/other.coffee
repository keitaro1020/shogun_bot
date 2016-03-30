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
#
# Author:
#   shishido

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
