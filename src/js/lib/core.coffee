{$, log} = require "../util.coffee"
EventEmitter2 = (require "eventemitter2").EventEmitter2

class Core extends EventEmitter2
    constructor: ->
        @cid = 0
        @slide = null
        @loading = null
        @cover = null
        @pages = []
        @_dismissLoadingAfterLoaded()

    setLoading: (loading)->
        @loading = loading
        $loading = $("section.loading")
        $loading.html loading.$dom
        $loading.show()

    setCover: (cover)->
        @cover = cover
        $cover = $("section.cover")
        $cover.html cover.$dom
        $cover.show()
        @cover.on "done", => 
            $cover.hide()
            if @slide then @slide.enable()

    setSlide: (slide)->
        @slide = slide
        slide.init @pages
        slide.on "active", (page)=>
            page.start()
            @emit "active page", page
        slide.on "deactive", (page)=>
            page.stop()
            @emit "deactive page", page

    addPage: (page, pos)->
        cid = page.id = @_getCid()
        if pos
            @pages.splice pos, 0, page
            @_addPageDom page.$dom, cid, pos
        else
            @pages.push page
            @_addPageDom page.$dom, cid
        cid

    removePage: (cid)->
        $("#content-#{cid}").remove()

    _addPageDom: ($dom, cid, pos)-> 
        $newPage = $ "<section class='page content'></section>"
        $newPage.html $dom
        $container = $ "div.pages"
        $pages = $ "section.content"
        $newPage.attr "id", "content-#{cid}"
        $container[0].insertBefore $newPage[0], $pages[pos]

    _dismissLoadingAfterLoaded: ->
        $(window).on "load", =>
            if not @loading
                if @cover then @cover.start()
                return
            @loading.dismiss => 
                $("section.loading").hide()
                if @cover then @cover.start()
                
    _getCid: ->
        @cid++

module.exports = new Core
