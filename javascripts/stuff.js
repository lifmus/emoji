// Generated by CoffeeScript 1.8.0
var focusOnSearch, updatePreview;

$(document).on('emoji:ready', function() {
  $(".input-search").focus();
  $(".loading").remove();
  $('.emoji-wrapper').on('click', function(e) {
    var newvalue;
    if (e.currentTarget.dataset.clipboardText.length > 0) {
      newvalue = $('.speedy-filter').val().substring(0, $('.speedy-filter').val().lastIndexOf(" ")) + " " + e.currentTarget.dataset.clipboardText + " ";
      $('.speedy-filter').val(newvalue);
      $('.speedy-filter').focus();
      return updatePreview();
    }
  });
  return $(".input-search").on('input', function() {
    return updatePreview();
  });
});

updatePreview = function() {
  var emojiTextMatches, replaceEmojiTextWithHTML;
  this.previewText = $('.speedy-filter').val();
  replaceEmojiTextWithHTML = (function(_this) {
    return function(emojiTextMatches) {
      _this.previewText;
      $.each(emojiTextMatches, function(emojiIndex, emojiCode) {
        var emojiHtml;
        emojiCode = emojiCode.replace(/:/g, "");
        emojiHtml = "<div class='emoji s_" + emojiCode + "' title='" + emojiCode + "'></div>";
        return _this.previewText = _this.previewText.replace(emojiCode, emojiHtml).replace(/:/g, "");
      });
      return _this.previewText;
    };
  })(this);
  emojiTextMatches = $('.speedy-filter').val().match(/:[a-z0-9 _+-]*:/g);
  console.log(emojiTextMatches);
  if (emojiTextMatches) {
    this.previewText = replaceEmojiTextWithHTML(emojiTextMatches, previewText);
  }
  return $('.text-preview').html(this.previewText);
};

focusOnSearch = function(e) {
  var t;
  if (e.keyCode === 191 && !$(".input-search:focus").length) {
    $(".input-search").focus();
    t = $(".input-search").get(0);
    if (t.value.length) {
      t.selectionStart = 0;
      t.selectionEnd = t.value.length;
    }
    return false;
  }
};

$.getJSON('emojis.json', function(emojis) {
  var container;
  container = $('.emojis-container');
  $.each(emojis, function(name, keywords) {
    return container.append("<li class='result emoji-wrapper' data-clipboard-text=':" + name + ":'> <div class='emoji s_" + (name.replace(/\+/, '')) + "' title='" + name + "'>" + name + "</div> <input type='text' class='autofocus plain emoji-code' value=':" + name + ":' /> <span class='keywords'>" + name + " " + keywords + "</span> </li>");
  });
  return $(document).trigger('emoji:ready');
});

$(document).keydown(function(e) {
  return focusOnSearch(e);
});

$(document).on('keydown', '.emoji-wrapper input', function(e) {
  $(".input-search").blur();
  return focusOnSearch(e);
});

$(document).on('click', '[data-clipboard-text]', function() {
  return ga('send', 'event', 'copy', $(this).attr('data-clipboard-text'));
});

$(document).on('click', '.js-hide-text', function() {
  var showorhide;
  $('.emojis-container').toggleClass('hide-text');
  showorhide = $('.emojis-container').hasClass('hide-text') ? 'hide' : 'show';
  $(".input-search").focus();
  ga('send', 'event', 'toggle text', showorhide);
  return false;
});

$(document).on('click', '.js-clear-search, .mojigroup.active', function() {
  $('.speedy-filter').val('');
  $(".input-search").focus();
  return false;
});

$(document).on('click', '.js-contribute', function() {
  return ga('send', 'event', 'contribute', 'click');
});
