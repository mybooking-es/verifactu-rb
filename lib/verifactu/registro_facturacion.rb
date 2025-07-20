module Verifactu
  # Representa <sum:RegistroFacturacion>
  class RegistroFacturacion
    attr_reader :id_version, :id_factura, :nombre_razon_emisor, :tipo_registro_sif,
                :tipo_factura, :descripcion_operacion, :destinatarios, :desglose,
                :importe_total, :encadenamiento_registro_anterior, :sistema_informatico,
                :fecha_gen_registro, :hora_gen_registro, :huso_horario_gen_registro

    def initialize(id_version: "1.0", id_factura:, nombre_razon_emisor:, tipo_registro_sif:,
                   tipo_factura:, descripcion_operacion:, destinatarios:, desglose:,
                   importe_total:, encadenamiento_registro_anterior:, sistema_informatico:,
                   fecha_gen_registro:, hora_gen_registro:, huso_horario_gen_registro:)
      raise ArgumentError, "id_factura is required" if id_factura.nil?
      raise ArgumentError, "id_factura must be an instance of IDFactura" unless id_factura.is_a?(IDFactura)
      raise ArgumentError, "nombre_razon_emisor is required" if nombre_razon_emisor.nil?
      raise ArgumentError, "tipo_registro_sif is required" if tipo_registro_sif.nil?
      raise ArgumentError, "tipo_factura is required" if tipo_factura.nil?
      raise ArgumentError, "descripcion_operacion is required" if descripcion_operacion.nil?
      raise ArgumentError, "destinatarios is required" if destinatarios.nil?
      raise ArgumentError, "destinatarios must be an instance of Destinatarios" unless destinatarios.is_a?(Destinatarios)
      raise ArgumentError, "desglose is required" if desglose.nil?
      raise ArgumentError, "desglose must be an instance of Desglose" unless desglose.is_a?(Desglose)
      raise ArgumentError, "importe_total is required" if importe_total.nil?
      raise ArgumentError, "encadenamiento_registro_anterior is required" if encadenamiento_registro_anterior.nil?
      raise ArgumentError, "encadenamiento_registro_anterior must be an instance of EncadenamientoRegistroAnterior"
      raise ArgumentError, "sistema_informatico is required" if sistema_informatico.nil?
      raise ArgumentError, "sistema_informatico must be an instance of SistemaInformatico" unless sistema_informatico.is_a?(SistemaInformatico)
      raise ArgumentError, "fecha_gen_registro is required" if fecha_gen_registro.nil?
      raise ArgumentError, "hora_gen_registro is required" if hora_gen_registro.nil?
      raise ArgumentError, "huso_horario_gen_registro is required" if huso_horario_gen_registro.nil
      @id_version = id_version
      @id_factura = id_factura # Instancia de IDFactura
      @nombre_razon_emisor = nombre_razon_emisor
      @tipo_registro_sif = tipo_registro_sif
      @tipo_factura = tipo_factura
      @descripcion_operacion = descripcion_operacion
      @destinatarios = destinatarios # Instancia de Destinatarios
      @desglose = desglose # Instancia de Desglose
      @importe_total = importe_total
      @encadenamiento_registro_anterior = encadenamiento_registro_anterior # Instancia de EncadenamientoRegistroAnterior
      @sistema_informatico = sistema_informatico # Instancia de SistemaInformatico
      @fecha_gen_registro = fecha_gen_registro
      @hora_gen_registro = hora_gen_registro
      @huso_horario_gen_registro = huso_horario_gen_registro
    end
  end
end
