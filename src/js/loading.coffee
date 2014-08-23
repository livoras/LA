{$, log} = require "./util.coffee"

init = ->
    log "Init Loading.."

remove = ->
    $loading = $(".loading")
    $loading.hide()
    log "Loading done, remove loading page."

module.exports = {init, remove}
