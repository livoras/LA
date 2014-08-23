{$, log, each} = require "./util.coffee"
PageController = require "./page-controller.coffee"

CONTENT_HEIGHT = window.innerHeight
CONTENT_WIDTH = window.innerWidth

prevPage = null
nextPage = null
currPage = null

startPoint = null
currPoint = null

MAX_Z_INDEX = 1000
pages = []

isMoving = no
isReachedEnd = no

DURATION = 0.5
READY_TOP = CONTENT_HEIGHT + 20

init = ->
    initPages()
    listenEvent()

initPages = ->
    $contents = $ ".content"
    $contents.forEach ($content, i)->
        page = new PageController $content
        page.index = i
        page.dom.style.zIndex = MAX_Z_INDEX - i
        pages.push page
    setCurrentPage pages[0]
    setNextPage pages[1]
    updateZindex()

listenEvent = ->    
    $body = $$ document.body
    $body.swiping swiping
    $body.swipeUp swipeUp
    $body.swipeDown swipeDown
    $body.on "touchstart", (event)-> 
        startPoint = event.touches[0].clientY

swiping = (event)->
    if isMoving then return
    currPoint = event.currentTouch.y
    GAP = 30
    dist = currPoint - startPoint
    if Math.abs(dist) < GAP then return
    if dist < 0
        nextPage.setPos nextPage.originTop + dist
    else if prevPage
        if currPage.index is 0 and not isReachedEnd then return
        currPage.setPos currPage.originTop + dist

swipeUp = (event)->
    if isMoving then return
    if Math.abs(currPoint - startPoint) > CONTENT_HEIGHT * 0.4
        isMoving = yes
        TweenLite.to nextPage.dom, DURATION, {"top": "0px", onComplete: next}
    else
        TweenLite.to nextPage.dom, DURATION, {"top": nextPage.originTop}

swipeDown = ->    
    if isMoving or not prevPage then return
    if currPage.index is 0 and not isReachedEnd then return
    if Math.abs(currPoint - startPoint) > CONTENT_HEIGHT * 0.4
        isMoving = yes
        TweenLite.to currPage.dom, DURATION, {"top": "#{READY_TOP}px", onComplete: prev}
    else
        TweenLite.to currPage.dom, DURATION, {"top": currPage.originTop}

next = ->
    setPrevPage currPage
    setCurrentPage nextPage
    index = if currPage.index + 1 is pages.length then 0 else currPage.index + 1
    setNextPage pages[index]
    isMoving = no
    updateZindex()

prev = ->
    setNextPage currPage
    setCurrentPage prevPage
    index = if currPage.index - 1 is -1 then pages.length - 1 else currPage.index - 1
    setPrevPage pages[index]
    isMoving = no
    updateZindex()

updateZindex = ->
    MAX_Z_INDEX += 4
    if nextPage then nextPage.dom.style.zIndex = MAX_Z_INDEX
    if currPage then currPage.dom.style.zIndex = MAX_Z_INDEX - 1
    if prevPage then prevPage.dom.style.zIndex = MAX_Z_INDEX - 2

setPrevPage = (page)->
    prevPage = page
    page.originTop = 0
    page.setPos 0

setCurrentPage = (page)->
    currPage = page
    page.originTop = 0
    page.setPos 0
    if page.index is pages.length - 1 then isReachedEnd = yes

setNextPage = (page)->
    nextPage = page
    page.originTop = READY_TOP
    page.setPos page.originTop

module.exports = {init}
