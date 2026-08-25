require 'spec_helper'

#
# Cubre los fallos de la ruta de CONSULTA que impedian construir un XML valido:
#
#   1. DatosAdicionalesRespuesta se emitia en el namespace `sum` cuando
#      ConsultaLR.xsd lo declara en `con` (elementFormDefault="qualified").
#   2. FiltroConsultaBuilder#con_fecha_expedicion_rango llamaba con keywords a
#      un metodo posicional -> ArgumentError.
#   3. FiltroConsultaBuilder#con_clave_paginacion, idem.
#   4. ClavePaginacion invocaba Verifactu::Helpers.fecha_valida?, que no existe
#      (el modulo es Verifactu::Helper::Validador).
#   5. ConsultaFactu::Consulta exigia una DatosAdicionalesRespuesta inexistente.
#   6. FiltroConsultaXmlBuilder emitia IdEmisorFactura en vez de IDEmisorFactura.
#
RSpec.describe 'Consulta de registros de facturacion' do

  let(:cabecera) { cabecera_consulta_valida }

  def build_and_validate(filtro, **extra)
    xml = Verifactu::ConsultaFactuXmlBuilder.build(
      cabecera: cabecera,
      filtro_consulta_xml: Verifactu::FiltroConsultaXmlBuilder.build(filtro),
      **extra
    ).root.to_xml
    [xml, Verifactu::Helpers::ValidaConsultaXSD.execute(xml)]
  end

  describe 'DatosAdicionalesRespuesta' do
    it 'se emite en el namespace con: y valida contra el XSD' do
      filtro = Verifactu::FiltroConsultaBuilder.new.con_periodo_imputacion('2025', '08').build

      xml, result = build_and_validate(filtro, nombre_razon_emisor: true, sistema_informatico: true)

      expect(result[:valid]).to be true
      expect(xml).to include('<con:DatosAdicionalesRespuesta>')
      expect(xml).to include('<con:MostrarNombreRazonEmisor>S</con:MostrarNombreRazonEmisor>')
      expect(xml).to include('<con:MostrarSistemaInformatico>S</con:MostrarSistemaInformatico>')
    end
  end

  describe 'FiltroConsultaBuilder#con_fecha_expedicion_rango' do
    it 'construye el rango sin ArgumentError y valida' do
      filtro = Verifactu::FiltroConsultaBuilder.new
               .con_periodo_imputacion('2025', '08')
               .con_fecha_expedicion_rango('01-08-2025', '31-08-2025')
               .build

      xml, result = build_and_validate(filtro)

      expect(result[:valid]).to be true
      expect(xml).to include('<sum:Desde>01-08-2025</sum:Desde>')
      expect(xml).to include('<sum:Hasta>31-08-2025</sum:Hasta>')
    end
  end

  describe 'FiltroConsultaBuilder#con_clave_paginacion' do
    it 'construye la clave de paginacion y emite IDEmisorFactura' do
      filtro = Verifactu::FiltroConsultaBuilder.new
               .con_periodo_imputacion('2025', '08')
               .con_clave_paginacion('B12345674', 'NC202500051', '22-07-2025')
               .build

      xml, result = build_and_validate(filtro)

      expect(result[:valid]).to be true
      expect(xml).to include('<sum:IDEmisorFactura>B12345674</sum:IDEmisorFactura>')
    end
  end

  describe 'ConsultaFactu::DatosAdicionalesRespuesta' do
    it 'existe y por defecto no pide campos extra' do
      datos = Verifactu::ConsultaFactu::DatosAdicionalesRespuesta.new

      expect(datos.mostrar_nombre_razon_emisor).to be false
      expect(datos.mostrar_sistema_informatico).to be false
    end
  end

  describe 'ConsultaFactu::Consulta' do
    let(:filtro) { Verifactu::FiltroConsultaBuilder.new.con_periodo_imputacion('2025', '08').build }

    it 'acepta DatosAdicionalesRespuesta' do
      datos = Verifactu::ConsultaFactu::DatosAdicionalesRespuesta.new(mostrar_nombre_razon_emisor: true)

      consulta = Verifactu::ConsultaFactu::Consulta.new(cabecera, filtro, datos)

      expect(consulta.datos_adicionales_respuesta).to eq(datos)
    end

    it 'acepta nil porque el XSD lo declara minOccurs=0' do
      consulta = Verifactu::ConsultaFactu::Consulta.new(cabecera, filtro, nil)

      expect(consulta.datos_adicionales_respuesta).to be_nil
    end

    it 'rechaza un tipo que no sea DatosAdicionalesRespuesta' do
      expect {
        Verifactu::ConsultaFactu::Consulta.new(cabecera, filtro, 'S')
      }.to raise_error(Verifactu::VerifactuError)
    end
  end

  describe 'filtro completo' do
    it 'combina periodo, num serie, contraparte, rango y ref externa' do
      filtro = Verifactu::FiltroConsultaBuilder.new
               .con_periodo_imputacion('2025', '08')
               .con_num_serie_factura('NC202500051')
               .con_contraparte_nif('Juan Gil Miqueo', '38124429C')
               .con_fecha_expedicion_rango('01-08-2025', '31-08-2025')
               .con_ref_externa('mybooking')
               .build

      _xml, result = build_and_validate(filtro, nombre_razon_emisor: true, sistema_informatico: true)

      expect(result[:valid]).to be true
    end
  end

end
