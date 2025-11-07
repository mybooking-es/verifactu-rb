module Verifactu
  module InvoiceRegistration
    # Represents <sum1:ImporteRectificacion>
    class RectificationAmount
      attr_reader :base_rectificada, :cuota_rectificada, :cuota_recargo_rectificada

      def initialize(base_rectificada:, cuota_rectificada:, cuota_recargo_rectificada: nil)
        raise Verifactu::VerifactuError, "base_rectificada is required" if base_rectificada.nil?
        raise Verifactu::VerifactuError, "cuota_rectificada is required" if cuota_rectificada.nil?

        raise Verifactu::VerifactuError, "base_rectificada must have at most 12 digits before the decimal and two decimals" unless Verifactu::Helper::Validador.validar_digito(base_rectificada)
        raise Verifactu::VerifactuError, "cuota_rectificada must have at most 12 digits before the decimal and two decimals" unless Verifactu::Helper::Validador.validar_digito(cuota_rectificada)

        unless cuota_recargo_rectificada.nil?
          raise Verifactu::VerifactuError, "cuota_recargo_rectificada must have at most 12 digits before the decimal and two decimals" unless Verifactu::Helper::Validador.validar_digito(cuota_recargo_rectificada)
        end

        @base_rectificada = base_rectificada
        @cuota_rectificada = cuota_rectificada
        @cuota_recargo_rectificada = cuota_recargo_rectificada
      end
    end
  end
end
