Paloma.controller 'Productos', tienda: ->
  # $("#cat-nav").hide()
  # $(".div-cat").hide()
  $(".item-cantidades, .span-unidad").hide()
  #Cargarlos si estan ya en localStorage
  cargar_productos()
  eventos()
  eventos_negocio()
  eventos_buscador()

Paloma.controller 'Productos', new: ->
  $('#producto_foto').change ->
    console.log "Select foto new"
    readURL this
    return

Paloma.controller 'Productos', edit: ->
  $('#producto_foto').change ->
    console.log "Select foto edit"
    readURL this
    return

readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      $('#img_producto').attr 'src', e.target.result
      return

    reader.readAsDataURL input.files[0]
    # convert to base64 string
  return

Paloma.controller 'Productos', index: ->
  $("#btn_importar").prop("disabled",true)
  $('#file').change ->
    if $(this).val()
      $("#btn_importar").prop("disabled",false)
    else 
      $("#btn_importar").prop("disabled",true)

Paloma.controller 'Pedidos', show: ->
  $("#nav-link-pedidos").addClass("active")
  $(".carbar").removeClass("d-block").hide()
  $("#texto_wa").keyup (e)->
    actualizar_link_wa()
  $("#pedido_estatus").change ->
    pedido_id = $(this).data("pedido-id")
    estatus = $(this).val()
    cambiar_estatus_pedido(pedido_id, estatus, true)

Paloma.controller 'Pedidos', ver_pedido: ->
  $(".carbar").removeClass("d-block").hide()
  $("#btn-cart_float").removeClass("d-md-block")
  $("#form-botones").hide()

Paloma.controller 'Pedidos', index: ->
  $(".carbar").removeClass("d-block").hide()
  $(".pedido_estatus").change ->
    pedido_id = $(this).data("pedido-id")
    estatus = $(this).val()
    cambiar_estatus_pedido(pedido_id, estatus)

Paloma.controller 'Pedidos', new: ->

  $("#btn-cart_float").removeClass("d-md-block")

  negocio_factura = localStorage.getItem("negocio_factura")
  negocio_anuncio = localStorage.getItem("negocio_anuncio")

  if negocio_anuncio != ""
    $("#alert_aviso").html(negocio_anuncio).show()

  if negocio_factura != "Si"
    $("#row_factura").hide()

  $('.positive-integer').numeric
    decimal: false
    negative: false

  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  if productos.length == 0
    window.location.href = "/"
  else
    cargar_productos()
    $(".carbar").css('visibility', 'hidden')
    $("#cliente_nombre").focus()
    $("#form-botones").hide()
    $("#cliente_rfc, #cliente_uso").prop("disabled",true).val("")
    $("#cliente_factura").change ->
      mostrar = $(this).val()
      if mostrar == "1"
        $("#cliente_rfc, #cliente_uso").prop("disabled",false).val("")
      else
        $("#cliente_rfc, #cliente_uso").prop("disabled",true).val("")

    $('#datos_cliente_form').on 'submit', (e) ->
      e.preventDefault()
      $("#submit_pedido").attr("disabled", true).html("Procesando Pedido...")
      procesar_pedido()


Paloma.controller 'Home', index: ->
  cargar_productos()
  eventos()

Paloma.controller 'Home', cuenta: ->

  $("#btn-cart_float").removeClass("d-md-block")

cargar_productos = ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  totales = calcular_totales()
  localStorage.setItem("total_pedido", totales.total_pedido)

  handlebars_productos()
  handlebars_productos_detalle()
  #Mostrar items en badges y total $
  $(".total-items").text(productos.length)
  $(".total-pedido").text(number_to_currency(totales.total_pedido))
  if productos.length == 0
    $(".carbar").css('visibility', 'hidden')
    $("#btn-procesar").prop("disabled",true)
  else
    $(".carbar").css('visibility', 'visible')
    $("#btn-procesar").prop("disabled",false)

calcular_totales = ->
  total = 0
  total_items = 0
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  productos.forEach (prod) ->
    prod.subtotal = prod.cantidad * prod.precio
    total_items = total_items + prod.cantidad
    total = total + prod.subtotal
    return
  datos =
    total_item: total_items
    total_pedido: total
  datos

