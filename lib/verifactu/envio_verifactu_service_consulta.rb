module Verifactu
  class EnvioVerifactuServiceConsulta < EnvioVerifactuServiceBase

    #
    # Validate the Schema
    #
    def validate_schema(registro_xml)
      Verifactu::Helpers::ValidaConsultaXSD.execute(registro_xml)
    end

    #
    # Builds the SOAP request for Verifactu
    # @param xml [String] XML del registro de envío a Verifactu
    # @return [String] SOAP request
    #
    def build_soap_request(xml)

      message = <<-SOAP
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                          xmlns:sum="https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/ConsultaLR.xsd"
                          xmlns:sum1="https://www2.agenciatributaria.gob.es/static_files/common/internet/dep/aplicaciones/es/aeat/tike/cont/ws/SuministroInformacion.xsd"
                          xmlns:xd="http://www.w3.org/2000/09/xmldsig#">
        <soapenv:Header/>
        <soapenv:Body>
            #{xml}
          </soapenv:Body>
        </soapenv:Envelope>
      SOAP

      return message.strip

    end

  end
end
