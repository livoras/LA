EventEmitter2 = (require "eventemitter2").EventEmitter2
{log} = require "./util.coffee"

class PageController extends EventEmitter2
    constructor: (@dom)->
        @render()

    render: ->
        @dom.innerHTML += " rendered."
        @emit "render"

    start: ->
        log "start", @index
        @emit "start"

    stop: ->
        log "stop", @index
        @emit "stop"

    setPos: (top)->
        TweenLite.set @dom, {"y": "#{top}px"}

module.exports = PageController