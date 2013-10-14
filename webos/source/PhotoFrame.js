(function() {
  var PhotoFrame;

  PhotoFrame = (function() {
    function PhotoFrame() {
      this.$frame = $("#photo-frame");
      this.images = new PhotoFrame.Images(this);
      this.loader = new PhotoFrame.Loader(this);
      this.controls = new PhotoFrame.Controls(this);
      this.loader.show();
      this.images.load();
      this.checkImages();
    }

    PhotoFrame.prototype.checkImages = function() {
      var _this = this;
      if (this.images.loaded()) {
        this.loader.hide();
        return this.images.show();
      } else {
        return window.setTimeout((function() {
          return _this.checkImages();
        }), 500);
      }
    };

    return PhotoFrame;

  })();

  window.PhotoFrame = PhotoFrame;

}).call(this);
(function() {
  PhotoFrame.Controls = (function() {
    function Controls(app) {
      this.app = app;
      this.showFor = 5000;
      this.showTo = 0;
      this.buildControls();
      this.listen();
    }

    Controls.prototype.buildControls = function($el) {
      this.$next = $(document.createElement("div"));
      this.$next.html("<button>next</button>");
      this.$next.addClass("next");
      this.$prev = $(document.createElement("div"));
      this.$prev.html("<button>prev</button>");
      this.$prev.addClass("prev");
      this.$pause = $(document.createElement("div"));
      this.$pause.html("<button>pause</button>");
      this.$pause.addClass("pause");
      this.$resume = $(document.createElement("div"));
      this.$resume.html("<button>resume</button>");
      this.$resume.addClass("resume");
      this.$controls = $(document.createElement("div"));
      this.$controls.addClass("controls");
      this.$controls.append(this.$next, this.$prev, this.$pause, this.$resume);
      return this.app.$frame.append(this.$controls);
    };

    Controls.prototype.listen = function($el) {
      var _this = this;
      this.app.$frame.click(function() {
        return _this.show();
      });
      this.$next.click(function() {
        return _this.app.images.next();
      });
      this.$prev.click(function() {
        return _this.app.images.prev();
      });
      this.$pause.click(function() {
        _this.app.images.pause();
        _this.$pause.hide();
        return _this.$resume.show();
      });
      return this.$resume.click(function() {
        _this.app.images.resume();
        _this.$resume.hide();
        return _this.$pause.show();
      });
    };

    Controls.prototype.show = function() {
      this.$controls.fadeIn();
      this.app.$frame.find(".photo-name").fadeIn();
      this.showTo = (new Date).getTime() + this.showFor;
      return this.fadeTimer();
    };

    Controls.prototype.fadeTimer = function() {
      var time,
        _this = this;
      time = (new Date).getTime();
      if (time >= this.showTo) {
        this.$controls.fadeOut();
        return this.app.$frame.find(".photo-name").fadeOut();
      } else {
        return window.setTimeout((function() {
          return _this.fadeTimer();
        }), this.showTo - time);
      }
    };

    return Controls;

  })();

}).call(this);
(function() {
  PhotoFrame.Images = (function() {
    function Images(app) {
      this.app = app;
      this.images = [];
      this.history = [];
      this.current = [];
      this.prefix = "http://carl.linkleaf.com:9292";
      this.path = "/fetch/";
      this.app.$frame.append('<div class="images"></div>');
      this.$images = this.app.$frame.find(".images");
      this.preloadTarget = 3;
      this.interval = 16000;
    }

    Images.prototype.show = function() {
      this.loadNext();
      return this.startTimer();
    };

    Images.prototype.hide = function() {
      this.stopTimer();
      return this.$images.fadeOut();
    };

    Images.prototype.pause = function() {
      return this.stopTimer();
    };

    Images.prototype.resume = function() {
      return this.show();
    };

    Images.prototype.next = function() {
      this.stopTimer();
      this.loadNext();
      return this.startTimer();
    };

    Images.prototype.prev = function() {
      var $cur, $prev, prev,
        _this = this;
      if (this.history.length > 0) {
        this.stopTimer();
        prev = this.history.pop();
        $prev = this.createImg(prev);
        this.$images.prepend($prev);
        $cur = this.$images.find(".image-container.current").first();
        $cur.removeClass("current");
        return $cur.fadeOut({
          duration: 500,
          complete: function() {
            _this.current.unshift(prev);
            _this.showImg($prev);
            return _this.startTimer();
          }
        });
      }
    };

    Images.prototype.load = function() {
      return this.loadImages();
    };

    Images.prototype.loadImages = function() {
      var _this = this;
      return $.getJSON(this.prefix + "/photos.json?callback=?", function(data) {
        var images;
        images = data.photos;
        _this.images.each(function(token) {
          return images.push(token);
        });
        _this.images = images;
        return _this.preload();
      });
    };

    Images.prototype.nextImage = function() {
      if (this.images.length < 10) {
        this.loadImages();
      }
      return this.images.pop();
    };

    Images.prototype.preload = function() {
      var n,
        _this = this;
      n = this.preloadTarget - this.$images.find(".image-container").length;
      return n.times(function() {
        var data;
        data = _this.nextImage();
        _this.current.push(data);
        return _this.$images.append(_this.createImg(data));
      });
    };

    Images.prototype.loadNext = function() {
      var $last, $next,
        _this = this;
      $last = this.$images.find(".image-container.current").first();
      $next = this.$images.find(".image-container:not(.current)").first();
      if ($last.length > 0) {
        $last.fadeOut({
          duration: 500,
          complete: function() {
            _this.addHistory(_this.current.shift());
            $last.remove();
            return _this.showImg($next);
          }
        });
      } else if ($next.length > 0) {
        this.showImg($next);
      }
      return $next;
    };

    Images.prototype.showImg = function($img) {
      $img.fadeIn({
        duration: 300
      });
      $img.addClass("current");
      return this.preload();
    };

    Images.prototype.createImg = function(info) {
      var $container, $img, $name, h, w;
      w = $(window).width();
      h = $(window).height();
      $img = $(document.createElement('img'));
      $img.attr("src", this.prefix + this.path + info.token + "?width=" + w + "&height=" + h);
      $name = $(document.createElement('div'));
      $name.addClass("photo-name");
      $name.text(info.path);
      $container = $(document.createElement('div'));
      $container.addClass("image-container");
      $container.append($name, $img);
      return $container;
    };

    Images.prototype.startTimer = function() {
      var _this = this;
      return this.timer = window.setInterval((function() {
        return _this.loadNext();
      }), this.interval);
    };

    Images.prototype.stopTimer = function() {
      return window.clearInterval(this.timer);
    };

    Images.prototype.loaded = function() {
      var $imgs, zeroes;
      $imgs = this.$images.find("img");
      zeroes = $imgs.filter(function() {
        return this.naturalHeight === 0;
      });
      return $imgs.length > 0 && zeroes.length === 0;
    };

    Images.prototype.addHistory = function(info) {
      var _results;
      this.history.push(info);
      _results = [];
      while (this.history.length > 100) {
        _results.push(this.history.shift());
      }
      return _results;
    };

    return Images;

  })();

}).call(this);
(function() {
  PhotoFrame.Loader = (function() {
    function Loader(app) {
      this.app = app;
      this.glowInterval = 1000;
      this.app.$frame.append('<div class="loader">Loading...</div>');
      this.$loader = this.app.$frame.find(".loader");
      this.showing = false;
      this.out = true;
    }

    Loader.prototype.show = function() {
      this.showing = true;
      this.$loader.fadeIn();
      return this.glow();
    };

    Loader.prototype.hide = function() {
      this.showing = false;
      return this.$loader.hide();
    };

    Loader.prototype.glow = function() {
      var css,
        _this = this;
      if (this.showing) {
        css = this.css();
        return this.$loader.animate(css, {
          duration: this.glowInterval,
          complete: (function() {
            return _this.glow();
          })
        });
      }
    };

    Loader.prototype.css = function() {
      if (this.out) {
        this.out = false;
        return {
          opacity: 0.9
        };
      } else {
        this.out = true;
        return {
          opacity: 0.1
        };
      }
    };

    return Loader;

  })();

}).call(this);
