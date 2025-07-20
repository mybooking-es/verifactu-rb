module Verifactu
  class Factura
    attr_reader :id_version, :nombre_razon_emisor, :id_emisor_factura, :num_serie_factura,
                :fecha_expedicion, :tipo_registro_sif, :tipo_factura, :descripcion_operacion,
                :destinatario, :lineas, :importe_total, :encadenamiento_registro_anterior,
                :sif, :fecha_gen_registro, :hora_gen_registro, :huso_horario_gen_registro,
                :huella, :tipo_hash

    #
    # Inicializa una factura con todos los campos requeridos.
    #
    # @param id_version [String]
    # @param nombre_razon_emisor [String]
    # @param id_emisor_factura [Verifactu::Emisor]
    # @param num_serie_factura [String]
    # @param fecha_expedicion [String] formato "YYYY-MM-DD"
    # @param tipo_registro_sif [String]
    # @param tipo_factura [String] Ej: "F1"
    # @param descripcion_operacion [String]
    # @param destinatario [Verifactu::Destinatario]
    # @param lineas [Array<Verifactu::LineaFactura>]
    # @param importe_total [Float]
    # @param encadenamiento_registro_anterior [Verifactu::EncadenamientoRegistroAnterior]
    # @param sif [Verifactu::Sif]
    # @param fecha_gen_registro [String] formato "YYYY-MM-DD"
    # @param hora_gen_registro [String] formato "HH:MM:SS"
    # @param huso_horario_gen_registro [String] Ej: "+0200"
    # @param huella [String] hash actual
    # @param tipo_hash [String] Ej: "01"
    #
    def initialize(
      id_version:,
      nombre_razon_emisor:,
      id_emisor_factura:,
      num_serie_factura:,
      fecha_expedicion:,
      tipo_registro_sif:,
      tipo_factura:,
      descripcion_operacion:,
      destinatario:,
      lineas:,
      importe_total:,
      encadenamiento_registro_anterior:,
      sif:,
      fecha_gen_registro:,
      hora_gen_registro:,
      huso_horario_gen_registro:,
      huella:,
      tipo_hash:
    )
      @id_version = id_version
      @nombre_razon_emisor = nombre_razon_emisor
      @id_emisor_factura = id_emisor_factura
      @num_serie_factura = num_serie_factura
      @fecha_expedicion = fecha_expedicion
      @tipo_registro_sif = tipo_registro_sif
      @tipo_factura = tipo_factura
      @descripcion_operacion = descripcion_operacion
      @destinatario = destinatario
      @lineas = lineas
      @importe_total = importe_total
      @encadenamiento_registro_anterior = encadenamiento_registro_anterior
      @sif = sif
      @fecha_gen_registro = fecha_gen_registro
      @hora_gen_registro = hora_gen_registro
      @huso_horario_gen_registro = huso_horario_gen_registro
      @huella = huella
      @tipo_hash = tipo_hash
    end
  end
end
