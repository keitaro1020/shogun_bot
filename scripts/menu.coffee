module.exports = (robot) ->
  date = new Date
  robot.hear /(メニュー|めにゅー|menu|Menu|MENU)/, (msg) ->
    msg.send 'http://bento-shogun.jp/menu/week/week.html'
    msg.send 'http://bento-shogun.jp/top/img/menu_large.jpg'
