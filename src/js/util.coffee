log = ->
    console.log.apply console, arguments

each = (list, callback)->
    [].forEach.call list, callback

assert = (msg, statement)->
    if arguments.length is 1
        msg = ">>> Anonymous Test"
        statement = msg
    msg = "TEST: #{msg}"
    if statement
        console.log "%c#{msg} passed", "color: green;"
    else 
        console.log "%c#{msg} failed", "color: red;"

$ = window.$ = $$

module.exports = {$, log, each, assert}