eventos_buscador = ->

  $("#btn_busqueda").unbind("click").click ->
    $(this).toggleClass("activo")
    if $(this).hasClass("activo")
      $("#buscador").fadeIn().css("visibility","visible").focus()
      $(this).html("<i class='fas fa-times'></i>")
    else
      $("#buscador").css("visibility","hidden").val("")
      $(".lista-item, .div-cat").show()
      $(this).html("<i class='fas fa-search'></i>")
  
  $("#btn_busqueda_movil").unbind("click").click ->
    $(this).toggleClass("activo")
    if $(this).hasClass("activo")
      $("#buscador_movil").fadeIn().css("visibility","visible").focus()
      $(this).html("<i class='fas fa-times'></i>")
      $("#info_proveedor").fadeOut()
    else
      $("#buscador_movil").css("visibility","hidden").val("")
      $(".lista-item, .div-cat").show()
      $(this).html("<i class='fas fa-search'></i>")
      $("#info_proveedor").fadeIn()
  
  $("#buscador, #buscador_movil").unbind().keyup (e) ->
    nombres = $('.prod-descr')
    buscando = $(this).val().toLowerCase()
    item = ''
    i = 0
    while i < nombres.length
      item = $(nombres[i]).html().toLowerCase()
      x = 0
      while x < item.length
        if buscando.length == 0 or item.indexOf(buscando) > -1
          $(nombres[i]).parents('.lista-item').show()
          $(nombres[i]).parents('.div-cat').show()
        else
          $(nombres[i]).parents('.lista-item').hide()
        x++
      i++
    revisar_cats()
    return

revisar_cats = ->
  cats = $(".div-cat")
  cats.each ->
    if $(this).children('div:visible').length == 0
      $(this).hide()
    else
      $(this).show()

eventos_negocio = ->

  $(".pop").unbind("click").click (e) ->
    e.preventDefault()
    imagen = $(this).children().attr('src')
    $('#imagepreview').attr('src', imagen)
    $('#imagemodal').modal('show')

  $("#ver_prod_movil, #ver_prod_web").click ->
    console.log "x"
    # if $(this).hasClass("active")
    #   #No ocultar solo mover
    #   $('body').scrollTo $("#cat-nav")
    #   $("#info_proveedor").fadeIn()
    #   $("#ver_prod_movil, #ver_prod_web").removeClass("active")
    #   $("#ver_prod_web").html("Ver todos los productos <i class='fas fa-chevron-down'></i>")
    #   $("#ver_prod_movil").html("Ver productos <i class='fas fa-chevron-down'></i>")
    # else
    #   $('body').scrollTo($("#cat-nav"),{margin: true})
    #   $("#ver_prod_movil, #ver_prod_web").addClass("active")
    #   $("#ver_prod_movil").html("Ver proveedor <i class='fas fa-chevron-up'></i>")
    #   $("#ver_prod_web").html("Ver información del proveedor <i class='fas fa-chevron-up'></i>")

eventos_handlebars = ->
  $('.eliminar-item').unbind("click").click ->
    id = $(this).data("id")
    borrar_producto(id)
  
  $('.sumar-item').unbind("click").click ->
    id = $(this).data("id")
    sumar_restar_producto(id, true)
  
  $('.restar-item').unbind("click").click ->
    id = $(this).data("id")
    sumar_restar_producto(id, false)
  
  $('.input-cantidad, .input-cantidad-list').unbind().keyup (e) ->
    if e.keyCode == 13
      id = $(this).data("id")
      valor = $(this).val()
      if valor == ""
        cantidad_producto(id, 1)
      else
        cantidad_producto(id, valor)
      $(this).blur()
    return
  
  $('.input-cantidad, .input-cantidad-list').unbind("focusout").focusout ->
    id = $(this).data("id")
    valor = $(this).val()
    if valor == ""
      cantidad_producto(id, 1)
    else
      cantidad_producto(id, valor)

cantidad_producto = (id, valor) ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  cantidad = null
  productos.forEach (prod) ->
    if prod.id == id
      prod.cantidad = parseFloat(valor).round(2)
      prod.subtotal = parseFloat(prod.cantidad * prod.precio)
      total_pedido = parseFloat(total_pedido + prod.precio)
      prod.subtotal_string = number_to_currency(prod.subtotal)
      cantidad = parseFloat(prod.cantidad)
    return
  localStorage.setItem("productos", JSON.stringify(productos))
  animate($(".total-items"), "wobble")
  if cantidad <= 0
    borrar_producto(id)
  else
    cargar_productos()

Number::round = (p) ->
  p = p or 10
  parseFloat @toFixed(p)

sumar_restar_producto = (id, sumar) ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  cantidad = null
  productos.forEach (prod) ->
    if prod.id == id
      if sumar == true
        prod.cantidad = parseFloat(prod.cantidad + 1).round(2)
      else
        prod.cantidad = parseFloat(prod.cantidad - 1).round(2)
      prod.subtotal = parseFloat(prod.cantidad * prod.precio)
      total_pedido = parseFloat(total_pedido + prod.precio)
      prod.subtotal_string = number_to_currency(prod.subtotal)
      cantidad = parseFloat(prod.cantidad).round(2)
      $("#input_cant_#{id}").val(prod.cantidad)
    return
  localStorage.setItem("productos", JSON.stringify(productos))
  animate($(".total-items"), "wobble")
  if cantidad <= 0
    borrar_producto(id)
  else
    cargar_productos()


