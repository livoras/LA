(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var $, Cover, Loading, Page, Slide, colors, core, log, previous, processDom, run, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Slide = require("./slide/slide-effect.coffee");

_ref = LA.util, $ = _ref.$, log = _ref.log;

core = LA.core;

Page = (function(_super) {
  __extends(Page, _super);

  function Page(id) {
    this.$dom = $("<div><div>FUCK" + id + "</div></div>");
    processDom(this.$dom);
  }

  Page.prototype.start = function() {
    return log("start", this.id);
  };

  Page.prototype.stop = function() {
    return log("stop", this.id);
  };

  return Page;

})(LA.PageController);

Loading = (function(_super) {
  __extends(Loading, _super);

  function Loading() {
    this.$dom = $("<div><div>My Loading...</div></div>");
    processDom(this.$dom);
  }

  Loading.prototype.dismiss = function(callback) {
    return setTimeout((function(_this) {
      return function() {
        return TweenLite.to(_this.$dom, 0.5, {
          "opacity": 0,
          onComplete: callback
        });
      };
    })(this), 1000);
  };

  return Loading;

})(LA.LoadingController);

Cover = (function(_super) {
  __extends(Cover, _super);

  function Cover() {
    this.$dom = $("<div><div>Fucking Cover..</div></div>");
    processDom(this.$dom);
  }

  Cover.prototype.start = function() {
    var tl;
    tl = new TimelineMax;
    tl.to(this.$dom.find('div'), 1, {
      "y": 200
    });
    tl.to(this.$dom.find('div'), 0.5, {
      "x": 50
    });
    return this.$dom.on("tap", (function(_this) {
      return function() {
        return TweenLite.to(_this.$dom, 1, {
          "opacity": 0,
          onComplete: function() {
            return _this.emit("done");
          }
        });
      };
    })(this));
  };

  return Cover;

})(LA.PageController);

colors = ["#319574", "#b54322", "#484d79", "#c59820"];

previous = 0;

processDom = function($dom) {
  var now;
  now = Math.floor(Math.random() * colors.length);
  while (now === previous) {
    now = Math.floor(Math.random() * colors.length);
  }
  previous = now;
  $dom.css("width", "100%");
  $dom.css("height", "100%");
  $dom.css("backgroundColor", colors[now]);
  $dom.css("color", "#ccc");
  return $dom.find("div").css("padding", "10px");
};

run = function() {
  var cover, fakePage, i, loading, slide, _i;
  loading = new Loading;
  core.setLoading(loading);
  cover = new Cover;
  core.setCover(cover);
  for (i = _i = 1; _i <= 4; i = ++_i) {
    fakePage = new Page(i);
    core.addPage(fakePage);
  }
  fakePage = new Page('page 1');
  core.addPage(fakePage, 2);
  core.removePage(fakePage.id);
  slide = new Slide;
  return core.setSlide(slide);
};

run();



},{"./slide/slide-effect.coffee":2}],2:[function(require,module,exports){
var $, $window, CONTENT_HEIGHT, CONTENT_WIDTH, DURATION, MAX_Z_INDEX, Slide, currentIndex, dist, endY, log, nextIndex, prevIndex, startY, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ref = LA.util, $ = _ref.$, log = _ref.log;

MAX_Z_INDEX = 1000;

CONTENT_HEIGHT = window.innerHeight;

CONTENT_WIDTH = window.innerWidth;

$window = $(window);

startY = 0;

endY = 0;

dist = 0;

DURATION = 0.5;

currentIndex = 0;

prevIndex = 0;

nextIndex = 0;

Slide = (function(_super) {
  __extends(Slide, _super);

  function Slide() {
    this.curr = null;
    this.prev = null;
    this.next = null;
    this.able = false;
    this.isSwitching = false;
    this.isReachEnd = false;
    this.isFirstSetCurr = true;
  }

  Slide.prototype.init = function(pages) {
    this.pages = pages;
    pages.forEach(function(page, i) {
      return page.$container.css("zIndex", MAX_Z_INDEX - i);
    });
    currentIndex = 0;
    nextIndex = 1;
    prevIndex = -1;
    this._update();
    return this._initEvents();
  };

  Slide.prototype.enable = function() {
    return this.able = true;
  };

  Slide.prototype.disable = function() {
    return this.able = false;
  };

  Slide.prototype._initEvents = function() {
    $window.on("touchstart", (function(_this) {
      return function(event) {
        return startY = event.touches[0].clientY;
      };
    })(this));
    $window.on("touchmove", (function(_this) {
      return function(event) {
        endY = event.touches[0].clientY;
        dist = endY - startY;
        if (currentIndex === 0) {
          if (dist > 0 && !_this.isReachEnd) {
            return;
          }
        }
        if (_this.able && !_this.isSwitching) {
          return _this._slide();
        }
      };
    })(this));
    return $window.on("touchend", (function(_this) {
      return function() {
        if (_this.able) {
          if (_this._isReadyToSwitch()) {
            if (dist < 0) {
              return _this._switchUp();
            } else {
              if (currentIndex === 0 && !_this.isReachEnd) {
                return;
              }
              return _this._switchDown();
            }
          } else {
            return _this._back();
          }
        }
      };
    })(this));
  };

  Slide.prototype._slide = function() {
    if (dist < 0) {
      TweenMax.set(this.currPage.$container, {
        "y": dist
      });
      TweenMax.set(this.nextPage.$container, {
        "y": CONTENT_HEIGHT + dist
      });
    }
    if (dist > 0) {
      if (!this.prevPage) {
        return;
      }
      TweenMax.set(this.currPage.$container, {
        "y": dist
      });
      return TweenMax.set(this.prevPage.$container, {
        "y": -CONTENT_HEIGHT + dist
      });
    }
  };

  Slide.prototype._switchUp = function() {
    var check, count;
    this.isSwitching = true;
    this.emit("deactive", this.currPage);
    count = 0;
    check = (function(_this) {
      return function() {
        if (++count === 2) {
          _this._next();
          return _this.isSwitching = false;
        }
      };
    })(this);
    TweenMax.to(this.currPage.$container, DURATION, {
      "y": -CONTENT_HEIGHT,
      onComplete: check
    });
    return TweenMax.to(this.nextPage.$container, DURATION, {
      "y": 0,
      onComplete: check
    });
  };

  Slide.prototype._switchDown = function() {
    var check, count;
    this.isSwitching = true;
    this.emit("deactive", this.currPage);
    count = 0;
    check = (function(_this) {
      return function() {
        if (++count === 2) {
          _this._prev();
          return _this.isSwitching = false;
        }
      };
    })(this);
    TweenMax.to(this.currPage.$container, DURATION, {
      "y": CONTENT_HEIGHT,
      onComplete: check
    });
    return TweenMax.to(this.prevPage.$container, DURATION, {
      "y": 0,
      onComplete: check
    });
  };

  Slide.prototype._setNext = function(page) {
    if (!page) {
      return;
    }
    this.nextPage = page;
    return TweenMax.set(page.$container, {
      "y": CONTENT_HEIGHT
    });
  };

  Slide.prototype._setCurr = function(page) {
    var active;
    if (!page) {
      return;
    }
    this.currPage = page;
    TweenMax.set(page.$container, {
      "y": 0
    });
    active = (function(_this) {
      return function() {
        return _this.emit("active", page);
      };
    })(this);
    if (this.isFirstSetCurr) {
      this.isFirstSetCurr = false;
      LA.core.on("cover done", active);
      return;
    }
    return active();
  };

  Slide.prototype._setPrev = function(page) {
    if (!page) {
      return;
    }
    this.prevPage = page;
    return TweenMax.set(page.$container, {
      "y": -CONTENT_HEIGHT
    });
  };

  Slide.prototype._isReadyToSwitch = function() {
    return Math.abs(dist) > 50;
  };

  Slide.prototype._back = function() {
    var time;
    time = 0.3;
    if (this.currPage) {
      TweenMax.to(this.currPage.$container, time, {
        "y": 0
      });
    }
    if (this.prevPage) {
      TweenMax.to(this.prevPage.$container, time, {
        "y": -CONTENT_HEIGHT
      });
    }
    if (this.nextPage) {
      return TweenMax.to(this.nextPage.$container, time, {
        "y": CONTENT_HEIGHT
      });
    }
  };

  Slide.prototype._next = function() {
    prevIndex = currentIndex;
    currentIndex = nextIndex;
    nextIndex = currentIndex + 1 === this.pages.length ? 0 : currentIndex + 1;
    return this._update();
  };

  Slide.prototype._prev = function() {
    nextIndex = currentIndex;
    currentIndex = prevIndex;
    prevIndex = currentIndex - 1 === -1 ? this.pages.length - 1 : currentIndex - 1;
    return this._update();
  };

  Slide.prototype._update = function() {
    MAX_Z_INDEX += 4;
    this._setCurr(this.pages[currentIndex]);
    this._setPrev(this.pages[prevIndex]);
    this._setNext(this.pages[nextIndex]);
    if (currentIndex === this.pages.length - 1) {
      this.isReachEnd = true;
    }
    if (this.prevPage) {
      this.prevPage.$container.css("zIndex", MAX_Z_INDEX - 2);
    }
    if (this.currPage) {
      this.currPage.$container.css("zIndex", MAX_Z_INDEX - 1);
    }
    if (this.nextPage) {
      return this.nextPage.$container.css("zIndex", MAX_Z_INDEX);
    }
  };

  return Slide;

})(LA.SlideController);

module.exports = Slide;



},{}]},{},[1]);