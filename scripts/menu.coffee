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
#   hubot (メニュー|めにゅー|Menu|MENU) - Week menu
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

menukey = 'shogun_menu'

module.exports = (robot) ->
    robot.hear /(メニュー|めにゅー|Menu|MENU)/, (msg) ->
        request 'http://bento-shogun.jp/menu/week/week.html', (err, res, body) ->
            $ = cheerio.load body
            $('div.menu-inner').each ->
                message = ''
                message += $(this).children('span').text() + '\n'
                $(this).children('ul').children('li').each ->
                    menu = $(this).children('dl').children('dt').text()
                    if menu
                        message += '・' + menu + '\n'
                        robot.logger.info "menu data get [menu :" + menu + "]"
                    message += '\n'
                message += 'http://bento-shogun.jp/menu/week/week.html'
                msg.send message
    robot.respond /setupmenu/, (msg) ->
        robot.logger.info 'setupmenu'
        setupmenu()
    robot.respond /menulist/, (msg) ->
        robot.logger.info 'menulist'
        client = redis.createClient()
        client.hkeys menukey, (err, replies) ->
            message = '\n'
            replies.forEach((reply, i) ->
                message += reply
                message += '\n'
            )
            msg.reply message
    robot.respond /menu (.*)/i, (msg) ->
        target = msg.match[1]
        robot.logger.info 'menu ' + target
        client = redis.createClient()
        client.hget menukey, target, (err, reply) ->
            if err
                throw err
            else if reply
                msg.reply '\n' + reply
            else
                msg.reply '見つかりませんでした'
    new cronJob '0 40 9 * * 1-5', () =>
        robot.logger.info 'setupmenu cron execute'
        setupmenu()
    , null, true, "Asia/Tokyo"

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
            client = redis.createClient()
            client.del menukey
            client.hmset menukey, menuHash
            robot.logger.info menuHash
