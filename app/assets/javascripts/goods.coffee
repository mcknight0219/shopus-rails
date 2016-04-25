#= require product

@product = new Product
$('.weui_btn_area input').click((event) =>
  event.preventDefault()
  if product.populate_from_form() then product.create() else product.alert_error()
)
