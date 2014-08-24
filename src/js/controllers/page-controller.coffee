# @author: Livoras
# @description: PageController can be used as super class of `page` or `cover`

{toBeImplemented} = require "../util.coffee"

class PageController extends EventEmitter2
    constructor: -> @$dom = null
    start: -> toBeImplemented()
    stop: -> toBeImplemented()
    render: ->  
        @compileFunc = template.compile(@tpl)
        @$dom = $(@compileFunc @data)

module.exports = PageController
