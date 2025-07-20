module Verifactu
  # Representa <sum:AltaFactuSistemaFacturacion>
  class AltaFactuSistemaFacturacion
    attr_reader :cabecera, :registro_alta_facturas

    def initialize(cabecera:, registro_alta_facturas:)
      raise ArgumentError, "cabecera is required" if cabecera.nil?
      raise ArgumentError, "registro_alta_facturas is required" if registro_alta_facturas.nil?
      raise ArgumentError, "cabecera must be an instance of Cabecera" unless cabecera.is_a?(Cabecera)
      raise ArgumentError, "registro_alta_facturas must be an instance of RegistroAltaFacturas" unless registro_alta_facturas.is_a?(RegistroAltaFacturas)
      @cabecera = cabecera
      @registro_alta_facturas = registro_alta_facturas
    end
  end
end
