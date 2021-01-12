class ConfigUsersController < ApplicationController
  before_action :set_config_user, only: [:update]


  def update
    @config_user.update!(config_user_params)
    redirect_to me_path and return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config_user
      @config_user = ConfigUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def config_user_params
      params.require(:config_user).permit(:user_id, :category_id, :nombre, :slogan, :descripcion, :direccion, :pagina, :facebook, :whatsapp, :telefono, :horario, :condiciones_higiene, :tipo_entrega, :costo_envio, :compra_minima, :metodo_pago, :factura, :beneficiario, :cuenta, :banco, :aviso, :comentario, :vista_card, :logo, :estado, :ciudad, :reparto, :mostrar_direccion, :recibir_whatsapp)
    end
end
