$(document).on 'emoji:ready', ->
  $(".input-search").focus()
  $(".loading").remove()

  $('.emoji-wrapper').on 'click', (e)->
    if e.currentTarget.dataset.clipboardText.length > 0
      newvalue = $('.speedy-filter').val().substring(0, $('.speedy-filter').val().lastIndexOf(" ")) + " " + e.currentTarget.dataset.clipboardText + " "
      $('.speedy-filter').val(newvalue)
      $('.speedy-filter').focus()

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
  ga 'send', 'event', 'toggle text', showorhide
  false

$(document).on 'click', '.js-clear-search, .mojigroup.active', ->
  location.hash = ""
  false

$(document).on 'click', '.js-contribute', ->
  ga 'send', 'event', 'contribute', 'click'
