(function() {
  var PhotoFrame,
    _this = this;

  PhotoFrame = (function() {
    function PhotoFrame() {
      this.images = new PhotoFrame.Images();
    }

    return PhotoFrame;

  })();

  window.PhotoFrame = PhotoFrame;

  $(function() {
    window.photos = new PhotoFrame();
    if (window.enyo && window.enyo.setFullScreen) {
      enyo.setFullScreen(true);
      return enyo.windows.setWindowProperties({
        blockScreenTimeout: true
      });
    }
  });

}).call(this);
(function() {
  PhotoFrame.Images = (function() {
    function Images() {
      var _this = this;
      this.images = [];
      this.prefix = "http://carl.linkleaf.com:9292";
      this.path = "/fetch/";
      this.$frame = $("#photo-frame");
      this.$name = $("#photo-name");
      this.preloadTarget = 3;
      this.showName = false;
      this.loadImages();
      this.$frame.click(function() {
        return _this.click();
      });
      window.setTimeout((function() {
        _this.loadNext();
        return _this.startTimer();
      }), 1000);
    }

    Images.prototype.click = function() {
      this.stopTimer();
      this.showName = true;
      this.loadNext();
      return this.startTimer();
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

    Images.prototype.next = function() {
      return this.images.pop();
    };

    Images.prototype.preload = function() {
      var n,
        _this = this;
      n = this.preloadTarget - this.$frame.find("img").length;
      return n.times(function() {
        return _this.$frame.append(_this.createImg(_this.next()));
      });
    };

    Images.prototype.loadNext = function() {
      var $last, $next,
        _this = this;
      $last = this.$frame.find("img.current").first();
      $next = this.$frame.find("img:not(.current)").first();
      if ($last.length > 0) {
        $last.fadeOut({
          duration: 500,
          complete: function() {
            _this.showImg($next);
            return $last.remove();
          }
        });
      } else if ($next.length > 0) {
        this.showImg($next);
      }
      return $next;
    };

    Images.prototype.showImg = function($img) {
      var ar, h, iar, ih, iw, left, top, w;
      w = $(window).width();
      h = $(window).height();
      ar = w / h;
      iw = $img.width();
      ih = $img.height();
      iar = iw / ih;
      if (iar > ar) {
        top = Math.round((h - (w / iar)) / 2);
        $img.width(w);
        $img.css({
          "margin-top": top + "px"
        });
      } else {
        left = Math.round((w - (h * iar)) / 2);
        $img.height(h);
        $img.css({
          "margin-left": left + "px"
        });
      }
      $img.fadeIn({
        duration: 300
      });
      if (this.showName) {
        this.$name.fadeIn({
          duration: 300
        });
        this.showName = false;
      } else {
        this.$name.hide();
      }
      $img.addClass("current");
      return this.preload();
    };

    Images.prototype.createImg = function(info) {
      var $img;
      $img = $(document.createElement('img'));
      $img.attr("src", this.prefix + this.path + info.token);
      this.$name.text(info.path);
      return $img;
    };

    Images.prototype.startTimer = function() {
      var _this = this;
      return this.timer = window.setInterval((function() {
        return _this.loadNext();
      }), 16000);
    };

    Images.prototype.stopTimer = function() {
      return window.clearInterval(this.timer);
    };

    return Images;

  })();

}).call(this);
