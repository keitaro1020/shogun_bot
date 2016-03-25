request = require('request')
cheerio = require('cheerio')

module.exports = (robot) ->
    date = new Date
    robot.hear /(メニュー|めにゅー|menu|Menu|MENU)/, (msg) ->
        request 'http://bento-shogun.jp/menu/week/week.html', (err, res, body) ->
            $ = cheerio.load body
            message = ''
            $('div.menu-inner').each ->
                message += $(this).children('span').text() + '\n'
                $(this).children('ul').children('li').each ->
                    menu = $(this).children('dl').children('dt').text()
                    if menu
                       message += '・' + menu + '\n'
                message += '\n'
            message += 'http://bento-shogun.jp/menu/week/week.html'
            msg.send message
#    robot.hear /(メニュー|めにゅー|menu|Menu|MENU)/, (msg) ->
#        msg.send 'http://bento-shogun.jp/menu/week/week.html'
