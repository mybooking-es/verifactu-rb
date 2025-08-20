module Verifactu
  module ConsultaFactu
    class FechaExpedicionFactura
      attr_reader :fecha_expedicion, :desde, :hasta

      private_class_method :new

      def self.fecha_expedicion_concreta(fecha_expedicion)
        raise Verifactu::VerifactuError, "Fecha de expedición is required" if fecha_expedicion.nil?
        raise Verifactu::VerifactuError, "Fecha de expedición must be a string date" unless Verifactu::Helper::Validador.fecha_valida?(fecha_expedicion)
        @fecha_expedicion_factura = new()
        @fecha_expedicion_factura.instance_variable_set(:@fecha_expedicion, fecha_expedicion)
        @fecha_expedicion_factura
      end

      def self.fecha_expedicion_rango(desde, hasta)
        raise Verifactu::VerifactuError, "Fecha desde is required" if desde.nil?
        raise Verifactu::VerifactuError, "Fecha hasta is required" if hasta.nil?
        raise Verifactu::VerifactuError, "Fecha desde must be a string date" unless Verifactu::Helper::Validador.fecha_valida?(desde)
        raise Verifactu::VerifactuError, "Fecha hasta must be a string date" unless Verifactu::Helper::Validador.fecha_valida?(hasta)

        @fecha_expedicion_factura = new()
        @fecha_expedicion_factura.instance_variable_set(:@desde, desde)
        @fecha_expedicion_factura.instance_variable_set(:@hasta, hasta)
        @fecha_expedicion_factura
      end

    end
  end
end
