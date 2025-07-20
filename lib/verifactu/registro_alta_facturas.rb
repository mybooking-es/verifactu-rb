module Verifactu
  # Representa <sum:RegistroAltaFacturas>
  class RegistroAltaFacturas
    attr_reader :registro_facturacion, :datos_control

    def initialize(registro_facturacion:, datos_control:)
      raise ArgumentError, "registro_facturacion is required" if registro_facturacion.nil?
      raise ArgumentError, "datos_control is required" if datos_control.nil?
      raise ArgumentError, "registro_facturacion must be an instance of RegistroFacturacion" unless registro_facturacion.is_a?(RegistroFacturacion)
      raise ArgumentError, "datos_control must be an instance of DatosControl" unless datos_control.is_a?(DatosControl)
      @registro_facturacion = registro_facturacion # Instancia de RegistroFacturacion
      @datos_control = datos_control # Instancia de DatosControl
    end
  end
end
