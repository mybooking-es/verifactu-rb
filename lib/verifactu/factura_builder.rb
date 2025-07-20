module Verifactu
  class FacturaBuilder
    def initialize
      @lineas = []
    end

    def con_id_version(valor)
      @id_version = valor
      self
    end

    def con_tipo_registro_sif(valor)
      @tipo_registro_sif = valor
      self
    end

    def con_tipo_hash(valor)
      @tipo_hash = valor
      self
    end

    def con_fecha_gen_registro(valor)
      @fecha_gen_registro = valor
      self
    end

    def con_hora_gen_registro(valor)
      @hora_gen_registro = valor
      self
    end

    def con_huso_horario_gen_registro(valor)
      @huso_horario_gen_registro = valor
      self
    end

    def con_emisor(nombre_razon:, nif:)
      @emisor = Emisor.new(nombre_razon: nombre_razon, nif: nif)
      self
    end

    def con_destinatario(nombre_razon:, nif:)
      @destinatario = Destinatario.new(nombre_razon: nombre_razon, nif: nif)
      self
    end

    def con_sif(**attrs)
      @sif = Sif.new(**attrs)
      self
    end

    def agregar_linea(**attrs)
      @lineas << LineaFactura.new(**attrs)
      self
    end

    def con_datos_factura(numero:, fecha:, tipo:, descripcion:)
      @num_serie_factura = numero
      @fecha_expedicion = fecha
      @tipo_factura = tipo
      @descripcion_operacion = descripcion
      self
    end

    def con_encadenamiento(nif:, num_serie_factura:, fecha_expedicion:, huella:)
      @encadenamiento = EncadenamientoRegistroAnterior.new(
        nif: nif,
        num_serie_factura: num_serie_factura,
        fecha_expedicion: fecha_expedicion,
        huella_registro_anterior: huella
      )
      self
    end

    def con_huella_actual(huella)
      @huella = huella
      self
    end

    def construir
      importe_total = @lineas.sum { |l| l.base_imponible_o_importe_no_sujeto + l.cuota_repercutida }

      Factura.new(
        id_version: @id_version,
        nombre_razon_emisor: @emisor.nombre_razon,
        id_emisor_factura: @emisor,
        num_serie_factura: @num_serie_factura,
        fecha_expedicion: @fecha_expedicion,
        tipo_registro_sif: @tipo_registro_sif,
        tipo_factura: @tipo_factura,
        descripcion_operacion: @descripcion_operacion,
        destinatario: @destinatario,
        lineas: @lineas,
        importe_total: importe_total,
        encadenamiento_registro_anterior: @encadenamiento,
        sif: @sif,
        fecha_gen_registro: @fecha_gen_registro,
        hora_gen_registro: @hora_gen_registro,
        huso_horario_gen_registro: @huso_horario_gen_registro,
        huella: @huella,
        tipo_hash: @tipo_hash
      )
    end
  end
end
