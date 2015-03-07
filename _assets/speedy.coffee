$(document).on 'emoji:ready', ->
  search $('.speedy-filter').val()

search = (keyword) ->
  keyword ?= ''
  keyword = keyword.split(" ").pop()
  $('.keyword').text keyword
  keyword = keyword.trim()

  unless window.speedy_keyword == keyword
    window.speedy_keyword = keyword
    if keyword.length
      $('.result').hide()
      $('.result').each ->
        $(this).show() if $(this).text().toLowerCase().indexOf(keyword.toLowerCase()) > -1
    else
      $('.result').show()

  setRelatedDOMVisibility(keyword)

setRelatedDOMVisibility = (keyword) ->
  foundSomething = !!$('.result:visible').length
  $('.no-results').toggle( !foundSomething )

  if keyword.length >= 3
    if !foundSomething
      ga 'send', 'event', 'search', 'no results'
    else
      ga 'send', 'event', 'search', keyword

$(document).on 'search keyup', '.speedy-filter', ->
  search $('.speedy-filter').val()
  $('[href^="#"]').removeClass('active')
  $("[href='#{location.hash}']").addClass('active')

$(document).on 'click', '.group', ->
  ga 'send', 'event', 'search', 'quick group search'
  search $('.speedy-filter').val($(this).attr('href').substr(1)).val()

$(document).on 'click', '.speedy-remover', ->
  $('.speedy-filter').val('')
  $('.result').show()
  location.hash = ''
