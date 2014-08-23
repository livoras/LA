util = require "./util.coffee"
{$, log} = util

loading = require "./loading.coffee"
slideEffect = require "./slide-effect.coffee"

loading.init()

window.addEventListener "load", (event)->
    slideEffect.init()
    loading.remove()
