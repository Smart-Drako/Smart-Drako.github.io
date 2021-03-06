# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_12_042929) do

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "config_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "category_id"
    t.string "nombre"
    t.string "slogan"
    t.string "descripcion"
    t.string "direccion"
    t.string "pagina"
    t.string "facebook"
    t.string "whatsapp"
    t.string "telefono"
    t.string "horario"
    t.text "condiciones_higiene"
    t.string "tipo_entrega"
    t.string "costo_envio"
    t.string "compra_minima"
    t.string "metodo_pago"
    t.string "beneficiario"
    t.string "cuenta"
    t.string "banco"
    t.string "aviso"
    t.string "comentario"
    t.string "factura"
    t.string "logo"
    t.boolean "activo", default: true
    t.string "slug"
    t.boolean "tipo_card", default: false
    t.boolean "vista_card", default: false, null: false
    t.integer "estatus"
    t.datetime "fecha_registro"
    t.datetime "fecha_inicio"
    t.datetime "fecha_vencimiento"
    t.bigint "plan_id"
    t.boolean "admin", default: false, null: false
    t.integer "pedidos_restantes", default: 0, null: false
    t.string "estado"
    t.string "ciudad"
    t.string "reparto"
    t.boolean "reparto_activo", default: false
    t.boolean "mostrar_direccion", default: false
    t.boolean "recibir_whatsapp", default: false
    t.boolean "pago_activo", default: false
    t.boolean "pago_linea", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_config_users_on_category_id"
    t.index ["plan_id"], name: "index_config_users_on_plan_id"
    t.index ["slug"], name: "index_config_users_on_slug", unique: true
    t.index ["user_id"], name: "index_config_users_on_user_id"
  end

  create_table "estados", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "estado"
    t.string "ciudad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pagos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "pedido_id"
    t.datetime "fecha_pago"
    t.string "cliente_email"
    t.json "info_pago"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_id"], name: "index_pagos_on_pedido_id"
  end

  create_table "pedidos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "numero"
    t.integer "cliente_id"
    t.string "cliente_nombre"
    t.string "cliente_telefono"
    t.string "cliente_direccion"
    t.string "area_entrega"
    t.string "cliente_horario"
    t.string "cliente_metodo_pago"
    t.string "cliente_tipo_envio"
    t.boolean "cliente_factura"
    t.string "cliente_rfc"
    t.string "cliente_uso_cfdi"
    t.string "cliente_email"
    t.string "comentario"
    t.string "fecha"
    t.string "estatus"
    t.string "total"
    t.string "pago_con"
    t.string "reparto"
    t.string "envio"
    t.string "nota_repartidor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pedidos_on_user_id"
  end

  create_table "planes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombre"
    t.integer "no_pedidos"
    t.string "precio"
    t.string "precio_iva"
    t.integer "vigencia"
    t.boolean "ilimitado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "producto_fotos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "producto_id"
    t.string "imagen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["producto_id"], name: "index_producto_fotos_on_producto_id"
  end

  create_table "producto_pedidos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "pedido_id"
    t.integer "producto_id"
    t.string "nombre"
    t.string "precio"
    t.string "cantidad"
    t.string "unidad"
    t.string "subtotal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pedido_id"], name: "index_producto_pedidos_on_pedido_id"
  end

  create_table "productos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "codigo"
    t.string "inventario"
    t.string "categoria"
    t.string "descripcion"
    t.string "descripcion2"
    t.string "unidad"
    t.string "precio"
    t.string "impuesto"
    t.json "foto"
    t.string "proveedor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_productos_on_user_id"
  end

  create_table "recomendados", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "id_usuario"
    t.integer "id_padre"
    t.integer "id_abuelo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "nombre"
    t.string "apellido"
    t.string "telefono"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["telefono"], name: "index_users_on_telefono", unique: true
  end

end
