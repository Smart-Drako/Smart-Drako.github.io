Paloma.controller 'Productos', tienda: ->
  #Cargarlos si estan ya en localStorage
  cargar_productos()
  eventos()

Paloma.controller 'Home', index: ->
  cargar_productos()
  eventos()

cargar_productos = ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  total_pedido = localStorage.getItem("total_pedido") || "0"

  #Mostrar items en badges y total $
  $(".total-items").text(productos.length)
  $(".total-pedido").text(number_to_currency(total_pedido))
  handlebars_productos()
  if productos.length == 0
    $(".carbar").css('visibility', 'hidden');
  else
    $(".carbar").css('visibility', 'visible');


eventos = ->
  #Productos y carrito
  $('.btn-cart-item').unbind("click").click ->
    agregar_producto($(this))
  
  # $('.btn-cart-item').hover ->
  #   animate($(this), "bounceIn")
  
  
  $('#btn_vaciar_agregar').unbind("click").click ->
    localStorage.removeItem("total_pedido");
    localStorage.removeItem("productos");
    localStorage.removeItem("vendedor");
    $("#notifModal").modal('hide')
    cargar_productos()
  
  #Procesar Pedido al controlador
  $('#btn-procesar').unbind("click").click ->
    procesar_pedido()
  
  #Scroolspy y Side cart
  $('[data-toggle="offcanvas"]').on 'click', ->
    $('body').toggleClass 'toggled'
    $('.carbar').toggleClass 'd-none'
    $('.carbar').toggleClass 'd-block'
    return
  #Scroll sticky
  $(window).unbind('scroll').on 'scroll', ->
    sticky $('#cat-nav')
    return
  #Scroll al hacer clic en item navbar
  $('#cat-nav ul li a[href^=\'#\']').on 'click', (e) ->
    e.preventDefault()
    $('html, body').animate scrollTop: $(@hash).offset().top - 30
    return
  $(window).on 'activate.bs.scrollspy', ->
    x = $('#cat-nav > ul > li > a.active')
    $('#cat-nav').scrollTo x, 100
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
        items: 3
        margin: 30
        dots: true
        stagePadding: 50
  
handlebars_productos = ->
    productos = JSON.parse(localStorage.getItem("productos") || "[]")
    source = $("#handlebars_carrito_item").html()
    template = Handlebars.compile(source)
    $('#carrito_items').html(template(productos: productos))

agregar_producto = (producto) ->
  #Cantidad de productos
  id = producto.data("id")
  precio = parseInt(producto.data("precio"))
  nombre = producto.data("nombre")
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  total_pedido = parseFloat(localStorage.getItem("total_pedido") || 0 )

  if productos.length == 0 
    total_pedido = precio
    productos.push({id: id, nombre: nombre, precio: precio, cantidad: 1 , subtotal: precio, precio_string: number_to_currency(precio), subtotal_string: number_to_currency(precio)})
    animate($(".total-items"), "wobble")
  else
    existe = false
    productos.forEach (prod) ->
      if prod.id == id
        existe = true
        prod.cantidad = prod.cantidad + 1
        prod.subtotal = prod.cantidad * prod.precio
        total_pedido = total_pedido + prod.precio
        prod.subtotal_string = number_to_currency(prod.subtotal)
      return
    if existe == false
      productos.push({id: id, nombre: nombre, precio: precio, cantidad: 1 , subtotal: precio, precio_string: number_to_currency(precio), subtotal_string: number_to_currency(precio)})
      total_pedido = total_pedido + precio
      animate($(".total-items"), "wobble")

  localStorage.setItem("total_pedido", total_pedido)
  localStorage.setItem("productos", JSON.stringify(productos))
  cargar_productos()

#Enviar al controller el json del pedido
procesar_pedido = ->
  localStorage.removeItem("total_pedido")
  localStorage.removeItem("productos")
  cargar_productos()

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

sticky = (obj) ->
  bar = obj.offset().top
  if $(window).scrollTop() >= bar
    if obj.hasClass('sticky-custom') == false
      obj.addClass 'sticky-custom'
      $(window).scrollTop bar + 1
      $('#btn-cart_float').addClass 'd-md-block'
  else
    if obj.hasClass('sticky-custom')
      obj.removeClass 'sticky-custom'
      $('#btn-cart_float').removeClass 'd-md-block'
  return

animate = (item, efecto) ->
  anim = "#{efecto} animated"
  item.addClass(anim).one 'animationend webkitAnimationEnd oAnimationEnd MSAnimationEnd', ->
    item.removeClass(anim)
    return
  return
