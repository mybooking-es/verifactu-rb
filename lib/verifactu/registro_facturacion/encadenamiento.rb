module Verifactu
  module RegistroFacturacion
    class Encadenamiento
      attr_reader :primer_registro, :id_emisor_factura, :num_serie_factura, :fecha_expedicion, :huella
      private_class_method :new

      # Crea una instancia de Encadenamiento para el primer registro.
      # @return [Encadenamiento] Instancia de Encadenamiento para el primer registro
      def self.crea_encadenamiento_primer_registro
        new(primer_registro: 'S')
      end

      # Crea una instancia de Encadenamiento para un registro posterior.
      # @param [String] id_emisor_factura ID del emisor de la factura.
      # @param [String] num_serie_factura Número de serie de la factura.
      # @param [String] fecha_expedicion Fecha de expedición de la factura.
      # @param [String] huella Huella del registro anterior.
      # @return [Encadenamiento] Instancia de Encadenamiento para un registro posterior
      def self.crea_encadenamiento_registro_anterior(id_emisor_factura:, num_serie_factura:, fecha_expedicion:, huella:)
        raise ArgumentError, "id_emisor_factura is required" if id_emisor_factura.nil?
        raise ArgumentError, "num_serie_factura is required" if num_serie_factura.nil?
        raise ArgumentError, "fecha_expedicion is required" if fecha_expedicion.nil?
        raise ArgumentError, "huella is required" if huella.nil?

        Helper::Validador.validar_nif(id_emisor_factura)

        raise ArgumentError, "num_serie_factura debe ser una String" unless num_serie_factura.is_a?(String)
        raise ArgumentError, "num_serie_factura no puede estar vacío" if num_serie_factura.empty?
        raise ArgumentError, "num_serie_factura debe tener maximo 60 caracteres" if num_serie_factura.length > 60

        Helper::Validador.validar_fecha_pasada(fecha_expedicion)
        raise ArgumentError, "fecha_expedicion no debe ser inferior a 28/10/2024" if fecha_expedicion < Date.new(2024, 10, 28)

        raise ArgumentError, "num_serie_factura debe contener solo caracteres ASCII imprimibles" unless num_serie_factura.ascii_only? && num_serie_factura.chars.all? { |char| char.ord.between?(32, 126) }

        raise ArgumentError, "huella debe ser una String" if !huella.is_a?(String)
        raise ArgumentError, "huella debe tener 64 caracteres hexadecimales" if huella.length != 64 || !huella.upcase.match?(/\A[A-F0-9]{64}\z/)

        registro = new(primer_registro: 'N')
        registro.instance_variable_set(:@id_emisor_factura, id_emisor_factura)
        registro.instance_variable_set(:@num_serie_factura, num_serie_factura)
        registro.instance_variable_set(:@fecha_expedicion, fecha_expedicion)
        registro.instance_variable_set(:@huella, huella)

      end

      private

      def initialize(primer_registro: 'N')
        raise ArgumentError, "primer_registro debe ser 'S' o 'N'" unless ['S', 'N'].include?(primer_registro)
        @primer_registro = primer_registro
      end


    end
  end
end
