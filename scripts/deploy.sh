#!/bin/bash

# Script de despliegue de Terraform
# Uso: ./scripts/deploy.sh <environment> [action]
# Ejemplo: ./scripts/deploy.sh dev plan

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

# Verificar argumentos
if [ $# -lt 1 ]; then
    error "Uso: $0 <environment> [action]"
    echo "Entornos disponibles: dev, staging, prod"
    echo "Acciones disponibles: init, plan, apply, destroy, output"
    exit 1
fi

ENVIRONMENT=$1
ACTION=${2:-plan}

# Validar entorno
case $ENVIRONMENT in
    dev|staging|prod)
        ;;
    *)
        error "Entorno inválido: $ENVIRONMENT. Use: dev, staging, prod"
        ;;
esac

# Validar acción
case $ACTION in
    init|plan|apply|destroy|output)
        ;;
    *)
        error "Acción inválida: $ACTION. Use: init, plan, apply, destroy, output"
        ;;
esac

# Verificar que existe el archivo de variables
TFVARS_FILE="environments/${ENVIRONMENT}/terraform.tfvars"
if [ ! -f "$TFVARS_FILE" ]; then
    error "Archivo de variables no encontrado: $TFVARS_FILE"
fi

log "Iniciando $ACTION para entorno: $ENVIRONMENT"

# Verificar que Terraform está instalado
if ! command -v terraform &> /dev/null; then
    error "Terraform no está instalado"
fi

# Verificar que Azure CLI está instalado
if ! command -v az &> /dev/null; then
    error "Azure CLI no está instalado"
fi

# Verificar autenticación de Azure
if ! az account show &> /dev/null; then
    error "No estás autenticado en Azure. Ejecuta 'az login'"
fi

# Ejecutar acción de Terraform
case $ACTION in
    init)
        log "Inicializando Terraform..."
        terraform init
        ;;
    plan)
        log "Ejecutando plan de Terraform..."
        terraform plan -var-file="$TFVARS_FILE" -out="tfplan-${ENVIRONMENT}"
        ;;
    apply)
        log "Aplicando cambios de Terraform..."
        if [ -f "tfplan-${ENVIRONMENT}" ]; then
            terraform apply "tfplan-${ENVIRONMENT}"
        else
            terraform apply -var-file="$TFVARS_FILE" -auto-approve
        fi
        ;;
    destroy)
        warn "¿Estás seguro de que quieres destruir el entorno $ENVIRONMENT? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            log "Destruyendo infraestructura..."
            terraform destroy -var-file="$TFVARS_FILE" -auto-approve
        else
            log "Operación cancelada"
        fi
        ;;
    output)
        log "Mostrando outputs de Terraform..."
        terraform output
        ;;
esac

log "Operación completada exitosamente"
