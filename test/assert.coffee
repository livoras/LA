assert = (msg, statement)->
    if arguments.length is 1
        msg = ">>> Anonymous Test"
        statement = msg
    msg = "TEST: #{msg}"
    if statement
        console.log "%c#{msg} passed", "color: green;"
    else 
        console.log "%c#{msg} failed", "color: red;"

module.exports = assert