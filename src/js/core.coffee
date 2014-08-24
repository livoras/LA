{$, log} = require "./util.coffee"
wrapper = require "../tpl/wrapper.html"

$("body").prepend $(wrapper)

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
            @emit "cover done"
            if @slide then @slide.enable()

    setSlide: (slide)->
        @slide = slide
        slide.on "active", (page)=>
            page.start()
            @emit "active page", page
        slide.on "deactive", (page)=>
            page.stop()
            @emit "deactive page", page
        slide.init @pages

    addPage: (page, pos)->
        cid = page.id = @_getCid()
        @_listenLock page
        if pos
            @pages.splice pos, 0, page
            page.$container = @_addPageDom page.$dom, cid, pos
        else
            @pages.push page
            page.$container = @_addPageDom page.$dom, cid
        @emit "add page", page, pos
        cid

    removePage: (cid)->
        for page, i in @pages
            if page.id is cid
                @pages.splice i, 1
                @emit "remove page", page, i
                break
        $("#content-#{cid}").remove()

    _addPageDom: ($dom, cid, pos)-> 
        $newPage = $ "<section class='page content'></section>"
        $newPage.html $dom
        $container = $ "div.pages"
        $pages = $ "section.content"
        $newPage.attr "id", "content-#{cid}"
        $container[0].insertBefore $newPage[0], $pages[pos]
        $newPage

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

    _listenLock: (page)->    
        # Page may want some certain actions be done and 
        # does't want user to slide the page during actions.
        # For some cases, here provides some events
        # to the page to lock the slide.
        page.on "lock", => @slide.disable()
        page.on "unlock", => @slide.enable()

module.exports = new Core
