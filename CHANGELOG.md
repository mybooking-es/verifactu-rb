## [Unreleased]

## [0.1.0] - 2025-07-16

- Initial release

## [0.2.0] - 2025-09-23

- Validacion de cadenas ahora tiene su propia validación en validador.rb (antes `cadena.is_a?(String)`)
- Validacion de fecha_hora_huso ahora tiene su propia validación en validador.rb (antes un unless ... raise)

- Verifactu ha hecho cambios en los documentos: (se mencionan solo los cambios que afectan a esta gema)
- - Ahora no se permiten los caracteres '<', '>' y '=' en los campos alfanumericos