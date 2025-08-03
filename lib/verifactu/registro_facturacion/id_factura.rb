module Verifactu
  module RegistroFacturacion
    # Representa <sum1:IDFactura>
    class IDFactura
      attr_reader :id_emisor_factura, :num_serie_factura, :fecha_expedicion_factura

      def initialize(id_emisor_factura:, num_serie_factura:, fecha_expedicion_factura:)
        raise ArgumentError, "id_emisor_factura is required" if id_emisor_factura.nil?
        raise ArgumentError, "num_serie_factura is required" if num_serie_factura.nil?
        raise ArgumentError, "fecha_expedicion_factura is required" if fecha_expedicion_factura.nil?

        Helper::Validador.validar_nif(id_emisor_factura)
        # El NIF del campo IDEmisorFactura debe ser el mismo que el del campo NIF de la agrupación ObligadoEmision del bloque Cabecera.

        raise ArgumentError, "num_serie_factura debe ser una String" if !num_serie_factura.is_a?(String)
        raise ArgumentError, "num_serie_factura no puede estar vacío" if num_serie_factura.empty?
        raise ArgumentError, "num_serie_factura debe tener maximo 60 caracteres" if num_serie_factura.length > 60

        Helper::Validador.validar_fecha_pasada(fecha_expedicion_factura)
        raise ArgumentError, "fecha_expedicion_factura no debe ser inferior a 28/10/2024" if Date.strptime(fecha_expedicion_factura, '%d-%m-%Y') < Date.new(2024, 10, 28)
        # Si Impuesto = “01” (IVA), “03” (IGIC) o no se cumplimenta (considerándose “01” - IVA), la
        # FechaExpedicionFactura solo puede ser anterior a la FechaOperacion, si ClaveRegimen = "14" o "15”.

        raise ArgumentError, "num_serie_factura debe contener solo caracteres ASCII imprimibles" unless num_serie_factura.ascii_only? && num_serie_factura.chars.all? { |char| char.ord.between?(32, 126) }

        @id_emisor_factura = id_emisor_factura
        @num_serie_factura = num_serie_factura
        @fecha_expedicion_factura = fecha_expedicion_factura
      end
    end
  end
end
