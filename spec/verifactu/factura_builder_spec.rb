# spec/verifactu/factura_builder_spec.rb

require 'spec_helper'

RSpec.describe Verifactu::FacturaBuilder do
  describe '#construir' do
    it 'construye la factura correctamente con los datos dados' do
      builder = Verifactu::FacturaBuilder.new

      factura = builder
        .con_id_version("1.0")
        .con_tipo_registro_sif("01")
        .con_tipo_hash("01")
        .con_fecha_gen_registro("2025-07-16")
        .con_hora_gen_registro("13:55:32")
        .con_huso_horario_gen_registro("+0200")
        .con_emisor(nombre_razon: "Mi Empresa", nif: "B12345678")
        .con_destinatario(nombre_razon: "Cliente", nif: "12345678Z")
        .con_datos_factura(numero: "A2025/001", fecha: "2025-07-16", tipo: "F1", descripcion: "Servicio")
        .agregar_linea(clave_regimen: "01", calificacion_operacion: "S1", tipo_impositivo: 21.0,
                       base_imponible_o_importe_no_sujeto: 100.0, cuota_repercutida: 21.0)
        .con_encadenamiento(nif: "B12345678", num_serie_factura: "A2025/000", fecha_expedicion: "2025-07-15", huella: "abc123...")
        .con_sif(nombre_razon: "Mi Empresa", nif: "B12345678", nombre_sistema_informatico: "MiSaaS",
                 id_sistema_informatico: "SIF001", version: "1.0.0", numero_instalacion: "001",
                 tipo_uso_posible_solo_verifactu: "S", tipoUsoPosibleOtros: "N", tipoUsoPosibleMultiOT: "N")
        .con_huella_actual("xyz789...")
        .construir

      expect(factura.id_version).to eq("1.0")
      expect(factura.tipo_registro_sif).to eq("01")
      expect(factura.tipo_hash).to eq("01")
      expect(factura.fecha_gen_registro).to eq("2025-07-16")
      expect(factura.hora_gen_registro).to eq("13:55:32")
      expect(factura.huso_horario_gen_registro).to eq("+0200")

      expect(factura.emisor[:nombre_razon]).to eq("Mi Empresa")
      expect(factura.emisor[:nif]).to eq("B12345678")

      expect(factura.destinatario[:nombre_razon]).to eq("Cliente")
      expect(factura.destinatario[:nif]).to eq("12345678Z")

      expect(factura.datos_factura[:numero]).to eq("A2025/001")
      expect(factura.datos_factura[:fecha]).to eq("2025-07-16")
      expect(factura.datos_factura[:tipo]).to eq("F1")
      expect(factura.datos_factura[:descripcion]).to eq("Servicio")

      expect(factura.lineas.size).to eq(1)
      linea = factura.lineas.first
      expect(linea[:clave_regimen]).to eq("01")
      expect(linea[:calificacion_operacion]).to eq("S1")
      expect(linea[:tipo_impositivo]).to eq(21.0)
      expect(linea[:base_imponible_o_importe_no_sujeto]).to eq(100.0)
      expect(linea[:cuota_repercutida]).to eq(21.0)

      expect(factura.encadenamiento[:nif]).to eq("B12345678")
      expect(factura.encadenamiento[:num_serie_factura]).to eq("A2025/000")
      expect(factura.encadenamiento[:fecha_expedicion]).to eq("2025-07-15")
      expect(factura.encadenamiento[:huella]).to eq("abc123...")

      expect(factura.sif[:nombre_razon]).to eq("Mi Empresa")
      expect(factura.sif[:nif]).to eq("B12345678")
      expect(factura.sif[:nombre_sistema_informatico]).to eq("MiSaaS")
      expect(factura.sif[:id_sistema_informatico]).to eq("SIF001")
      expect(factura.sif[:version]).to eq("1.0.0")
      expect(factura.sif[:numero_instalacion]).to eq("001")
      expect(factura.sif[:tipo_uso_posible_solo_verifactu]).to eq("S")
      expect(factura.sif[:tipoUsoPosibleOtros]).to eq("N")
      expect(factura.sif[:tipoUsoPosibleMultiOT]).to eq("N")

      expect(factura.huella_actual).to eq("xyz789...")
    end
  end
end
