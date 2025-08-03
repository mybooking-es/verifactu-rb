module Verifactu
  module RegistroFacturacion
    # Representa <sum1:ImporteRectificacion>
    class ImporteRectificacion
      attr_reader :base_rectificada, :cuota_rectificada, :cuota_recargo_rectificado

      def initialize(base_rectificada:, cuota_rectificada:, cuota_recargo_rectificado: nil)
        raise ArgumentError, "base_rectificada is required" if base_rectificada.nil?
        raise ArgumentError, "cuota_rectificada is required" if cuota_rectificada.nil?

        raise ArgumentError, "base_rectificada debe tener como mucho 12 dígitos antes del decimal y dos decimales" unless VERIFACTU::Helper::Validador.validar_digito(base_rectificada)

        raise ArgumentError, "cuota_rectificada debe tener como mucho 12 dígitos antes del decimal y dos decimales" unless VERIFACTU::Helper::Validador.validar_digito(cuota_rectificada)

        raise ArgumentError, "cuota_recargo_rectificado debe tener como mucho 12 dígitos antes del decimal y dos decimales" unless VERIFACTU::Helper::Validador.validar_digito(cuota_recargo_rectificado)

        @base_rectificada = base_rectificada
        @cuota_rectificada = cuota_rectificada
        @cuota_recargo_rectificado = cuota_recargo_rectificado
      end
    end
  end
end