eventos = ->
  #Productos y carrito
  $('.btn-cart-item').unbind("click").click ->
    $(this).hide()
    agregar_producto($(this))
  
  $('#btn_vaciar_agregar').unbind("click").click ->
    borrar_pedido()

  $('#btn-procesar').unbind("click").click ->
    window.location.href = "/pedido"
  
  $('#btn_vaciar_agregar').unbind("click").click ->
    localStorage.removeItem("total_pedido");
    localStorage.removeItem("productos");
    localStorage.removeItem("negocio_id");
    localStorage.removeItem("negocio_factura");
    localStorage.removeItem("negocio_anuncio");
    $("#negocio_nombre_carrito").val("")
    $("#notifModal").modal('hide')
    cargar_productos()
    
  #Scroolspy y Side cart
  $('[data-toggle="offcanvas"]').on 'click', ->
    $('body').toggleClass 'toggled'
    $('.carbar').toggleClass 'd-none'
    $('.carbar').toggleClass 'd-block'
    return
  
  #Scroll al hacer clic en item navbar
  $('#cat-nav ul li a[href^=\'#\']').on 'click', (e) ->
    e.preventDefault()
    $('html, body').animate scrollTop: $(@hash).offset().top-50
    $(".nav-link").removeClass("active")
    $(this).addClass("active")
    return
  $(window).on 'activate.bs.scrollspy', ->
    x = $('#cat-nav > ul > li > a.active')
    $('#cat-nav').scrollTo x
    return
  # Owl carousel
  $('.owl-carousel').owlCarousel
    margin: 20
    responsive:
      0:
        items: 1
        margin: 10
        stagePadding: 20
        dots: true
      600: items: 3
      1000:
        items: 4
        margin: 30
        dots: true
        stagePadding: 50
  
handlebars_productos = ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  source = $("#handlebars_carrito_item").html()
  template = Handlebars.compile(source)
  $('#carrito_items').html(template(productos: productos))
  #Cargar vista principal
  productos.forEach (item, index, object) ->
    $("#input_cant_#{item.id}").val(item.cantidad)
    if parseFloat(item.cantidad) > 0
      $("#input_cant_#{item.id}").parent().fadeIn()
      $("#span_unidad_#{item.id}").fadeIn()
      $("#btn_add_#{item.id}").hide()
  eventos_handlebars()

handlebars_productos_detalle = ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  source = $("#handlebars_carrito_item_detalle").html()
  template = Handlebars.compile(source)
  $('#carrito_items_detalle').html(template(productos: productos))
  #Cargar vista principal
  productos.forEach (item, index, object) ->
    $("#input_cant_#{item.id}").val(item.cantidad)
    if parseFloat(item.cantidad) > 0
      $("#input_cant_#{item.id}").parent().fadeIn()
      $("#span_unidad_#{item.id}").fadeIn()
      $("#btn_add_#{item.id}").hide()
  eventos_handlebars()

borrar_producto = (id) ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  $("#input_cant_#{id}").parent().hide()
  $("#span_unidad_#{id}").hide()
  $("#btn_add_#{id}").fadeIn()
  productos.forEach (item, index, object) ->
    if item.id == id
      object.splice index, 1
    return
  localStorage.setItem("productos", JSON.stringify(productos))
  cargar_productos()

