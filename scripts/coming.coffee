module.exports = (robot) ->
  date = new Date
  robot.respond /来た/, (msg) ->
    if date.getHours() > 11 and date.getHours() < 14
      envelope = room: "bento_shogun"
      robot.send envelope, '@channel: 将軍様のおなーりー:shogun:'
    else
      msg.reply 'こんな時間に？'
