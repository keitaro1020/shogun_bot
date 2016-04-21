# Description:
#   bento-shogun menu API
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot setupmenu - menu setup
#   hubot menulist - menu date listup
#   hubot menu <date> - get menu
#
# Author:
#   shishido

request = require('request')
cheerio = require('cheerio')
redis = require('redis')
cronJob = require('cron').CronJob
url = require('url')
moment = require('moment')

menukey = 'shogun_menu'
days = ["日", "月", "火", "水", "木", "金", "土"]

if(process.env.REDIS_URL)
    rtg = url.parse(process.env.REDIS_URL)
    client = redis.createClient(rtg.port, rtg.hostname)
    client.auth(rtg.auth);
else
    client = redis.createClient()


module.exports = (robot) ->
#    robot.hear /(メニュー|めにゅー|Menu|MENU)/, (msg) ->
#        request 'http://bento-shogun.jp/menu/week/week.html', (err, res, body) ->
#            $ = cheerio.load body
#            $('div.menu-inner').each ->
#                message = ''
#                message += $(this).children('span').text() + '\n'
#                $(this).children('ul').children('li').each ->
#                    menu = $(this).children('dl').children('dt').text()
#                    if menu
#                        message += '・' + menu + '\n'
#                        robot.logger.info "menu data get [menu :" + menu + "]"
#                    message += '\n'
#                message += 'http://bento-shogun.jp/menu/week/week.html'
#                msg.send message
    robot.respond /setupmenu/, (msg) ->
        robot.logger.info 'setupmenu'
        setupmenu()
    robot.respond /menulist/, (msg) ->
        robot.logger.info 'menulist'
        client.hkeys menukey, (err, replies) ->
            message = '\n'
            replies.forEach((reply, i) ->
                message += reply
                message += '\n'
            )
            msg.reply message
    robot.respond /menu (.*)/i, (msg) ->
        target = msg.match[1]
        getmenu(msg, target)
    new cronJob '0 40 9 * * 1-5', () =>
        robot.logger.info 'setupmenu cron execute'
        setupmenu()
    , null, true, "Asia/Tokyo"
    new cronJob '0 0 12 * * 1-5', (msg) ->
        date = moment().utcOffset("+09:00")
        target = (date.month() + 1) + '月' + date.date() + '日(' + days[date.day()] + ')'
        robot.logger.info 'menu cron ' + target
        client.hget menukey, target, (err, reply) ->
            if err
                throw err
            else if reply
                envelope = room: "bento_shogun"
                robot.send envelope, '@channel: 本日のお品書きにござる:shogun:\n' + reply
            else
                robot.logger.info 'menu not found'
    , null, true, "Asia/Tokyo"

    getmenu = (msg, target) ->
        if(target == 'today' || target == '今日')
            date = moment().utcOffset("+09:00")
            target = (date.month() + 1) + '月' + date.date() + '日(' + days[date.day()] + ')'
        else if(target == 'tomorrow' || target == '明日')
            tomorrow = moment().utcOffset("+09:00")
            tomorrow.add(1, 'd')
            target = (tomorrow.month() + 1) + '月' + tomorrow.date() + '日(' + days[tomorrow.day()] + ')'
        robot.logger.info 'menu ' + target
        client.hget menukey, target, (err, reply) ->
            if err
                throw err
            else if reply
                msg.reply '\n' + reply
            else
                msg.reply '見つかりませんでした'
                setupmenu()

    setupmenu = () ->
        robot.logger.info 'setupmenu func'
        request 'http://bento-shogun.jp/menu/week/week.html', (err, res, body) ->
            $ = cheerio.load body
            menuHash ={}
            $('div.menu-inner').each ->
                message = ''
                menuDate = $(this).children('span').text()
                robot.logger.info "menu data get [menuDate :" + menuDate + "]"
                message += $(this).children('span').text() + '\n'
                $(this).children('ul').children('li').each ->
                    menu = $(this).children('dl').children('dt').text()
                    if menu
                        message += '・' + menu + '\n'
                robot.logger.info "menu data get [menuDate :" + menuDate + "][menu :" + message + "]"
                key = menuDate
                menuHash[key] = message
            client.del menukey
            client.hmset menukey, menuHash
            robot.logger.info menuHash
