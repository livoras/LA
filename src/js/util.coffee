log = ->
    console.log.apply console, arguments

toBeImplemented = ->
    throw "ERROR: Should Be Implemented!"

injectStyle = (styleStr)->
    $style = $ "<style></style>"
    $style.html styleStr
    $(document.body).append $style

getCurrentScript = ->    
    scripts = document.getElementsByTagName 'script'
    scripts[scripts.length - 1]

exports = (module)->    
    id = getCurrentDataId()
    LA.modules[id] = module

getCurrentDataId = ->
    $script = $ getCurrentScript()
    $script.attr "data-id"

$ = window.$ = $$

module.exports = {
    $, log, toBeImplemented, 
    injectStyle, getCurrentScript, exports
}
