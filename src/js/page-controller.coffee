EventEmitter2 = (require "eventemitter2").EventEmitter2
{log} = require "./util.coffee"

class PageController extends EventEmitter2
    constructor: (@dom)->
        @render()

    render: ->
        @dom.innerHTML += " rendered."
        @emit "render"

    start: ->
        log "start"
        @emit "start"

    stop: ->
        log "stop"
        @emit "stop"

    setPos: (top)->
        @dom.style.top = "#{top}px"


module.exports = PageController