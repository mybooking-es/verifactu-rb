require 'digest'
module Verifactu
  module Helper
    #
    # Genera la huella para el registro de alta de una factura.
    #
    class GenerarHuellaRegistroAlta

      # Ejecuta la generación de la huella para el registro de alta de una factura.
      # @param [String] id_emisor_factura ID del emisor de la factura.
      # @param [String] num_serie_factura Número de serie de la factura.
      # @param [String] fecha_expedicion_factura Fecha de expedición de la factura en formato 'dd-MM-yyyy'.
      # @param [String] tipo_factura Tipo de la factura, e.g., 'F1' para factura ordinaria.
      # @param [String] cuota_total Cuota total de la factura.
      # @param [String] importe_total Importe total de la factura.
      # @param [String] huella Huella de la factura, opcional. (en blanco para el primer registro o la anterior)
      # @param [String] fecha_hora_huso_gen_registro Fecha y hora de generación del registro en formato ISO 8601.
      # @return [String] La huella generada como un hash SHA256.
      def self.execute(id_emisor_factura:, num_serie_factura:, fecha_expedicion_factura:, tipo_factura:, cuota_total:,
                       importe_total:, huella:, fecha_hora_huso_gen_registro:)

        # Prepara el texto para generar la huella
        elements = []
        elements << "IDEmisorFactura=#{id_emisor_factura}"
        elements << "NumSerieFactura=#{num_serie_factura}"
        elements << "FechaExpedicionFactura=#{fecha_expedicion_factura}"
        elements << "TipoFactura=#{tipo_factura}"
        elements << "CuotaTotal=#{cuota_total}"
        elements << "ImporteTotal=#{importe_total}"
        elements << "Huella=#{huella ? huella : ''}"
        elements << "FechaHoraHusoGenRegistro=#{fecha_hora_huso_gen_registro}"
        text = elements.join('&')

        # Generar la huella como un hash SHA256 del texto concatenado
        Digest::SHA256.hexdigest(text).upcase

      end

    end
  end
end
