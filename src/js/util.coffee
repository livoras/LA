log = ->
    console.log.apply console, arguments

toBeImplemented = ->
    throw "ERROR: Should Be Implemented!"

$ = window.$ = $$

module.exports = {$, log, toBeImplemented}