agregar_producto = (producto) ->
  #Cantidad de productos
  id = producto.data("id")
  negocio = parseInt(producto.data("negocio-id"))
  negocio_actual = parseInt(localStorage.getItem("negocio_id") || 0)

  if negocio_actual !=0 && negocio != negocio_actual
    $("#notifModal").modal()
    return
  negocio_factura = $("#negocio_factura").val()
  localStorage.setItem("negocio_factura", negocio_factura)
  negocio_anuncio = $("#negocio_anuncio").val()
  localStorage.setItem("negocio_anuncio", negocio_anuncio)
  negocio_nombre = $("#negocio_nombre").val()
  $("#negocio_nombre_carrito").text(negocio_nombre)
  precio = parseFloat(producto.data("precio"))
  nombre = producto.data("nombre")
  unidad = producto.data("unidad")
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  total_pedido = parseFloat(localStorage.getItem("total_pedido") || 0 )

  if productos.length == 0 
    total_pedido = precio
    $("#input_cant_#{id}").val(1)
    
    if precio <= 0
      precio_format = ""
      subtotal_format = ""
    else
      precio_format = "#{number_to_currency(precio)}/"
      subtotal_format = number_to_currency(precio)

    productos.push({id: id, nombre: nombre, precio: precio, unidad: unidad, cantidad: 1 , subtotal: precio, precio_string: precio_format, subtotal_string: subtotal_format})
  else
    existe = false
    productos.forEach (prod) ->
      if prod.id == id
        existe = true
        prod.cantidad = prod.cantidad + 1
        $("#input_cant_#{id}").val(prod.cantidad)
        prod.subtotal = parseFloat(prod.cantidad * prod.precio)
        total_pedido = parseFloat(total_pedido + prod.precio)
        prod.subtotal_string = number_to_currency(prod.subtotal)
      return
    if existe == false
      $("#input_cant_#{id}").val(1)
      if precio <= 0
        precio_format = ""
        subtotal_format = ""
      else
        precio_format = "#{number_to_currency(precio)}/"
        subtotal_format = number_to_currency(precio)
      productos.push({id: id, nombre: nombre, precio: precio, unidad: unidad, cantidad: 1 , subtotal: precio, precio_string: precio_format, subtotal_string: subtotal_format})
      total_pedido = parseFloat(total_pedido + precio)
  localStorage.setItem("total_pedido", total_pedido)
  localStorage.setItem("negocio_id", negocio)
  localStorage.setItem("productos", JSON.stringify(productos))
  animate($(".total-items"), "wobble")
  cargar_productos()

#Enviar al controller el json del pedido
procesar_pedido = ->
  productos = localStorage.getItem("productos") || "[]"
  negocio_id = localStorage.getItem("negocio_id") || 0
  total= localStorage.getItem("total_pedido") || 0
  cliente = JSON.stringify( objectifyForm($("#datos_cliente_form").serializeArray()) )
  $.ajax
    type: 'POST'
    url: '/generar_pedido'
    data: { negocio_id: negocio_id, productos: productos, total: total, cliente: cliente } 
    dataType: 'json'
    beforeSend: ->
      console.log "Generando pedido"
    success: (data) ->
      $("#submit_pedido").attr("disabled", false).html("Confirmar Pedido")
      if data.error == false
        borrar_pedido()
        $("#notifPedidoModal").modal()
      else
        console.log "Ocurrió un error al generar el pedido"

#Borrar el pedido
borrar_pedido = ->
  localStorage.removeItem("total_pedido")
  localStorage.removeItem("productos")
  localStorage.removeItem("negocio_id")
  localStorage.removeItem("negocio_factura");
  localStorage.removeItem("negocio_anuncio");
  $("#negocio_nombre_carrito").val("")
  cargar_productos()

#Actualizar estatus pedido
cambiar_estatus_pedido = (id, estatus, refresh = false) ->
  $.ajax
    type: 'POST'
    url: '/pedido/actualizar_estatus'
    data: { pedido_id: id, estatus: estatus}
    beforeSend: ->
      console.log "Actualizando estatus del pedido..."
    success: (data) ->
      if refresh == true
        window.location.reload(true)
      if data.error == false
        console.log "Se actualizó el estatus a #{estatus}."
      else
        console.log "Ocurrió un error al actualizar el estatus del pedido."

#Utilidades
number_to_currency = (number, options) ->
  `var options`
  try
    options = options or {}
    precision = options['precision'] or 2
    unit = options['unit'] or '$'
    separator = if precision > 0 then options['separator'] or '.' else ''
    delimiter = options['delimiter'] or ','
    parts = parseFloat(number).toFixed(precision).split('.')
    return unit + number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString()
  catch e
    return number
  return

objectifyForm = (formArray) ->
  #serialize data function
  returnArray = {}
  i = 0
  while i < formArray.length
    returnArray[formArray[i]['name']] = formArray[i]['value']
    i++
  returnArray

number_with_delimiter = (number, delimiter, separator) ->
  `var delimiter`
  `var separator`
  try
    delimiter = delimiter or ','
    separator = separator or '.'
    parts = number.toString().split('.')
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1' + delimiter)
    return parts.join(separator)
  catch e
    return number
  return

animate = (item, efecto) ->
  anim = "#{efecto} animated"
  item.addClass(anim).one 'animationend webkitAnimationEnd oAnimationEnd MSAnimationEnd', ->
    item.removeClass(anim)
    return
  return

actualizar_link_wa = ->
  texto = $("#texto_wa").val()
  link_pedido = $("#link_pedido").val()
  link_wa_base = $("#link_wa_base").val()
  link = "#{link_wa_base}#{texto}. #{link_pedido}"
  $("#link_wa").attr("href", link)
