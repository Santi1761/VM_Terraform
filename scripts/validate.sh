#!/bin/bash

# Script de validación de Terraform
# Uso: ./scripts/validate.sh

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

log "Iniciando validación de Terraform..."

# Verificar que Terraform está instalado
if ! command -v terraform &> /dev/null; then
    error "Terraform no está instalado"
fi

# Verificar que tflint está instalado (opcional)
if command -v tflint &> /dev/null; then
    log "Ejecutando tflint..."
    tflint
else
    warn "tflint no está instalado. Instálalo para mejor validación: https://github.com/terraform-linters/tflint"
fi

# Verificar que tfsec está instalado (opcional)
if command -v tfsec &> /dev/null; then
    log "Ejecutando tfsec (análisis de seguridad)..."
    tfsec .
else
    warn "tfsec no está instalado. Instálalo para análisis de seguridad: https://github.com/aquasecurity/tfsec"
fi

# Formato de código
log "Verificando formato de código..."
if ! terraform fmt -check -recursive; then
    error "El código no está formateado correctamente. Ejecuta 'terraform fmt -recursive'"
fi

# Inicializar Terraform
log "Inicializando Terraform..."
terraform init

# Validar configuración
log "Validando configuración de Terraform..."
if ! terraform validate; then
    error "La configuración de Terraform no es válida"
fi

# Validar para cada entorno
for env in dev staging prod; do
    if [ -f "environments/${env}/terraform.tfvars" ]; then
        log "Validando configuración para entorno: $env"
        terraform plan -var-file="environments/${env}/terraform.tfvars" -out=/dev/null
    else
        warn "Archivo de variables no encontrado para entorno: $env"
    fi
done

log "Validación completada exitosamente"
