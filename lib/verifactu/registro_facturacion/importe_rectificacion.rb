module Verifactu
  module RegistroFacturacion
    # Representa <sum1:ImporteRectificacion>
    class ImporteRectificacion
      attr_reader :base_rectificada, :cuota_rectificada, :cuota_recargo_rectificada

      def initialize(base_rectificada:, cuota_rectificada:, cuota_recargo_rectificada: nil)
        raise Verifactu::VerifactuError, "base_rectificada is required" if base_rectificada.nil?
        raise Verifactu::VerifactuError, "cuota_rectificada is required" if cuota_rectificada.nil?

        raise Verifactu::VerifactuError, "base_rectificada debe tener como mucho 12 dígitos antes del decimal y dos decimales" unless Verifactu::Helper::Validador.validar_digito(base_rectificada)
        raise Verifactu::VerifactuError, "cuota_rectificada debe tener como mucho 12 dígitos antes del decimal y dos decimales" unless Verifactu::Helper::Validador.validar_digito(cuota_rectificada)

        unless cuota_recargo_rectificada.nil?
          raise Verifactu::VerifactuError, "cuota_recargo_rectificada debe tener como mucho 12 dígitos antes del decimal y dos decimales" unless Verifactu::Helper::Validador.validar_digito(cuota_recargo_rectificada)
        end

        @base_rectificada = base_rectificada
        @cuota_rectificada = cuota_rectificada
        @cuota_recargo_rectificada = cuota_recargo_rectificada
      end
    end
  end
end
