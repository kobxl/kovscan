#!/bin/bash

# KovScan - Escáner de redes avanzado y profesional
# Autor: Kovenix Cybersecurity
# Fecha: 2025

# Colores para mejorar la interfaz
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para imprimir en colores
print_colored() {
    echo -e "${1}${2}${NC}"
}

# Introducción con estilo
print_colored $BLUE "🔍 Bienvenido a KovScan – Escáner avanzado de red"

# Solicitar IP o rango de red
read -p "📍 Ingresa la IP o el rango de red a escanear (Ejemplo: 192.168.1.0/24): " target

# Validar la IP o el rango
if [[ ! "$target" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(/([0-9]|[1-2][0-9]|3[0-2]))?$ ]]; then
  print_colored $RED "❌ IP o rango inválido. Intenta de nuevo."
  exit 1
fi

# Solicitar nombre del archivo de reporte
read -p "📝 Nombre para guardar el reporte (Ejemplo: reporte_escaneo): " report

# Solicitar si se desea hacer un escaneo de vulnerabilidades
read -p "🔒 ¿Deseas realizar un escaneo de vulnerabilidades? (Y/N): " vuln_scan

# Iniciar escaneo
print_colored $YELLOW "🚀 Iniciando escaneo contra $target ..."

# Comando Nmap avanzado
nmap_command="nmap -sV -O -T4 --script vuln -p- $target -oA ${report}_kovscan"

# Si se eligió hacer el escaneo de vulnerabilidades, agregamos los scripts de Nmap
if [[ "$vuln_scan" == "Y" || "$vuln_scan" == "y" ]]; then
    print_colored $YELLOW "🔒 Realizando escaneo de vulnerabilidades con Nmap..."
    nmap_command="nmap -sV -O -T4 --script vuln -p- $target -oA ${report}_kovscan"
else
    print_colored $GREEN "🔍 Realizando escaneo básico..."
fi

# Ejecutamos el comando Nmap
print_colored $GREEN "🔄 Ejecutando: $nmap_command"
$nmap_command

# Verificar si el escaneo fue exitoso
if [ $? -eq 0 ]; then
    print_colored $GREEN "✅ Escaneo completado. El reporte se ha guardado como ${report}_kovscan.*"
else
    print_colored $RED "❌ Hubo un error al realizar el escaneo. Intenta de nuevo."
    exit 1
fi

# Crear reporte en formato HTML
echo "<html>" > "${report}_kovscan_report.html"
echo "<head><title>Reporte de KovScan</title></head>" >> "${report}_kovscan_report.html"
echo "<body>" >> "${report}_kovscan_report.html"
echo "<h1>Reporte de KovScan - Escaneo Completo</h1>" >> "${report}_kovscan_report.html"
echo "<h2>Target: $target</h2>" >> "${report}_kovscan_report.html"
echo "<h3>Escaneo realizado el $(date)</h3>" >> "${report}_kovscan_report.html"
echo "<pre>" >> "${report}_kovscan_report.html"
cat "${report}_kovscan.nmap" >> "${report}_kovscan_report.html"
echo "</pre>" >> "${report}_kovscan_report.html"
echo "</body>" >> "${report}_kovscan_report.html"
echo "</html>" >> "${report}_kovscan_report.html"

# Confirmación final
print_colored $GREEN "🌐 Reporte HTML generado: ${report}_kovscan_report.html"
