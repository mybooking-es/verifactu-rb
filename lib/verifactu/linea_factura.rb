module Verifactu
  class LineaFactura
    attr_reader :clave_regimen, :calificacion_operacion, :tipo_impositivo,
                :base_imponible_o_importe_no_sujeto, :cuota_repercutida

    #
    # @param clave_regimen [String] Código del régimen (01 = general, etc.).
    # @param calificacion_operacion [String] Tipo de operación (S1 = interior).
    # @param tipo_impositivo [Float] Porcentaje de IVA (ej. 21.0).
    # @param base_imponible_o_importe_no_sujeto [Float] Base imponible.
    # @param cuota_repercutida [Float] Importe del IVA.
    #
    def initialize(clave_regimen:, calificacion_operacion:, tipo_impositivo:,
                   base_imponible_o_importe_no_sujeto:, cuota_repercutida:)
      @clave_regimen = clave_regimen
      @calificacion_operacion = calificacion_operacion
      @tipo_impositivo = tipo_impositivo
      @base_imponible_o_importe_no_sujeto = base_imponible_o_importe_no_sujeto
      @cuota_repercutida = cuota_repercutida
    end
  end
end
