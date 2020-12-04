Paloma.controller 'Recomendados', index: ->

  #Ocultar buscador y navbar inferior
  $(".carbar, #btn_busqueda_movil").removeClass("d-block").hide()
  $("#btn-cart_float").removeClass("d-md-block")