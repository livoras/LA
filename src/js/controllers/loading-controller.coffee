# @author: Livoras
# @description: PageController can be used as super class of `page` or `cover`

{toBeImplemented} = require "../util.coffee"

class LoadingController extends EventEmitter2
    constructor: -> @$dom = null
    dismiss: (callback)-> toBeImplemented()

module.exports = LoadingController
