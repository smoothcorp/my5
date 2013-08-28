/*!
 * jQuery corner plugin: simple corner rounding
 * Examples and documentation at: http://jquery.malsup.com/corner/
 * version 2.12 (23-MAY-2011)
 * Requires jQuery v1.3.2 or later
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * Authors: Dave Methvin and Mike Alsup
 */

/**
 *  corner() takes a single string argument:  $('#myDiv').corner("effect corners width")
 *
 *  effect:  name of the effect to apply, such as round, bevel, notch, bite, etc (default is round). 
 *  corners: one or more of: top, bottom, tr, tl, br, or bl.  (default is all corners)
 *  width:   width of the effect; in the case of rounded corners this is the radius. 
 *           specify this value using the px suffix such as 10px (yes, it must be pixels).
 */
;(function($) {

var style = document.createElement('div').style,
    moz = style['MozBorderRadius'] !== undefined,
    webkit = style['WebkitBorderRadius'] !== undefined,
    radius = style['borderRadius'] !== undefined || style['BorderRadius'] !== undefined,
    mode = document.documentMode || 0,
    noBottomFold = $.browser.msie && (($.browser.version < 8 && !mode) || mode < 8),

    expr = $.browser.msie && (function() {
        var div = document.createElement('div');
        try { div.style.setExpression('width','0+0'); div.style.removeExpression('width'); }
        catch(e) { return false; }
        return true;
    })();

$.support = $.support || {};
$.support.borderRadius = moz || webkit || radius; // so you can do:  if (!$.support.borderRadius) $('#myDiv').corner();

function sz(el, p) { 
    return parseInt($.css(el,p))||0; 
};
function hex2(s) {
    s = parseInt(s).toString(16);
    return ( s.length < 2 ) ? '0'+s : s;
};
function gpc(node) {
    while(node) {
        var v = $.css(node,'backgroundColor'), rgb;
        if (v && v != 'transparent' && v != 'rgba(0, 0, 0, 0)') {
            if (v.indexOf('rgb') >= 0) { 
                rgb = v.match(/\d+/g); 
                return '#'+ hex2(rgb[0]) + hex2(rgb[1]) + hex2(rgb[2]);
            }
            return v;
        }
        if (node.nodeName.toLowerCase() == 'html')
            break;
        node = node.parentNode; // keep walking if transparent
    }
    return '#ffffff';
};

function getWidth(fx, i, width) {
    switch(fx) {
    case 'round':  return Math.round(width*(1-Math.cos(Math.asin(i/width))));
    case 'cool':   return Math.round(width*(1+Math.cos(Math.asin(i/width))));
    case 'sharp':  return width-i;
    case 'bite':   return Math.round(width*(Math.cos(Math.asin((width-i-1)/width))));
    case 'slide':  return Math.round(width*(Math.atan2(i,width/i)));
    case 'jut':    return Math.round(width*(Math.atan2(width,(width-i-1))));
    case 'curl':   return Math.round(width*(Math.atan(i)));
    case 'tear':   return Math.round(width*(Math.cos(i)));
    case 'wicked': return Math.round(width*(Math.tan(i)));
    case 'long':   return Math.round(width*(Math.sqrt(i)));
    case 'sculpt': return Math.round(width*(Math.log((width-i-1),width)));
    case 'dogfold':
    case 'dog':    return (i&1) ? (i+1) : width;
    case 'dog2':   return (i&2) ? (i+1) : width;
    case 'dog3':   return (i&3) ? (i+1) : width;
    case 'fray':   return (i%2)*width;
    case 'notch':  return width; 
    case 'bevelfold':
    case 'bevel':  return i+1;
    case 'steep':  return i/2 + 1;
    case 'invsteep':return (width-i)/2+1;
    }
};

$.fn.corner = function(options) {
    // in 1.3+ we can fix mistakes with the ready state
    if (this.length == 0) {
        if (!$.isReady && this.selector) {
            var s = this.selector, c = this.context;
            $(function() {
                $(s,c).corner(options);
            });
        }
        return this;
    }

    return this.each(function(index){
        var $this = $(this),
            // meta values override options
            o = [$this.attr($.fn.corner.defaults.metaAttr) || '', options || ''].join(' ').toLowerCase(),
            keep = /keep/.test(o),                       // keep borders?
            cc = ((o.match(/cc:(#[0-9a-f]+)/)||[])[1]),  // corner color
            sc = ((o.match(/sc:(#[0-9a-f]+)/)||[])[1]),  // strip color
            width = parseInt((o.match(/(\d+)px/)||[])[1]) || 10, // corner width
            re = /round|bevelfold|bevel|notch|bite|cool|sharp|slide|jut|curl|tear|fray|wicked|sculpt|long|dog3|dog2|dogfold|dog|invsteep|steep/,
            fx = ((o.match(re)||['round'])[0]),
            fold = /dogfold|bevelfold/.test(o),
            edges = { T:0, B:1 },
            opts = {
                TL:  /top|tl|left/.test(o),       TR:  /top|tr|right/.test(o),
                BL:  /bottom|bl|left/.test(o),    BR:  /bottom|br|right/.test(o)
            },
            // vars used in func later
            strip, pad, cssHeight, j, bot, d, ds, bw, i, w, e, c, common, $horz;
        
        if ( !opts.TL && !opts.TR && !opts.BL && !opts.BR )
            opts = { TL:1, TR:1, BL:1, BR:1 };
            
        // support native rounding
        if ($.fn.corner.defaults.useNative && fx == 'round' && (radius || moz || webkit) && !cc && !sc) {
            if (opts.TL)
                $this.css(radius ? 'border-top-left-radius' : moz ? '-moz-border-radius-topleft' : '-webkit-border-top-left-radius', width + 'px');
            if (opts.TR)
                $this.css(radius ? 'border-top-right-radius' : moz ? '-moz-border-radius-topright' : '-webkit-border-top-right-radius', width + 'px');
            if (opts.BL)
                $this.css(radius ? 'border-bottom-left-radius' : moz ? '-moz-border-radius-bottomleft' : '-webkit-border-bottom-left-radius', width + 'px');
            if (opts.BR)
                $this.css(radius ? 'border-bottom-right-radius' : moz ? '-moz-border-radius-bottomright' : '-webkit-border-bottom-right-radius', width + 'px');
            return;
        }
            
        strip = document.createElement('div');
        $(strip).css({
            overflow: 'hidden',
            height: '1px',
            minHeight: '1px',
            fontSize: '1px',
            backgroundColor: sc || 'transparent',
            borderStyle: 'solid'
        });
    
        pad = {
            T: parseInt($.css(this,'paddingTop'))||0,     R: parseInt($.css(this,'paddingRight'))||0,
            B: parseInt($.css(this,'paddingBottom'))||0,  L: parseInt($.css(this,'paddingLeft'))||0
        };

        if (typeof this.style.zoom != undefined) this.style.zoom = 1; // force 'hasLayout' in IE
        if (!keep) this.style.border = 'none';
        strip.style.borderColor = cc || gpc(this.parentNode);
        cssHeight = $(this).outerHeight();

        for (j in edges) {
            bot = edges[j];
            // only add stips if needed
            if ((bot && (opts.BL || opts.BR)) || (!bot && (opts.TL || opts.TR))) {
                strip.style.borderStyle = 'none '+(opts[j+'R']?'solid':'none')+' none '+(opts[j+'L']?'solid':'none');
                d = document.createElement('div');
                $(d).addClass('jquery-corner');
                ds = d.style;

                bot ? this.appendChild(d) : this.insertBefore(d, this.firstChild);

                if (bot && cssHeight != 'auto') {
                    if ($.css(this,'position') == 'static')
                        this.style.position = 'relative';
                    ds.position = 'absolute';
                    ds.bottom = ds.left = ds.padding = ds.margin = '0';
                    if (expr)
                        ds.setExpression('width', 'this.parentNode.offsetWidth');
                    else
                        ds.width = '100%';
                }
                else if (!bot && $.browser.msie) {
                    if ($.css(this,'position') == 'static')
                        this.style.position = 'relative';
                    ds.position = 'absolute';
                    ds.top = ds.left = ds.right = ds.padding = ds.margin = '0';
                    
                    // fix ie6 problem when blocked element has a border width
                    if (expr) {
                        bw = sz(this,'borderLeftWidth') + sz(this,'borderRightWidth');
                        ds.setExpression('width', 'this.parentNode.offsetWidth - '+bw+'+ "px"');
                    }
                    else
                        ds.width = '100%';
                }
                else {
                    ds.position = 'relative';
                    ds.margin = !bot ? '-'+pad.T+'px -'+pad.R+'px '+(pad.T-width)+'px -'+pad.L+'px' : 
                                        (pad.B-width)+'px -'+pad.R+'px -'+pad.B+'px -'+pad.L+'px';                
                }

                for (i=0; i < width; i++) {
                    w = Math.max(0,getWidth(fx,i, width));
                    e = strip.cloneNode(false);
                    e.style.borderWidth = '0 '+(opts[j+'R']?w:0)+'px 0 '+(opts[j+'L']?w:0)+'px';
                    bot ? d.appendChild(e) : d.insertBefore(e, d.firstChild);
                }
                
                if (fold && $.support.boxModel) {
                    if (bot && noBottomFold) continue;
                    for (c in opts) {
                        if (!opts[c]) continue;
                        if (bot && (c == 'TL' || c == 'TR')) continue;
                        if (!bot && (c == 'BL' || c == 'BR')) continue;
                        
                        common = { position: 'absolute', border: 'none', margin: 0, padding: 0, overflow: 'hidden', backgroundColor: strip.style.borderColor };
                        $horz = $('<div/>').css(common).css({ width: width + 'px', height: '1px' });
                        switch(c) {
                        case 'TL': $horz.css({ bottom: 0, left: 0 }); break;
                        case 'TR': $horz.css({ bottom: 0, right: 0 }); break;
                        case 'BL': $horz.css({ top: 0, left: 0 }); break;
                        case 'BR': $horz.css({ top: 0, right: 0 }); break;
                        }
                        d.appendChild($horz[0]);
                        
                        var $vert = $('<div/>').css(common).css({ top: 0, bottom: 0, width: '1px', height: width + 'px' });
                        switch(c) {
                        case 'TL': $vert.css({ left: width }); break;
                        case 'TR': $vert.css({ right: width }); break;
                        case 'BL': $vert.css({ left: width }); break;
                        case 'BR': $vert.css({ right: width }); break;
                        }
                        d.appendChild($vert[0]);
                    }
                }
            }
        }
    });
};

$.fn.uncorner = function() { 
    if (radius || moz || webkit)
        this.css(radius ? 'border-radius' : moz ? '-moz-border-radius' : '-webkit-border-radius', 0);
    $('div.jquery-corner', this).remove();
    return this;
};

// expose options
$.fn.corner.defaults = {
    useNative: true, // true if plugin should attempt to use native browser support for border radius rounding
    metaAttr:  'data-corner' // name of meta attribute to use for options
};
    
})(jQuery);



/****************************************************************************
// Make Styled Text Fit with .textTruncate() and .textWidth() and JQuery
//
// JQuery 1.3.x plugins to truncate the styled text inside a page element
// until the pixel width is smaller than the goal width. Also adds a
// "title" attribute with the full text, for a tooltip on hover.
//
// Usage Example (given a div with an id of "element"):
//
//  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
//  <script type="text/javascript" src="jquery.truncate.js"></script>
//  <script type="text/javascript">
//    $(document).ready(function() {
//      var width = "250";
//      var marginText = "...";
//      $('#element').textTruncate(width,marginText);
//    });
//  </script>
//
// width = the desired pixel width
// marginText = optional text to use when truncating (default: "...")
//
// You may want to set the css to {visibility:hidden;} for the element
// by default in the CSS, so it won't initially flash at full width.
//
// Created by M. David Green (www.mdavidgreen.com) in 2009. Free to use for
// personal or commercial purposes under MIT (X11) license with no warranty
****************************************************************************/

(function ($) {
  // A plugin to truncate the text inside an element to a given width
  // This plugin depends on the textWidth() plugin, which should be below
  $.fn.textTruncate = function(width,marginText) {
    var that = this;
    var width = width || "250"; // default width of 250 px
    var marginText = marginText || "..."; // default margin text of "..."
    that.css("visibility","hidden"); // The element should be hidden in CSS
    return this.each(function () {
      // A table as a temporary dom element for measuring the text width
      $('body').append('<table id="textWidthMeasurer" style="padding:0;margin:0;border:0;width:auto;zoom:1;position:relative;"><tr style="padding:0;margin:0;border:0;"><td style="padding:0;margin:0;border:0;white-space:nowrap;">' + marginText + '</td></tr></table>');
      var measurer = $('#textWidthMeasurer');
      var margin = measurer.textWidth(measurer);
      if (that.textWidth(measurer) > width) {
        var contentLength = that.text().length;
        that.attr("title",that.text());
        while (that.textWidth(measurer) >= width - margin) {
          contentLength--;
          that.text(that.text().substring(0,contentLength));
        }
        that.text($.trim(that.text()) + marginText);
      }      
      // Make the element visible and remove the measuring table
      that.css("visibility","visible");
      $('#textWidthMeasurer').remove();
    });
  };
 
  // A helper plugin to get the width of the text inside an element
  $.fn.textWidth = function(context,css) {
    var that = this;
    var context = context || null;
    var css = css || null;
    // Optionally pass in an array of additional CSS properties to use for measuring
    var properties = ['font-family','font-weight','font-style','letter-spacing'];
    if ((css != null) && (css[0] != null)) {
      properties.concat(css);
    }
    // Establish a default context if none is passed in (slow)
    if (context == null) {
      if ($('#textWidthMeasurer') == null) {
        $('body').append('<table id="textWidthMeasurer" style="padding:0;margin:0;border:0;width:auto;zoom:1;position:relative;"><tr style="padding:0;margin:0;border:0;"><td style="padding:0;margin:0;border:0;white-space:nowrap;"></td></tr></table>');
      }
      var context = $('#textWidthMeasurer');
    }
    var target = $('td',context);
    // IE uses a bizarre formula to calculate the pixel value of font sizes:
    var fontSize = ($.browser.msie) ?
      Math.sqrt(parseFloat(that.css("font-size"))/16) + "em" :
      parseFloat(that.css("font-size"))/16 + "em";
    target.text(that.text()).css('font-size',fontSize);
    properties.forEach(function(property) {
      target.css(property,that.css(property));
    });
    var width = context.width();
    return width;
  };
})(jQuery);


(function($) {
  // @todo Document this.
  $.extend($,{ placeholder: {
      browser_supported: function() {
        return this._supported !== undefined ?
          this._supported :
          ( this._supported = !!('placeholder' in $('<input type="text">')[0]) );
      },
      shim: function(opts) {
        var config = {
          color: '#888',
          cls: 'placeholder',
          lr_padding:4,
          selector: 'input[placeholder], textarea[placeholder]'
        };
        $.extend(config,opts);
        !this.browser_supported() && $(config.selector)._placeholder_shim(config);
      }
  }});

  $.extend($.fn,{
    _placeholder_shim: function(config) {
      function calcPositionCss(target)
      {
        var op = $(target).offsetParent().offset();
        var ot = $(target).offset();

        return {
          top: ot.top - op.top + ($(target).outerHeight() - $(target).height()) /2,
          left: ot.left - op.left + config.lr_padding,
          width: $(target).width() - config.lr_padding
        };
      }
      return this.each(function() {
        if( $(this).data('placeholder') ) {
          var $ol = $(this).data('placeholder');
          $ol.css(calcPositionCss($(this)));
          return true;
        }

        var possible_line_height = {};
        if( $(this).css('height') != 'auto') {
          possible_line_height = { lineHeight: $(this).css('height') };
        }

        var ol = $('<label />')
          .text($(this).attr('placeholder'))
          .addClass(config.cls)
          .css($.extend({
            position:'absolute',
            display: 'inline',
            float:'none',
            overflow:'hidden',
            whiteSpace:'nowrap',
            textAlign: 'left',
            color: config.color,
            cursor: 'text',
            paddingTop: $(this).css('padding-top'),
            paddingLeft: $(this).css('padding-left'),
            fontSize: $(this).css('font-size'),
            fontFamily: $(this).css('font-family'),
            fontStyle: $(this).css('font-style'),
            fontWeight: $(this).css('font-weight'),
            textTransform: $(this).css('text-transform'),
            zIndex: 99
          }, possible_line_height))
          .css(calcPositionCss(this))
          .attr('for', this.id)
          .data('target',$(this))
          .click(function(){
            $(this).data('target').focus()
          })
          .insertBefore(this);
        $(this)
          .data('placeholder',ol)
          .focus(function(){
            ol.hide();
          }).blur(function() {
            ol[$(this).val().length ? 'hide' : 'show']();
          }).triggerHandler('blur');
        $(window)
          .resize(function() {
            var $target = ol.data('target')
            ol.css(calcPositionCss($target))
          });
      });
    }
  });
})(jQuery);

jQuery(document).add(window).bind('ready load', function() {
  if (jQuery.placeholder) {
    jQuery.placeholder.shim();
  }
});


/**
 * jquery.timer.js
 *
 * Copyright (c) 2011 Jason Chavannes <jason.chavannes@gmail.com>
 *
 * http://code.google.com/p/jquery-timer/
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

;(function($) {
        $.timer = function(func, time, autostart) {    
                this.set = function(func, time, autostart) {
                        this.init = true;
                        if(typeof func == 'object') {
                                var paramList = ['autostart', 'time'];
                                for(var arg in paramList) {
                                        if(func[paramList[arg]] != undefined) {
                                                eval(paramList[arg] + " = func[paramList[arg]]");
                                        }
                                };
                                func = func.action;
                        }
                        if(typeof func == 'function') {
                                this.action = func;
                        }
                        if(!isNaN(time)) {
                                this.intervalTime = time;
                        }
                        if(autostart && !this.active) {
                                this.active = true;
                                this.setTimer();
                        }
                        return this;
                };
                this.once = function(time) {
                        var timer = this;
                        if(isNaN(time)) {time = 0;}
                        window.setTimeout(function() {timer.action();}, time);
                        return this;
                };
                this.play = function() {
                        if(!this.active) {
                                this.active = true;
                                this.setTimer();
                        }
                        return this;
                };
                this.pause = function() {
                        this.active = false;
                        this.clearTimer();
                        return this;
                };
                this.stop = this.pause;
                this.toggle = function() {
                        if(this.active) {
                                this.pause();
                        } else {
                                this.play();
                        }
                        return this;
                };
                this.reset = function() {
                        this.pause().play();
                        return this;
                };
                this.clearTimer = function() {
                        window.clearTimeout(this.timeoutObject);
                };
                this.setTimer = function(time) {
                        if(typeof this.action != 'function') {return;}
                        if(isNaN(time)) {
                                time = this.intervalTime;
                        }
                        var timer = this;
                        this.clearTimer();
                        this.timeoutObject = window.setTimeout(function() {timer.go();}, time);
                };
                this.go = function() {
                        if(this.active) {
                                this.action();
                                this.setTimer();
                        }
                };
               
                if(this.init) {
                        return new $.timer(func, time, autostart);
                } else {
                        this.set(func, time, autostart);
                        return this;
                }
        };
})(jQuery);



/*!
 * jCarousel - Riding carousels with jQuery
 *   http://sorgalla.com/jcarousel/
 *
 * Copyright (c) 2006 Jan Sorgalla (http://sorgalla.com)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Built on top of the jQuery library
 *   http://jquery.com
 *
 * Inspired by the "Carousel Component" by Bill Scott
 *   http://billwscott.com/carousel/
 */

/*global window, jQuery */
(function($) {
    // Default configuration properties.
    var defaults = {
        vertical: false,
        rtl: false,
        start: 1,
        offset: 1,
        size: null,
        scroll: 3,
        visible: null,
        animation: 'normal',
        easing: 'swing',
        auto: 0,
        wrap: null,
        initCallback: null,
        setupCallback: null,
        reloadCallback: null,
        itemLoadCallback: null,
        itemFirstInCallback: null,
        itemFirstOutCallback: null,
        itemLastInCallback: null,
        itemLastOutCallback: null,
        itemVisibleInCallback: null,
        itemVisibleOutCallback: null,
        animationStepCallback: null,
        buttonNextHTML: '<div></div>',
        buttonPrevHTML: '<div></div>',
        buttonNextEvent: 'click',
        buttonPrevEvent: 'click',
        buttonNextCallback: null,
        buttonPrevCallback: null,
        itemFallbackDimension: null
    }, windowLoaded = false;

    $(window).bind('load.jcarousel', function() { windowLoaded = true; });

    /**
     * The jCarousel object.
     *
     * @constructor
     * @class jcarousel
     * @param e {HTMLElement} The element to create the carousel for.
     * @param o {Object} A set of key/value pairs to set as configuration properties.
     * @cat Plugins/jCarousel
     */
    $.jcarousel = function(e, o) {
        this.options    = $.extend({}, defaults, o || {});

        this.locked          = false;
        this.autoStopped     = false;

        this.container       = null;
        this.clip            = null;
        this.list            = null;
        this.buttonNext      = null;
        this.buttonPrev      = null;
        this.buttonNextState = null;
        this.buttonPrevState = null;

        // Only set if not explicitly passed as option
        if (!o || o.rtl === undefined) {
            this.options.rtl = ($(e).attr('dir') || $('html').attr('dir') || '').toLowerCase() == 'rtl';
        }

        this.wh = !this.options.vertical ? 'width' : 'height';
        this.lt = !this.options.vertical ? (this.options.rtl ? 'right' : 'left') : 'top';

        // Extract skin class
        var skin = '', split = e.className.split(' ');

        for (var i = 0; i < split.length; i++) {
            if (split[i].indexOf('jcarousel-skin') != -1) {
                $(e).removeClass(split[i]);
                skin = split[i];
                break;
            }
        }

        if (e.nodeName.toUpperCase() == 'UL' || e.nodeName.toUpperCase() == 'OL') {
            this.list      = $(e);
            this.clip      = this.list.parents('.jcarousel-clip');
            this.container = this.list.parents('.jcarousel-container');
        } else {
            this.container = $(e);
            this.list      = this.container.find('ul,ol').eq(0);
            this.clip      = this.container.find('.jcarousel-clip');
        }

        if (this.clip.size() === 0) {
            this.clip = this.list.wrap('<div></div>').parent();
        }

        if (this.container.size() === 0) {
            this.container = this.clip.wrap('<div></div>').parent();
        }

        if (skin !== '' && this.container.parent()[0].className.indexOf('jcarousel-skin') == -1) {
            this.container.wrap('<div class=" '+ skin + '"></div>');
        }

        this.buttonPrev = $('.jcarousel-prev', this.container);

        if (this.buttonPrev.size() === 0 && this.options.buttonPrevHTML !== null) {
            this.buttonPrev = $(this.options.buttonPrevHTML).appendTo(this.container);
        }

        this.buttonPrev.addClass(this.className('jcarousel-prev'));

        this.buttonNext = $('.jcarousel-next', this.container);

        if (this.buttonNext.size() === 0 && this.options.buttonNextHTML !== null) {
            this.buttonNext = $(this.options.buttonNextHTML).appendTo(this.container);
        }

        this.buttonNext.addClass(this.className('jcarousel-next'));

        this.clip.addClass(this.className('jcarousel-clip')).css({
            position: 'relative'
        });

        this.list.addClass(this.className('jcarousel-list')).css({
            overflow: 'hidden',
            position: 'relative',
            top: 0,
            margin: 0,
            padding: 0
        }).css((this.options.rtl ? 'right' : 'left'), 0);

        this.container.addClass(this.className('jcarousel-container')).css({
            position: 'relative'
        });

        if (!this.options.vertical && this.options.rtl) {
            this.container.addClass('jcarousel-direction-rtl').attr('dir', 'rtl');
        }

        var di = this.options.visible !== null ? Math.ceil(this.clipping() / this.options.visible) : null;
        var li = this.list.children('li');

        var self = this;

        if (li.size() > 0) {
            var wh = 0, j = this.options.offset;
            li.each(function() {
                self.format(this, j++);
                wh += self.dimension(this, di);
            });

            this.list.css(this.wh, (wh + 100) + 'px');

            // Only set if not explicitly passed as option
            if (!o || o.size === undefined) {
                this.options.size = li.size();
            }
        }

        // For whatever reason, .show() does not work in Safari...
        this.container.css('display', 'block');
        this.buttonNext.css('display', 'block');
        this.buttonPrev.css('display', 'block');

        this.funcNext   = function() { self.next(); };
        this.funcPrev   = function() { self.prev(); };
        this.funcResize = function() { 
            if (self.resizeTimer) {
                clearTimeout(self.resizeTimer);
            }

            self.resizeTimer = setTimeout(function() {
                self.reload();
            }, 100);
        };

        if (this.options.initCallback !== null) {
            this.options.initCallback(this, 'init');
        }

        if (!windowLoaded && $.browser.safari) {
            this.buttons(false, false);
            $(window).bind('load.jcarousel', function() { self.setup(); });
        } else {
            this.setup();
        }
    };

    // Create shortcut for internal use
    var $jc = $.jcarousel;

    $jc.fn = $jc.prototype = {
        jcarousel: '0.2.8'
    };

    $jc.fn.extend = $jc.extend = $.extend;

    $jc.fn.extend({
        /**
         * Setups the carousel.
         *
         * @method setup
         * @return undefined
         */
        setup: function() {
            this.first       = null;
            this.last        = null;
            this.prevFirst   = null;
            this.prevLast    = null;
            this.animating   = false;
            this.timer       = null;
            this.resizeTimer = null;
            this.tail        = null;
            this.inTail      = false;

            if (this.locked) {
                return;
            }

            this.list.css(this.lt, this.pos(this.options.offset) + 'px');
            var p = this.pos(this.options.start, true);
            this.prevFirst = this.prevLast = null;
            this.animate(p, false);

            $(window).unbind('resize.jcarousel', this.funcResize).bind('resize.jcarousel', this.funcResize);

            if (this.options.setupCallback !== null) {
                this.options.setupCallback(this);
            }
        },

        /**
         * Clears the list and resets the carousel.
         *
         * @method reset
         * @return undefined
         */
        reset: function() {
            this.list.empty();

            this.list.css(this.lt, '0px');
            this.list.css(this.wh, '10px');

            if (this.options.initCallback !== null) {
                this.options.initCallback(this, 'reset');
            }

            this.setup();
        },

        /**
         * Reloads the carousel and adjusts positions.
         *
         * @method reload
         * @return undefined
         */
        reload: function() {
            if (this.tail !== null && this.inTail) {
                this.list.css(this.lt, $jc.intval(this.list.css(this.lt)) + this.tail);
            }

            this.tail   = null;
            this.inTail = false;

            if (this.options.reloadCallback !== null) {
                this.options.reloadCallback(this);
            }

            if (this.options.visible !== null) {
                var self = this;
                var di = Math.ceil(this.clipping() / this.options.visible), wh = 0, lt = 0;
                this.list.children('li').each(function(i) {
                    wh += self.dimension(this, di);
                    if (i + 1 < self.first) {
                        lt = wh;
                    }
                });

                this.list.css(this.wh, wh + 'px');
                this.list.css(this.lt, -lt + 'px');
            }

            this.scroll(this.first, false);
        },

        /**
         * Locks the carousel.
         *
         * @method lock
         * @return undefined
         */
        lock: function() {
            this.locked = true;
            this.buttons();
        },

        /**
         * Unlocks the carousel.
         *
         * @method unlock
         * @return undefined
         */
        unlock: function() {
            this.locked = false;
            this.buttons();
        },

        /**
         * Sets the size of the carousel.
         *
         * @method size
         * @return undefined
         * @param s {Number} The size of the carousel.
         */
        size: function(s) {
            if (s !== undefined) {
                this.options.size = s;
                if (!this.locked) {
                    this.buttons();
                }
            }

            return this.options.size;
        },

        /**
         * Checks whether a list element exists for the given index (or index range).
         *
         * @method get
         * @return bool
         * @param i {Number} The index of the (first) element.
         * @param i2 {Number} The index of the last element.
         */
        has: function(i, i2) {
            if (i2 === undefined || !i2) {
                i2 = i;
            }

            if (this.options.size !== null && i2 > this.options.size) {
                i2 = this.options.size;
            }

            for (var j = i; j <= i2; j++) {
                var e = this.get(j);
                if (!e.length || e.hasClass('jcarousel-item-placeholder')) {
                    return false;
                }
            }

            return true;
        },

        /**
         * Returns a jQuery object with list element for the given index.
         *
         * @method get
         * @return jQuery
         * @param i {Number} The index of the element.
         */
        get: function(i) {
            return $('>.jcarousel-item-' + i, this.list);
        },

        /**
         * Adds an element for the given index to the list.
         * If the element already exists, it updates the inner html.
         * Returns the created element as jQuery object.
         *
         * @method add
         * @return jQuery
         * @param i {Number} The index of the element.
         * @param s {String} The innerHTML of the element.
         */
        add: function(i, s) {
            var e = this.get(i), old = 0, n = $(s);

            if (e.length === 0) {
                var c, j = $jc.intval(i);
                e = this.create(i);
                while (true) {
                    c = this.get(--j);
                    if (j <= 0 || c.length) {
                        if (j <= 0) {
                            this.list.prepend(e);
                        } else {
                            c.after(e);
                        }
                        break;
                    }
                }
            } else {
                old = this.dimension(e);
            }

            if (n.get(0).nodeName.toUpperCase() == 'LI') {
                e.replaceWith(n);
                e = n;
            } else {
                e.empty().append(s);
            }

            this.format(e.removeClass(this.className('jcarousel-item-placeholder')), i);

            var di = this.options.visible !== null ? Math.ceil(this.clipping() / this.options.visible) : null;
            var wh = this.dimension(e, di) - old;

            if (i > 0 && i < this.first) {
                this.list.css(this.lt, $jc.intval(this.list.css(this.lt)) - wh + 'px');
            }

            this.list.css(this.wh, $jc.intval(this.list.css(this.wh)) + wh + 'px');

            return e;
        },

        /**
         * Removes an element for the given index from the list.
         *
         * @method remove
         * @return undefined
         * @param i {Number} The index of the element.
         */
        remove: function(i) {
            var e = this.get(i);

            // Check if item exists and is not currently visible
            if (!e.length || (i >= this.first && i <= this.last)) {
                return;
            }

            var d = this.dimension(e);

            if (i < this.first) {
                this.list.css(this.lt, $jc.intval(this.list.css(this.lt)) + d + 'px');
            }

            e.remove();

            this.list.css(this.wh, $jc.intval(this.list.css(this.wh)) - d + 'px');
        },

        /**
         * Moves the carousel forwards.
         *
         * @method next
         * @return undefined
         */
        next: function() {
            if (this.tail !== null && !this.inTail) {
                this.scrollTail(false);
            } else {
                this.scroll(((this.options.wrap == 'both' || this.options.wrap == 'last') && this.options.size !== null && this.last == this.options.size) ? 1 : this.first + this.options.scroll);
            }
        },

        /**
         * Moves the carousel backwards.
         *
         * @method prev
         * @return undefined
         */
        prev: function() {
            if (this.tail !== null && this.inTail) {
                this.scrollTail(true);
            } else {
                this.scroll(((this.options.wrap == 'both' || this.options.wrap == 'first') && this.options.size !== null && this.first == 1) ? this.options.size : this.first - this.options.scroll);
            }
        },

        /**
         * Scrolls the tail of the carousel.
         *
         * @method scrollTail
         * @return undefined
         * @param b {Boolean} Whether scroll the tail back or forward.
         */
        scrollTail: function(b) {
            if (this.locked || this.animating || !this.tail) {
                return;
            }

            this.pauseAuto();

            var pos  = $jc.intval(this.list.css(this.lt));

            pos = !b ? pos - this.tail : pos + this.tail;
            this.inTail = !b;

            // Save for callbacks
            this.prevFirst = this.first;
            this.prevLast  = this.last;

            this.animate(pos);
        },

        /**
         * Scrolls the carousel to a certain position.
         *
         * @method scroll
         * @return undefined
         * @param i {Number} The index of the element to scoll to.
         * @param a {Boolean} Flag indicating whether to perform animation.
         */
        scroll: function(i, a) {
            if (this.locked || this.animating) {
                return;
            }

            this.pauseAuto();
            this.animate(this.pos(i), a);
        },

        /**
         * Prepares the carousel and return the position for a certian index.
         *
         * @method pos
         * @return {Number}
         * @param i {Number} The index of the element to scoll to.
         * @param fv {Boolean} Whether to force last item to be visible.
         */
        pos: function(i, fv) {
            var pos  = $jc.intval(this.list.css(this.lt));

            if (this.locked || this.animating) {
                return pos;
            }

            if (this.options.wrap != 'circular') {
                i = i < 1 ? 1 : (this.options.size && i > this.options.size ? this.options.size : i);
            }

            var back = this.first > i;

            // Create placeholders, new list width/height
            // and new list position
            var f = this.options.wrap != 'circular' && this.first <= 1 ? 1 : this.first;
            var c = back ? this.get(f) : this.get(this.last);
            var j = back ? f : f - 1;
            var e = null, l = 0, p = false, d = 0, g;

            while (back ? --j >= i : ++j < i) {
                e = this.get(j);
                p = !e.length;
                if (e.length === 0) {
                    e = this.create(j).addClass(this.className('jcarousel-item-placeholder'));
                    c[back ? 'before' : 'after' ](e);

                    if (this.first !== null && this.options.wrap == 'circular' && this.options.size !== null && (j <= 0 || j > this.options.size)) {
                        g = this.get(this.index(j));
                        if (g.length) {
                            e = this.add(j, g.clone(true));
                        }
                    }
                }

                c = e;
                d = this.dimension(e);

                if (p) {
                    l += d;
                }

                if (this.first !== null && (this.options.wrap == 'circular' || (j >= 1 && (this.options.size === null || j <= this.options.size)))) {
                    pos = back ? pos + d : pos - d;
                }
            }

            // Calculate visible items
            var clipping = this.clipping(), cache = [], visible = 0, v = 0;
            c = this.get(i - 1);
            j = i;

            while (++visible) {
                e = this.get(j);
                p = !e.length;
                if (e.length === 0) {
                    e = this.create(j).addClass(this.className('jcarousel-item-placeholder'));
                    // This should only happen on a next scroll
                    if (c.length === 0) {
                        this.list.prepend(e);
                    } else {
                        c[back ? 'before' : 'after' ](e);
                    }

                    if (this.first !== null && this.options.wrap == 'circular' && this.options.size !== null && (j <= 0 || j > this.options.size)) {
                        g = this.get(this.index(j));
                        if (g.length) {
                            e = this.add(j, g.clone(true));
                        }
                    }
                }

                c = e;
                d = this.dimension(e);
                if (d === 0) {
                    throw new Error('jCarousel: No width/height set for items. This will cause an infinite loop. Aborting...');
                }

                if (this.options.wrap != 'circular' && this.options.size !== null && j > this.options.size) {
                    cache.push(e);
                } else if (p) {
                    l += d;
                }

                v += d;

                if (v >= clipping) {
                    break;
                }

                j++;
            }

             // Remove out-of-range placeholders
            for (var x = 0; x < cache.length; x++) {
                cache[x].remove();
            }

            // Resize list
            if (l > 0) {
                this.list.css(this.wh, this.dimension(this.list) + l + 'px');

                if (back) {
                    pos -= l;
                    this.list.css(this.lt, $jc.intval(this.list.css(this.lt)) - l + 'px');
                }
            }

            // Calculate first and last item
            var last = i + visible - 1;
            if (this.options.wrap != 'circular' && this.options.size && last > this.options.size) {
                last = this.options.size;
            }

            if (j > last) {
                visible = 0;
                j = last;
                v = 0;
                while (++visible) {
                    e = this.get(j--);
                    if (!e.length) {
                        break;
                    }
                    v += this.dimension(e);
                    if (v >= clipping) {
                        break;
                    }
                }
            }

            var first = last - visible + 1;
            if (this.options.wrap != 'circular' && first < 1) {
                first = 1;
            }

            if (this.inTail && back) {
                pos += this.tail;
                this.inTail = false;
            }

            this.tail = null;
            if (this.options.wrap != 'circular' && last == this.options.size && (last - visible + 1) >= 1) {
                var m = $jc.intval(this.get(last).css(!this.options.vertical ? 'marginRight' : 'marginBottom'));
                if ((v - m) > clipping) {
                    this.tail = v - clipping - m;
                }
            }

            if (fv && i === this.options.size && this.tail) {
                pos -= this.tail;
                this.inTail = true;
            }

            // Adjust position
            while (i-- > first) {
                pos += this.dimension(this.get(i));
            }

            // Save visible item range
            this.prevFirst = this.first;
            this.prevLast  = this.last;
            this.first     = first;
            this.last      = last;

            return pos;
        },

        /**
         * Animates the carousel to a certain position.
         *
         * @method animate
         * @return undefined
         * @param p {Number} Position to scroll to.
         * @param a {Boolean} Flag indicating whether to perform animation.
         */
        animate: function(p, a) {
            if (this.locked || this.animating) {
                return;
            }

            this.animating = true;

            var self = this;
            var scrolled = function() {
                self.animating = false;

                if (p === 0) {
                    self.list.css(self.lt,  0);
                }

                if (!self.autoStopped && (self.options.wrap == 'circular' || self.options.wrap == 'both' || self.options.wrap == 'last' || self.options.size === null || self.last < self.options.size || (self.last == self.options.size && self.tail !== null && !self.inTail))) {
                    self.startAuto();
                }

                self.buttons();
                self.notify('onAfterAnimation');

                // This function removes items which are appended automatically for circulation.
                // This prevents the list from growing infinitely.
                if (self.options.wrap == 'circular' && self.options.size !== null) {
                    for (var i = self.prevFirst; i <= self.prevLast; i++) {
                        if (i !== null && !(i >= self.first && i <= self.last) && (i < 1 || i > self.options.size)) {
                            self.remove(i);
                        }
                    }
                }
            };

            this.notify('onBeforeAnimation');

            // Animate
            if (!this.options.animation || a === false) {
                this.list.css(this.lt, p + 'px');
                scrolled();
            } else {
                var o = !this.options.vertical ? (this.options.rtl ? {'right': p} : {'left': p}) : {'top': p};
                // Define animation settings.
                var settings = {
                    duration: this.options.animation,
                    easing:   this.options.easing,
                    complete: scrolled
                };
                // If we have a step callback, specify it as well.
                if ($.isFunction(this.options.animationStepCallback)) {
                    settings.step = this.options.animationStepCallback;
                }
                // Start the animation.
                this.list.animate(o, settings);
            }
        },

        /**
         * Starts autoscrolling.
         *
         * @method auto
         * @return undefined
         * @param s {Number} Seconds to periodically autoscroll the content.
         */
        startAuto: function(s) {
            if (s !== undefined) {
                this.options.auto = s;
            }

            if (this.options.auto === 0) {
                return this.stopAuto();
            }

            if (this.timer !== null) {
                return;
            }

            this.autoStopped = false;

            var self = this;
            this.timer = window.setTimeout(function() { self.next(); }, this.options.auto * 1000);
        },

        /**
         * Stops autoscrolling.
         *
         * @method stopAuto
         * @return undefined
         */
        stopAuto: function() {
            this.pauseAuto();
            this.autoStopped = true;
        },

        /**
         * Pauses autoscrolling.
         *
         * @method pauseAuto
         * @return undefined
         */
        pauseAuto: function() {
            if (this.timer === null) {
                return;
            }

            window.clearTimeout(this.timer);
            this.timer = null;
        },

        /**
         * Sets the states of the prev/next buttons.
         *
         * @method buttons
         * @return undefined
         */
        buttons: function(n, p) {
            if (n == null) {
                n = !this.locked && this.options.size !== 0 && ((this.options.wrap && this.options.wrap != 'first') || this.options.size === null || this.last < this.options.size);
                if (!this.locked && (!this.options.wrap || this.options.wrap == 'first') && this.options.size !== null && this.last >= this.options.size) {
                    n = this.tail !== null && !this.inTail;
                }
            }

            if (p == null) {
                p = !this.locked && this.options.size !== 0 && ((this.options.wrap && this.options.wrap != 'last') || this.first > 1);
                if (!this.locked && (!this.options.wrap || this.options.wrap == 'last') && this.options.size !== null && this.first == 1) {
                    p = this.tail !== null && this.inTail;
                }
            }

            var self = this;

            if (this.buttonNext.size() > 0) {
                this.buttonNext.unbind(this.options.buttonNextEvent + '.jcarousel', this.funcNext);

                if (n) {
                    this.buttonNext.bind(this.options.buttonNextEvent + '.jcarousel', this.funcNext);
                }

                this.buttonNext[n ? 'removeClass' : 'addClass'](this.className('jcarousel-next-disabled')).attr('disabled', n ? false : true);

                if (this.options.buttonNextCallback !== null && this.buttonNext.data('jcarouselstate') != n) {
                    this.buttonNext.each(function() { self.options.buttonNextCallback(self, this, n); }).data('jcarouselstate', n);
                }
            } else {
                if (this.options.buttonNextCallback !== null && this.buttonNextState != n) {
                    this.options.buttonNextCallback(self, null, n);
                }
            }

            if (this.buttonPrev.size() > 0) {
                this.buttonPrev.unbind(this.options.buttonPrevEvent + '.jcarousel', this.funcPrev);

                if (p) {
                    this.buttonPrev.bind(this.options.buttonPrevEvent + '.jcarousel', this.funcPrev);
                }

                this.buttonPrev[p ? 'removeClass' : 'addClass'](this.className('jcarousel-prev-disabled')).attr('disabled', p ? false : true);

                if (this.options.buttonPrevCallback !== null && this.buttonPrev.data('jcarouselstate') != p) {
                    this.buttonPrev.each(function() { self.options.buttonPrevCallback(self, this, p); }).data('jcarouselstate', p);
                }
            } else {
                if (this.options.buttonPrevCallback !== null && this.buttonPrevState != p) {
                    this.options.buttonPrevCallback(self, null, p);
                }
            }

            this.buttonNextState = n;
            this.buttonPrevState = p;
        },

        /**
         * Notify callback of a specified event.
         *
         * @method notify
         * @return undefined
         * @param evt {String} The event name
         */
        notify: function(evt) {
            var state = this.prevFirst === null ? 'init' : (this.prevFirst < this.first ? 'next' : 'prev');

            // Load items
            this.callback('itemLoadCallback', evt, state);

            if (this.prevFirst !== this.first) {
                this.callback('itemFirstInCallback', evt, state, this.first);
                this.callback('itemFirstOutCallback', evt, state, this.prevFirst);
            }

            if (this.prevLast !== this.last) {
                this.callback('itemLastInCallback', evt, state, this.last);
                this.callback('itemLastOutCallback', evt, state, this.prevLast);
            }

            this.callback('itemVisibleInCallback', evt, state, this.first, this.last, this.prevFirst, this.prevLast);
            this.callback('itemVisibleOutCallback', evt, state, this.prevFirst, this.prevLast, this.first, this.last);
        },

        callback: function(cb, evt, state, i1, i2, i3, i4) {
            if (this.options[cb] == null || (typeof this.options[cb] != 'object' && evt != 'onAfterAnimation')) {
                return;
            }

            var callback = typeof this.options[cb] == 'object' ? this.options[cb][evt] : this.options[cb];

            if (!$.isFunction(callback)) {
                return;
            }

            var self = this;

            if (i1 === undefined) {
                callback(self, state, evt);
            } else if (i2 === undefined) {
                this.get(i1).each(function() { callback(self, this, i1, state, evt); });
            } else {
                var call = function(i) {
                    self.get(i).each(function() { callback(self, this, i, state, evt); });
                };
                for (var i = i1; i <= i2; i++) {
                    if (i !== null && !(i >= i3 && i <= i4)) {
                        call(i);
                    }
                }
            }
        },

        create: function(i) {
            return this.format('<li></li>', i);
        },

        format: function(e, i) {
            e = $(e);
            var split = e.get(0).className.split(' ');
            for (var j = 0; j < split.length; j++) {
                if (split[j].indexOf('jcarousel-') != -1) {
                    e.removeClass(split[j]);
                }
            }
            e.addClass(this.className('jcarousel-item')).addClass(this.className('jcarousel-item-' + i)).css({
                'float': (this.options.rtl ? 'right' : 'left'),
                'list-style': 'none'
            }).attr('jcarouselindex', i);
            return e;
        },

        className: function(c) {
            return c + ' ' + c + (!this.options.vertical ? '-horizontal' : '-vertical');
        },

        dimension: function(e, d) {
            var el = $(e);

            if (d == null) {
                return !this.options.vertical ?
                       (el.outerWidth(true) || $jc.intval(this.options.itemFallbackDimension)) :
                       (el.outerHeight(true) || $jc.intval(this.options.itemFallbackDimension));
            } else {
                var w = !this.options.vertical ?
                    d - $jc.intval(el.css('marginLeft')) - $jc.intval(el.css('marginRight')) :
                    d - $jc.intval(el.css('marginTop')) - $jc.intval(el.css('marginBottom'));

                $(el).css(this.wh, w + 'px');

                return this.dimension(el);
            }
        },

        clipping: function() {
            return !this.options.vertical ?
                this.clip[0].offsetWidth - $jc.intval(this.clip.css('borderLeftWidth')) - $jc.intval(this.clip.css('borderRightWidth')) :
                this.clip[0].offsetHeight - $jc.intval(this.clip.css('borderTopWidth')) - $jc.intval(this.clip.css('borderBottomWidth'));
        },

        index: function(i, s) {
            if (s == null) {
                s = this.options.size;
            }

            return Math.round((((i-1) / s) - Math.floor((i-1) / s)) * s) + 1;
        }
    });

    $jc.extend({
        /**
         * Gets/Sets the global default configuration properties.
         *
         * @method defaults
         * @return {Object}
         * @param d {Object} A set of key/value pairs to set as configuration properties.
         */
        defaults: function(d) {
            return $.extend(defaults, d || {});
        },

        intval: function(v) {
            v = parseInt(v, 10);
            return isNaN(v) ? 0 : v;
        },

        windowLoaded: function() {
            windowLoaded = true;
        }
    });

    /**
     * Creates a carousel for all matched elements.
     *
     * @example $("#mycarousel").jcarousel();
     * @before <ul id="mycarousel" class="jcarousel-skin-name"><li>First item</li><li>Second item</li></ul>
     * @result
     *
     * <div class="jcarousel-skin-name">
     *   <div class="jcarousel-container">
     *     <div class="jcarousel-clip">
     *       <ul class="jcarousel-list">
     *         <li class="jcarousel-item-1">First item</li>
     *         <li class="jcarousel-item-2">Second item</li>
     *       </ul>
     *     </div>
     *     <div disabled="disabled" class="jcarousel-prev jcarousel-prev-disabled"></div>
     *     <div class="jcarousel-next"></div>
     *   </div>
     * </div>
     *
     * @method jcarousel
     * @return jQuery
     * @param o {Hash|String} A set of key/value pairs to set as configuration properties or a method name to call on a formerly created instance.
     */
    $.fn.jcarousel = function(o) {
        if (typeof o == 'string') {
            var instance = $(this).data('jcarousel'), args = Array.prototype.slice.call(arguments, 1);
            return instance[o].apply(instance, args);
        } else {
            return this.each(function() {
                var instance = $(this).data('jcarousel');
                if (instance) {
                    if (o) {
                        $.extend(instance.options, o);
                    }
                    instance.reload();
                } else {
                    $(this).data('jcarousel', new $jc(this, o));
                }
            });
        }
    };

})(jQuery);


(function(a){a.widget("ui.dropdownchecklist",{version:function(){alert("DropDownCheckList v1.4")},_appendDropContainer:function(b){var d=a("<div/>");d.addClass("ui-dropdownchecklist ui-dropdownchecklist-dropcontainer-wrapper");d.addClass("ui-widget");d.attr("id",b.attr("id")+"-ddw");d.css({position:"absolute",left:"-33000px",top:"-33000px"});var c=a("<div/>");c.addClass("ui-dropdownchecklist-dropcontainer ui-widget-content");c.css("overflow-y","auto");d.append(c);d.insertAfter(b);d.isOpen=false;return d},_isDropDownKeyShortcut:function(c,b){return c.altKey&&(a.ui.keyCode.DOWN==b)},_isDropDownCloseKey:function(c,b){return(a.ui.keyCode.ESCAPE==b)||(a.ui.keyCode.ENTER==b)},_keyFocusChange:function(f,i,c){var g=a(":focusable");var d=g.index(f);if(d>=0){d+=i;if(c){var e=this.dropWrapper.find("input:not([disabled])");var b=g.index(e.get(0));var h=g.index(e.get(e.length-1));if(d<b){d=h}else{if(d>h){d=b}}}g.get(d).focus()}},_handleKeyboard:function(d){var b=this;var c=(d.keyCode||d.which);if(!b.dropWrapper.isOpen&&b._isDropDownKeyShortcut(d,c)){d.stopImmediatePropagation();b._toggleDropContainer(true)}else{if(b.dropWrapper.isOpen&&b._isDropDownCloseKey(d,c)){d.stopImmediatePropagation();b._toggleDropContainer(false);b.controlSelector.focus()}else{if(b.dropWrapper.isOpen&&(d.target.type=="checkbox")&&((c==a.ui.keyCode.DOWN)||(c==a.ui.keyCode.UP))){d.stopImmediatePropagation();b._keyFocusChange(d.target,(c==a.ui.keyCode.DOWN)?1:-1,true)}else{if(b.dropWrapper.isOpen&&(c==a.ui.keyCode.TAB)){}}}}},_handleFocus:function(f,d,b){var c=this;if(b&&!c.dropWrapper.isOpen){f.stopImmediatePropagation();if(d){c.controlSelector.addClass("ui-state-hover");if(a.ui.dropdownchecklist.gLastOpened!=null){a.ui.dropdownchecklist.gLastOpened._toggleDropContainer(false)}}else{c.controlSelector.removeClass("ui-state-hover")}}else{if(!b&&!d){if(f!=null){f.stopImmediatePropagation()}c.controlSelector.removeClass("ui-state-hover");c._toggleDropContainer(false)}}},_cancelBlur:function(c){var b=this;if(b.blurringItem!=null){clearTimeout(b.blurringItem);b.blurringItem=null}},_appendControl:function(){var j=this,c=this.sourceSelect,k=this.options;var b=a("<span/>");b.addClass("ui-dropdownchecklist ui-dropdownchecklist-selector-wrapper ui-widget");b.css({display:"inline-block",cursor:"default",overflow:"hidden"});var f=c.attr("id");if((f==null)||(f=="")){f="ddcl-"+a.ui.dropdownchecklist.gIDCounter++}else{f="ddcl-"+f}b.attr("id",f);var h=a("<span/>");h.addClass("ui-dropdownchecklist-selector ui-state-default");h.css({display:"inline-block",overflow:"hidden","white-space":"nowrap"});var d=c.attr("tabIndex");if(d==null){d=0}else{d=parseInt(d);if(d<0){d=0}}h.attr("tabIndex",d);h.keyup(function(l){j._handleKeyboard(l)});h.focus(function(l){j._handleFocus(l,true,true)});h.blur(function(l){j._handleFocus(l,false,true)});b.append(h);if(k.icon!=null){var i=(k.icon.placement==null)?"left":k.icon.placement;var g=a("<div/>");g.addClass("ui-icon");g.addClass((k.icon.toOpen!=null)?k.icon.toOpen:"ui-icon-triangle-1-e");g.css({"float":i});h.append(g)}var e=a("<span/>");e.addClass("ui-dropdownchecklist-text");e.css({display:"inline-block","white-space":"nowrap",overflow:"hidden"});h.append(e);b.hover(function(){if(!j.disabled){h.addClass("ui-state-hover")}},function(){if(!j.disabled){h.removeClass("ui-state-hover")}});b.click(function(l){if(!j.disabled){l.stopImmediatePropagation();j._toggleDropContainer(!j.dropWrapper.isOpen)}});b.insertAfter(c);a(window).resize(function(){if(!j.disabled&&j.dropWrapper.isOpen){j._toggleDropContainer(true)}});return b},_createDropItem:function(g,f,o,l,q,h,e,k){var m=this,c=this.options,d=this.sourceSelect,p=this.controlWrapper;var t=a("<div/>");t.addClass("ui-dropdownchecklist-item");t.css({"white-space":"nowrap"});var r=h?' checked="checked"':"";var j=e?' class="inactive"':' class="active"';var b=p.attr("id");var n=b+"-i"+g;var s;if(m.isMultiple){s=a('<input disabled type="checkbox" id="'+n+'"'+r+j+' tabindex="'+f+'" />')}else{s=a('<input disabled type="radio" id="'+n+'" name="'+b+'"'+r+j+' tabindex="'+f+'" />')}s=s.attr("index",g).val(o);t.append(s);var i=a("<label for="+n+"/>");i.addClass("ui-dropdownchecklist-text");if(q!=null){i.attr("style",q)}i.css({cursor:"default"});i.html(l);if(k){t.addClass("ui-dropdownchecklist-indent")}t.addClass("ui-state-default");if(e){t.addClass("ui-state-disabled")}i.click(function(u){u.stopImmediatePropagation()});t.append(i);t.hover(function(v){var u=a(this);if(!u.hasClass("ui-state-disabled")){u.addClass("ui-state-hover")}},function(v){var u=a(this);u.removeClass("ui-state-hover")});s.click(function(w){var v=a(this);w.stopImmediatePropagation();if(v.hasClass("active")){var x=m.options.onItemClick;if(a.isFunction(x)){try{x.call(m,v,d.get(0))}catch(u){v.prop("checked",!v.prop("checked"));m._syncSelected(v);return}}m._syncSelected(v);m.sourceSelect.trigger("change","ddcl_internal");if(!m.isMultiple&&c.closeRadioOnClick){m._toggleDropContainer(false)}}});t.click(function(y){var x=a(this);y.stopImmediatePropagation();if(!x.hasClass("ui-state-disabled")){var v=x.find("input");var w=v.prop("checked");v.prop("checked",!w);var z=m.options.onItemClick;if(a.isFunction(z)){try{z.call(m,v,d.get(0))}catch(u){v.prop("checked",w);m._syncSelected(v);return}}m._syncSelected(v);m.sourceSelect.trigger("change","ddcl_internal");if(!w&&!m.isMultiple&&c.closeRadioOnClick){m._toggleDropContainer(false)}}else{x.focus();m._cancelBlur()}});t.focus(function(v){var u=a(this);v.stopImmediatePropagation()});t.keyup(function(u){m._handleKeyboard(u)});return t},_createGroupItem:function(f,d){var b=this;var e=a("<div />");e.addClass("ui-dropdownchecklist-group ui-widget-header");if(d){e.addClass("ui-state-disabled")}e.css({"white-space":"nowrap"});var c=a("<span/>");c.addClass("ui-dropdownchecklist-text");c.css({cursor:"default"});c.text(f);e.append(c);e.click(function(h){var g=a(this);h.stopImmediatePropagation();g.focus();b._cancelBlur()});e.focus(function(h){var g=a(this);h.stopImmediatePropagation()});return e},_createCloseItem:function(e){var b=this;var d=a("<div />");d.addClass("ui-state-default ui-dropdownchecklist-close ui-dropdownchecklist-item");d.css({"white-space":"nowrap","text-align":"right"});var c=a("<span/>");c.addClass("ui-dropdownchecklist-text");c.css({cursor:"default"});c.html(e);d.append(c);d.click(function(g){var f=a(this);g.stopImmediatePropagation();f.focus();b._toggleDropContainer(false)});d.hover(function(f){a(this).addClass("ui-state-hover")},function(f){a(this).removeClass("ui-state-hover")});d.focus(function(g){var f=a(this);g.stopImmediatePropagation()});return d},_appendItems:function(){var d=this,f=this.options,h=this.sourceSelect,g=this.dropWrapper;var b=g.find(".ui-dropdownchecklist-dropcontainer");h.children().each(function(j){var k=a(this);if(k.is("option")){d._appendOption(k,b,j,false,false)}else{if(k.is("optgroup")){var l=k.prop("disabled");var n=k.attr("label");if(n!=""){var m=d._createGroupItem(n,l);b.append(m)}d._appendOptions(k,b,j,true,l)}}});if(f.explicitClose!=null){var i=d._createCloseItem(f.explicitClose);b.append(i)}var c=b.outerWidth();var e=b.outerHeight();return{width:c,height:e}},_appendOptions:function(g,d,f,c,b){var e=this;g.children("option").each(function(h){var i=a(this);var j=(f+"."+h);e._appendOption(i,d,j,c,b)})},_appendOption:function(g,b,h,d,n){var m=this;var k=g.html();if((k!=null)&&(k!="")){var j=g.val();var i=g.attr("style");var f=g.prop("selected");var e=(n||g.prop("disabled"));var c=m.controlSelector.attr("tabindex");var l=m._createDropItem(h,c,j,k,i,f,e,d);b.append(l)}},_syncSelected:function(h){var i=this,l=this.options,b=this.sourceSelect,d=this.dropWrapper;var c=b.get(0).options;var g=d.find("input.active");if(l.firstItemChecksAll=="exclusive"){if((h==null)&&a(c[0]).prop("selected")){g.prop("checked",false);a(g[0]).prop("checked",true)}else{if((h!=null)&&(h.attr("index")==0)){var e=h.prop("checked");g.prop("checked",false);a(g[0]).prop("checked",e)}else{var f=true;var k=null;g.each(function(m){if(m>0){var n=a(this).prop("checked");if(!n){f=false}}else{k=a(this)}});if(k!=null){if(f){g.prop("checked",false)}k.prop("checked",f)}}}}else{if(l.firstItemChecksAll){if((h==null)&&a(c[0]).prop("selected")){g.prop("checked",true)}else{if((h!=null)&&(h.attr("index")==0)){g.prop("checked",h.prop("checked"))}else{var f=true;var k=null;g.each(function(m){if(m>0){var n=a(this).prop("checked");if(!n){f=false}}else{k=a(this)}});if(k!=null){k.prop("checked",f)}}}}}var j=0;g=d.find("input");g.each(function(n){var m=a(c[n+j]);var o=m.html();if((o==null)||(o=="")){j+=1;m=a(c[n+j])}m.prop("selected",a(this).prop("checked"))});i._updateControlText();if(h!=null){h.focus()}},_sourceSelectChangeHandler:function(c){var b=this,d=this.dropWrapper;d.find("input").val(b.sourceSelect.val());b._updateControlText()},_updateControlText:function(){var c=this,g=this.sourceSelect,d=this.options,f=this.controlWrapper;var h=g.find("option:first");var b=g.find("option");var i=c._formatText(b,d.firstItemChecksAll,h);var e=f.find(".ui-dropdownchecklist-text");e.html(i);e.attr("title",e.text())},_formatText:function(b,d,e){var f;if(a.isFunction(this.options.textFormatFunction)){try{f=this.options.textFormatFunction(b)}catch(c){alert("textFormatFunction failed: "+c)}}else{if(d&&(e!=null)&&e.prop("selected")){f=e.html()}else{f="";b.each(function(){if(a(this).prop("selected")){if(f!=""){f+=", "}var g=a(this).attr("style");var h=a("<span/>");h.html(a(this).html());if(g==null){f+=h.html()}else{h.attr("style",g);f+=a("<span/>").append(h).html()}}});if(f==""){f=(this.options.emptyText!=null)?this.options.emptyText:"&nbsp;"}}}return f},_toggleDropContainer:function(e){var c=this;var d=function(f){if((f!=null)&&f.dropWrapper.isOpen){f.dropWrapper.isOpen=false;a.ui.dropdownchecklist.gLastOpened=null;var h=f.options;f.dropWrapper.css({top:"-33000px",left:"-33000px"});var g=f.controlSelector;g.removeClass("ui-state-active");g.removeClass("ui-state-hover");var j=f.controlWrapper.find(".ui-icon");if(j.length>0){j.removeClass((h.icon.toClose!=null)?h.icon.toClose:"ui-icon-triangle-1-s");j.addClass((h.icon.toOpen!=null)?h.icon.toOpen:"ui-icon-triangle-1-e")}a(document).unbind("click",d);f.dropWrapper.find("input.active").prop("disabled",true);if(a.isFunction(h.onComplete)){try{h.onComplete.call(f,f.sourceSelect.get(0))}catch(i){alert("callback failed: "+i)}}}};var b=function(n){if(!n.dropWrapper.isOpen){n.dropWrapper.isOpen=true;a.ui.dropdownchecklist.gLastOpened=n;var g=n.options;if((g.positionHow==null)||(g.positionHow=="absolute")){n.dropWrapper.css({position:"absolute",top:n.controlWrapper.position().top+n.controlWrapper.outerHeight()+"px",left:n.controlWrapper.position().left+"px"})}else{if(g.positionHow=="relative"){n.dropWrapper.css({position:"relative",top:"0px",left:"0px"})}}var m=0;if(g.zIndex==null){var l=n.controlWrapper.parents().map(function(){var o=a(this).css("z-index");return isNaN(o)?0:o}).get();var i=Math.max.apply(Math,l);if(i>=0){m=i+1}}else{m=parseInt(g.zIndex)}if(m>0){n.dropWrapper.css({"z-index":m})}var j=n.controlSelector;j.addClass("ui-state-active");j.removeClass("ui-state-hover");var h=n.controlWrapper.find(".ui-icon");if(h.length>0){h.removeClass((g.icon.toOpen!=null)?g.icon.toOpen:"ui-icon-triangle-1-e");h.addClass((g.icon.toClose!=null)?g.icon.toClose:"ui-icon-triangle-1-s")}a(document).bind("click",function(o){d(n)});var f=n.dropWrapper.find("input.active");f.prop("disabled",false);var k=f.get(0);if(k!=null){k.focus()}}};if(e){d(a.ui.dropdownchecklist.gLastOpened);b(c)}else{d(c)}},_setSize:function(b){var m=this.options,f=this.dropWrapper,l=this.controlWrapper;var k=b.width;if(m.width!=null){k=parseInt(m.width)}else{if(m.minWidth!=null){var c=parseInt(m.minWidth);if(k<c){k=c}}}var i=this.controlSelector;i.css({width:k+"px"});var g=i.find(".ui-dropdownchecklist-text");var d=i.find(".ui-icon");if(d!=null){k-=(d.outerWidth()+4);g.css({width:k+"px"})}k=l.outerWidth();var j=(m.maxDropHeight!=null)?parseInt(m.maxDropHeight):-1;var h=((j>0)&&(b.height>j))?j:b.height;var e=b.width<k?k:b.width;a(f).css({height:h+"px",width:e+"px"});f.find(".ui-dropdownchecklist-dropcontainer").css({height:h+"px"})},_init:function(){var c=this,d=this.options;if(a.ui.dropdownchecklist.gIDCounter==null){a.ui.dropdownchecklist.gIDCounter=1}c.blurringItem=null;var g=c.element;c.initialDisplay=g.css("display");g.css("display","none");c.initialMultiple=g.prop("multiple");c.isMultiple=c.initialMultiple;if(d.forceMultiple!=null){c.isMultiple=d.forceMultiple}g.prop("multiple",true);c.sourceSelect=g;var e=c._appendControl();c.controlWrapper=e;c.controlSelector=e.find(".ui-dropdownchecklist-selector");var f=c._appendDropContainer(e);c.dropWrapper=f;var b=c._appendItems();c._updateControlText(e,f,g);c._setSize(b);if(d.firstItemChecksAll){c._syncSelected(null)}if(d.bgiframe&&typeof c.dropWrapper.bgiframe=="function"){c.dropWrapper.bgiframe()}c.sourceSelect.change(function(i,h){if(h!="ddcl_internal"){c._sourceSelectChangeHandler(i)}})},_refreshOption:function(e,d,c){var b=e.parent();if(d){e.prop("disabled",true);e.removeClass("active");e.addClass("inactive");b.addClass("ui-state-disabled")}else{e.prop("disabled",false);e.removeClass("inactive");e.addClass("active");b.removeClass("ui-state-disabled")}e.prop("checked",c)},_refreshGroup:function(c,b){if(b){c.addClass("ui-state-disabled")}else{c.removeClass("ui-state-disabled")}},close:function(){this._toggleDropContainer(false)},refresh:function(){var b=this,e=this.sourceSelect,d=this.dropWrapper;var c=d.find("input");var g=d.find(".ui-dropdownchecklist-group");var h=0;var f=0;e.children().each(function(i){var j=a(this);var l=j.prop("disabled");if(j.is("option")){var k=j.prop("selected");var n=a(c[f]);b._refreshOption(n,l,k);f+=1}else{if(j.is("optgroup")){var o=j.attr("label");if(o!=""){var m=a(g[h]);b._refreshGroup(m,l);h+=1}j.children("option").each(function(){var p=a(this);var r=(l||p.prop("disabled"));var q=p.prop("selected");var s=a(c[f]);b._refreshOption(s,r,q);f+=1})}}});b._syncSelected(null)},enable:function(){this.controlSelector.removeClass("ui-state-disabled");this.disabled=false},disable:function(){this.controlSelector.addClass("ui-state-disabled");this.disabled=true},destroy:function(){a.Widget.prototype.destroy.apply(this,arguments);this.sourceSelect.css("display",this.initialDisplay);this.sourceSelect.prop("multiple",this.initialMultiple);this.controlWrapper.unbind().remove();this.dropWrapper.remove()}});a.extend(a.ui.dropdownchecklist,{defaults:{width:null,maxDropHeight:null,firstItemChecksAll:false,closeRadioOnClick:false,minWidth:50,positionHow:"absolute",bgiframe:false,explicitClose:null}})})(jQuery);