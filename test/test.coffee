EventEmitter2 = (require "eventemitter2").EventEmitter2
core = require "../src/js/lib/core.coffee"
util = require "../src/js/util.coffee"
{$, log, assert} = util

# loading = require "./loading.coffee"
# slideEffect = require "./slide-effect.coffee"

# loading.init()

# window.addEventListener "load", (event)->
#     slideEffect.init()
#     loading.remove()

class Page extends EventEmitter2
    constructor: (id)->
        @$dom = $("<div>FUCK#{id}</div>")
        processDom @$dom
    start: -> log "start"
    stop: -> log "stop"

class Loading extends EventEmitter2
    constructor: ->
        @$dom = $("<div>My Loading</div>")
        processDom @$dom
    dismiss: (callback)->
        TweenLite.to @$dom, 0.5, {"opacity": 0, onComplete: callback}

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
processDom = ($dom)->
    $dom.css "width", "100%"
    $dom.css "height", "100%"
    $dom.css "backgroundColor", colors[Math.floor(Math.random() * colors.length)]
    $dom.css "color", "#ccc"
    $dom.css "padding", "10px"

run = ->
    # test setting loading
    cover = new Cover
    core.setCover cover

    # test setting loading
    loading = new Loading
    core.setLoading loading

    # test adding page
    for i in [1..10]
        fakePage = new Page i
        core.addPage fakePage
    assert "There should be 10 doms", $("section.content").length is 10

    # test insert page
    fakePage = new Page 'page 1'
    core.addPage fakePage, 2
    assert "There should be 11 doms", $("section.content").length is 11
    assert "Dom should exit", $("#content-10").length is 1

    # test remove page
    core.removePage fakePage.id
    assert "There should be 10 doms", $("section.content").length is 10
    assert "Dom should not exit", $("#content-10").length is 0

exports.run = run