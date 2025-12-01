name: cross-platform-check

on:
  push:
  workflow_dispatch:

jobs:
  gather-info:
    strategy:
      matrix:
        platform: [ubuntu-latest, windows-latest, macos-latest]

    runs-on: ${{ matrix.platform }}

    steps:
      - name: Obtener repositorio
        uses: actions/checkout@v4

      # Para Linux y macOS
      - name: Datos del sistema (Unix)
        if: runner.os != 'Windows'
        run: |
          echo "--- Información del sistema ---" > report.txt
          echo "SO y kernel:" >> report.txt
          uname -a >> report.txt

          echo "--- Variables de entorno ---" >> report.txt
          printenv >> report.txt

      # Para Windows
      - name: Datos del sistema (Windows)
        if: runner.os == 'Windows'
        shell: powershell
        run: |
          "--- Información del sistema ---" | Out-File report.txt
          systeminfo | Out-File -Append report.txt

          "--- Variables de entorno ---" | Out-File -Append report.txt
          Get-ChildItem Env: | Out-File -Append report.txt

      - name: Guardar reporte generado
        uses: actions/upload-artifact@v4
        with:
          name: info-${{ matrix.platform }}
          path: report.txt
