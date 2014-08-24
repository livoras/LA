tpl = require "./text.html"

class textPage extends LA.PageController
    constructor: (data)->
        @tpl = tpl
        @data = data or {}
        @render()
        @$padding = @$dom.find "div.padding"
        @_reset()

    start: ->    
        TweenMax.staggerTo @$padding, 1.5, {rotation: 0, scale:1, autoAlpha:1, ease: Elastic.easeInOut}

    stop: ->
        @_reset()
        
    _reset: ->
        TweenMax.set @$padding, {rotation: -180, scale:0, autoAlpha:0}

module.exports = textPage 