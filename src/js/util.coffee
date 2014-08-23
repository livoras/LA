$ = (selector)-> 
    doms = document.querySelectorAll selector
    if doms.length is 1 
        dom = doms[0]
        dom.on = ->
            dom.addEventListener.apply dom, arguments
        return doms[0]
    [].slice.call doms, 0

log = ->
    console.log.apply console, arguments

each = (list, callback)->
    [].forEach.call list, callback

module.exports = {$, log, each}