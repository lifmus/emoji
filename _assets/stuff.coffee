$(document).on 'emoji:ready', ->
  $(".input-search").focus()
  $(".loading").remove()

  $('.emoji-wrapper').on 'click', (e)->
    if e.currentTarget.dataset.clipboardText.length > 0
      newvalue = $('.speedy-filter').val().substring(0, $('.speedy-filter').val().lastIndexOf(" ")) + " " + e.currentTarget.dataset.clipboardText + " "
      $('.speedy-filter').val(newvalue)
      $('.speedy-filter').focus()
      updatePreview()

  $(".input-search").on 'input', ->
    updatePreview()

updatePreview = ->
  @previewText = $('.speedy-filter').val()

  replaceEmojiTextWithHTML = (emojiTextMatches) =>
    @previewText
    $.each emojiTextMatches, (emojiIndex, emojiCode) =>
      emojiCode = emojiCode.replace(/:/g, "")
      emojiHtml = "<div class='emoji s_" + emojiCode + "' title='"+ emojiCode + "'></div>"
      @previewText = @previewText.replace(emojiCode, emojiHtml).replace(/:/g, "")
    @previewText

  emojiTextMatches = $('.speedy-filter').val().match(/:[a-z0-9 _+-]*:/g)
  console.log emojiTextMatches
  @previewText = replaceEmojiTextWithHTML(emojiTextMatches, previewText) if emojiTextMatches
  $('.text-preview').html(@previewText)


focusOnSearch = (e) ->
  if e.keyCode == 191 && !$(".input-search:focus").length
    $(".input-search").focus()
    t = $(".input-search").get(0)
    if t.value.length
      t.selectionStart = 0
      t.selectionEnd = t.value.length
    false

$.getJSON 'emojis.json', (emojis) ->
  container = $('.emojis-container')
  $.each emojis, (name, keywords) ->
    container.append "<li class='result emoji-wrapper' data-clipboard-text=':#{name}:'>
      <div class='emoji s_#{name.replace(/\+/,'')}' title='#{name}'>#{name}</div>
      <input type='text' class='autofocus plain emoji-code' value=':#{name}:' />
      <span class='keywords'>#{name} #{keywords}</span>
      </li>"
  $(document).trigger 'emoji:ready'

$(document).keydown (e) -> focusOnSearch(e)

$(document).on 'keydown', '.emoji-wrapper input', (e) ->
  $(".input-search").blur()
  focusOnSearch(e)

$(document).on 'click', '[data-clipboard-text]', ->
  ga 'send', 'event', 'copy', $(this).attr('data-clipboard-text')

$(document).on 'click', '.js-hide-text', ->
  $('.emojis-container').toggleClass('hide-text')
  showorhide = if $('.emojis-container').hasClass('hide-text') then 'hide' else 'show'
  $(".input-search").focus()
  ga 'send', 'event', 'toggle text', showorhide
  false

$(document).on 'click', '.js-clear-search, .mojigroup.active', ->
  $('.speedy-filter').val('')
  $(".input-search").focus()
  updatePreview()
  search ''
  false

$(document).on 'click', '.js-contribute', ->
  ga 'send', 'event', 'contribute', 'click'
