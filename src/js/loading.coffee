{$, log} = require "./util.coffee"

init = ->
    log "Init Loading.."

remove = ->
    $loading = $(".loading")
    $loading.style.display = "none"
    log "Loading done, remove loading page."

module.exports = {init, remove}
