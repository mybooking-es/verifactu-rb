module Verifactu
  module ConsultaFactu
    Class FechaExpedicionFactura
      attr_reader :fecha_expedicion, :desde, :hasta

      private_class_method :new

      def self.fecha_expedicion_concreta(fecha_expedicion)
        raise Verifactu::VerifactuError, "Fecha de expedición is required" if fecha_expedicion.nil?
        raise Verifactu::VerifactuError, "Fecha de expedición must be a string date" unless Verifactu::Helpers.fecha_valida?(fecha_expedicion)
        @fecha_expedicion = fecha_expedicion
      end

      def self.fecha_expedicion_rango(desde, hasta)
        raise Verifactu::VerifactuError, "Fecha desde is required" if desde.nil?
        raise Verifactu::VerifactuError, "Fecha hasta is required" if hasta.nil?
        raise Verifactu::VerifactuError, "Fecha desde must be a string date" unless Verifactu::Helpers.fecha_valida?(desde)
        raise Verifactu::VerifactuError, "Fecha hasta must be a string date" unless Verifactu::Helpers.fecha_valida?(hasta)

        @desde = desde
        @hasta = hasta
      end
    
  end
end