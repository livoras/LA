log = ->
    console.log.apply console, arguments

each = (list, callback)->
    [].forEach.call list, callback

$ = window.$ = $$

module.exports = {$, log, each}