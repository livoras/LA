EventEmitter2 = (require "eventemitter2").EventEmitter2
core = require "../src/js/core.coffee"
util = require "../src/js/util.coffee"
assert = require "./assert.coffee"
Slide = require "./slide-effect.coffee"
{$, log} = util

class Page extends EventEmitter2
    constructor: (id)->
        @$dom = $("<div><div>FUCK#{id}</div></div>")
        processDom @$dom
    start: -> log "start"
    stop: -> log "stop"

class Loading extends EventEmitter2
    constructor: ->
        @$dom = $("<div><div>My Loading...</div></div>")
        processDom @$dom
    dismiss: (callback)->
        # fake loading effect
        setTimeout =>
            TweenLite.to @$dom, 0.5, {"opacity": 0, onComplete: callback}
        , 1000

class Cover extends EventEmitter2
    constructor: ->
        @$dom = $("<div><div>Fucking Cover..</div></div>")
        processDom @$dom
    start: ->
        tl = new TimelineMax
        tl.to @$dom.find('div'), 1, {"y": 200}
        tl.to @$dom.find('div'), 0.5, {"x": 50}
        @$dom.on "tap", =>
            TweenLite.to @$dom, 1, {"opacity": 0, onComplete: => @emit "done"}

colors = ["#319574", "#b54322", "#484d79", "#c59820"]
previous = 0
processDom = ($dom)->
    now = Math.floor(Math.random() * colors.length)
    while now is previous
       now = Math.floor(Math.random() * colors.length)
    previous = now
    $dom.css "width", "100%"
    $dom.css "height", "100%"
    $dom.css "backgroundColor", colors[now]
    $dom.css "color", "#ccc"
    $dom.find("div").css "padding", "10px"

run = ->
    # test setting cover
    cover = new Cover
    core.setCover cover

    # test setting loading
    loading = new Loading
    core.setLoading loading

    # test adding page
    for i in [1..4]
        fakePage = new Page i
        core.addPage fakePage

    # test insert page
    fakePage = new Page 'page 1'
    core.addPage fakePage, 2

    # test remove page
    core.removePage fakePage.id

    # test setting slide
    slide = new Slide
    core.setSlide slide

exports.run = run