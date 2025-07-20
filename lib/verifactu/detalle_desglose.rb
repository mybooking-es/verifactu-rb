module Verifactu
  # Representa <sum1:DetalleDesglose>
  class DetalleDesglose
    attr_reader :clave_regimen, :calificacion_operacion, :tipo_impositivo, :base_imponible_o_importe_no_sujeto, :cuota_repercutida

    def initialize(clave_regimen:, calificacion_operacion:, tipo_impositivo:, base_imponible_o_importe_no_sujeto:, cuota_repercutida:)
      @clave_regimen = clave_regimen
      @calificacion_operacion = calificacion_operacion
      @tipo_impositivo = tipo_impositivo
      @base_imponible_o_importe_no_sujeto = base_imponible_o_importe_no_sujeto
      @cuota_repercutida = cuota_repercutida
    end
  end
end
