# Infraestructura de VM en Azure con Terraform

**Autor:** Santiago Arboleda Velasco  
**Código Universitario:** A00369824  
**Curso:** Ingeniería de Software 5

## Descripción del Proyecto

Este proyecto implementa una infraestructura completa de Azure utilizando Terraform con arquitectura modular y mejores prácticas de DevOps. La infraestructura incluye:

- **Arquitectura Modular**: Separación de responsabilidades en módulos (red, seguridad, compute)
- **Múltiples Entornos**: Configuraciones específicas para dev, staging y producción
- **Seguridad Mejorada**: Uso de SSH keys, NSG restrictivos y validaciones robustas
- **CI/CD Integrado**: Pipeline automatizado con GitHub Actions
- **Monitoreo**: Boot diagnostics y logging centralizado
- **Versionado**: Control de versiones específicas de Terraform y providers

## Estructura del Proyecto

```
VM_Terraform/
├── main.tf                    # Configuración principal de recursos
├── variables.tf               # Definición de variables globales
├── outputs.tf                 # Valores de salida
├── terraform.tf               # Configuración de backend
├── terraform.tfvars.example  # Archivo de ejemplo para variables
├── .gitignore                # Archivos a ignorar en git
├── README.md                 # Este archivo
├── modules/                  # Módulos de Terraform
│   ├── network/              # Módulo de red
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/             # Módulo de seguridad
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── compute/              # Módulo de compute
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/             # Configuraciones por entorno
│   ├── dev/
│   │   └── terraform.tfvars
│   ├── staging/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
├── scripts/                  # Scripts de utilidad
│   ├── deploy.sh
│   └── validate.sh
└── .github/                  # Configuración de CI/CD
    └── workflows/
        └── terraform.yml
```

## Arquitectura Modular

### Módulo de Red (modules/network/)
Gestiona todos los componentes de red:
- **Virtual Network**: Red virtual con espacio de direcciones configurable
- **Subnet**: Subred para aislamiento de recursos
- **Public IP**: IP pública estática con SKU Standard
- **Network Interface**: Interfaz de red que conecta la VM

**Variables principales:**
- `address_space`: Espacio de direcciones de la VNet (default: 10.0.0.0/16)
- `subnet_address_prefixes`: Prefijos de la subred (default: 10.0.1.0/24)
- `tags`: Etiquetas para aplicar a los recursos

### Módulo de Seguridad (modules/security/)
Implementa políticas de seguridad de red:
- **Network Security Group**: Con reglas restrictivas y configurables
- **Reglas SSH**: Acceso SSH desde IPs específicas
- **Reglas HTTP/HTTPS**: Acceso web opcional
- **Regla de Denegación**: Bloquea todo el tráfico no permitido

**Variables principales:**
- `allowed_ssh_ips`: Lista de IPs permitidas para SSH
- `network_interface_id`: ID de la interfaz de red a proteger

### Módulo de Compute (modules/compute/)
Gestiona la máquina virtual y almacenamiento:
- **Linux Virtual Machine**: Ubuntu 22.04 LTS con configuración avanzada
- **SSH Key Management**: Generación automática de claves SSH
- **Disk Management**: Disco del SO y disco de datos opcional
- **Boot Diagnostics**: Diagnóstico de arranque integrado

**Variables principales:**
- `vm_size`: Tamaño de la VM con validación de formato
- `use_ssh_key`: Usar SSH keys en lugar de contraseñas
- `os_disk_type`: Tipo de disco del SO (Premium_LRS por defecto)
- `data_disk_size`: Tamaño del disco de datos (0 para deshabilitar)

## Recursos Implementados

### 1. **Resource Group** (`azurerm_resource_group`)
- Contenedor lógico para todos los recursos
- Ubicación configurable por entorno
- Etiquetado consistente y automático

### 2. **Storage Account** (`azurerm_storage_account`)
- Cuenta de almacenamiento para boot diagnostics
- Replicación LRS para optimización de costos
- Naming convention consistente

### 3. **Virtual Network** (`azurerm_virtual_network`)
- Red virtual con espacio de direcciones: `10.0.0.0/16`
- Configuración modular y reutilizable
- Etiquetado automático

### 4. **Subnet** (`azurerm_subnet`)
- Subred con rango: `10.0.1.0/24`
- Aislamiento de red para la VM
- Configuración flexible

### 5. **Network Security Group** (`azurerm_network_security_group`)
- Reglas de seguridad configurables
- SSH restringido a IPs específicas
- Reglas HTTP/HTTPS opcionales
- Regla de denegación por defecto

### 6. **Public IP** (`azurerm_public_ip`)
- IP pública estática para acceso externo
- SKU Standard para mayor seguridad
- Configuración modular

### 7. **Network Interface** (`azurerm_network_interface`)
- Interfaz de red que conecta la VM con la subred
- Asociada con la IP pública y el NSG
- Configuración automática

### 8. **Linux Virtual Machine** (`azurerm_linux_virtual_machine`)
- Ubuntu 22.04 LTS (Gen2)
- Tamaño configurable por entorno
- Autenticación por SSH key (recomendado)
- Boot diagnostics habilitado
- Patch mode automático

### 9. **Managed Disks** (`azurerm_managed_disk`)
- Disco de datos opcional para producción
- Configuración automática según entorno
- Tipos de disco configurables

## Variables Configurables

### Variables Globales

| Variable | Descripción | Tipo | Valor por Defecto | Validaciones |
|----------|-------------|------|-------------------|--------------|
| `prefix` | Prefijo para nombrar recursos | string | - | Solo minúsculas, números y guiones (max 20 chars) |
| `location` | Región de Azure | string | `eastus` | Debe ser una región válida de Azure |
| `environment` | Entorno de despliegue | string | `dev` | dev, staging, prod |
| `vm_size` | Tamaño de la VM | string | `Standard_B1s` | Formato Standard_XXX |
| `admin_username` | Usuario administrador | string | - | 3-20 caracteres |
| `use_ssh_key` | Usar SSH key | bool | `true` | - |
| `ssh_public_key` | Clave pública SSH | string | `null` | Se genera automáticamente si es null |
| `allowed_ssh_ips` | IPs permitidas para SSH | list(string) | `["0.0.0.0/0"]` | - |
| `tags` | Tags adicionales | map(string) | `{}` | - |

### Variables por Entorno

#### Desarrollo (dev)
- VM Size: Standard_B1s
- SSH desde cualquier IP
- Sin disco de datos
- Tags de desarrollo

#### Staging (staging)
- VM Size: Standard_B2s
- SSH desde cualquier IP
- Sin disco de datos
- Tags de staging

#### Producción (prod)
- VM Size: Standard_D2s_v3
- SSH restringido a IPs específicas
- Disco de datos de 100GB
- Tags de producción

## Instrucciones de Uso

### Prerrequisitos

1. **Terraform instalado** (versión 1.0+)
2. **Azure CLI instalado y configurado**
3. **Suscripción de Azure activa**
4. **Git** (para control de versiones)

### Configuración Inicial

1. **Clonar el repositorio:**
   ```bash
   git clone <url-del-repositorio>
   cd VM_Terraform
   ```

2. **Configurar Azure CLI:**
   ```bash
   az login
   az account set --subscription "tu-subscription-id"
   ```

3. **Configurar variables:**
   ```bash
   # Copiar archivo de ejemplo
   cp terraform.tfvars.example terraform.tfvars
   
   # Editar con tus valores
   nano terraform.tfvars
   ```

### Comandos de Terraform

#### 1. **Inicializar Terraform:**
```bash
terraform init
```
- Descarga los providers necesarios
- Configura el backend local

#### 2. **Validar la configuración:**
```bash
terraform validate
```
- Verifica la sintaxis de los archivos .tf
- Valida la configuración de recursos

#### 3. **Formatear código:**
```bash
terraform fmt -recursive
```
- Formatea automáticamente el código
- Aplica convenciones de estilo

#### 4. **Planificar la infraestructura:**
```bash
# Para desarrollo
terraform plan -var-file="environments/dev/terraform.tfvars"

# Para staging
terraform plan -var-file="environments/staging/terraform.tfvars"

# Para producción
terraform plan -var-file="environments/prod/terraform.tfvars"
```

#### 5. **Aplicar la configuración:**
```bash
# Para desarrollo
terraform apply -var-file="environments/dev/terraform.tfvars"

# Para staging
terraform apply -var-file="environments/staging/terraform.tfvars"

# Para producción
terraform apply -var-file="environments/prod/terraform.tfvars"
```

#### 6. **Ver el estado:**
```bash
terraform show
```

#### 7. **Ver outputs:**
```bash
terraform output
```

#### 8. **Destruir la infraestructura:**
```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

### Uso de Scripts

#### Script de Despliegue
```bash
# Desplegar en desarrollo
./scripts/deploy.sh dev apply

# Planificar en staging
./scripts/deploy.sh staging plan

# Destruir entorno de desarrollo
./scripts/deploy.sh dev destroy

# Ver outputs
./scripts/deploy.sh dev output
```

#### Script de Validación
```bash
# Validar toda la configuración
./scripts/validate.sh
```

## Outputs del Sistema

El sistema genera los siguientes outputs:

- **`public_ip`**: Dirección IP pública de la VM
- **`private_ip`**: Dirección IP privada de la VM
- **`vm_name`**: Nombre de la máquina virtual
- **`resource_group_name`**: Nombre del grupo de recursos
- **`ssh_command`**: Comando completo para conectarse vía SSH
- **`ssh_private_key`**: Clave privada SSH (si se generó)
- **`ssh_public_key`**: Clave pública SSH
- **`vm_id`**: ID de la máquina virtual
- **`vnet_id`**: ID de la Virtual Network
- **`subnet_id`**: ID de la subred

## CI/CD con GitHub Actions

### Pipeline Automatizado

El proyecto incluye un pipeline de CI/CD completo:

1. **Validación Automática**:
   - Formato de código (terraform fmt)
   - Validación de sintaxis (terraform validate)
   - Análisis de seguridad (tfsec)
   - Linting (tflint)

2. **Despliegue por Entornos**:
   - **Pull Requests**: Solo validación
   - **Branch main**: Despliegue automático a dev y staging
   - **Branch main**: Despliegue manual a producción (requiere aprobación)

### Configuración de Secretos

Para usar el pipeline, configura estos secretos en GitHub:

1. **AZURE_CREDENTIALS**: Credenciales de Azure
   ```json
   {
     "clientId": "tu-client-id",
     "clientSecret": "tu-client-secret",
     "subscriptionId": "tu-subscription-id",
     "tenantId": "tu-tenant-id"
   }
   ```

### Workflow de Despliegue

1. **Push a main**: Despliega automáticamente a dev y staging
2. **Pull Request**: Solo ejecuta validaciones
3. **Producción**: Requiere aprobación manual

## Consideraciones de Seguridad

### 1. **Archivo `.gitignore`** configurado para excluir:
   - Archivos de estado (`*.tfstate`)
   - Variables sensibles (`*.tfvars`)
   - Directorios de Terraform (`.terraform/`)
   - Archivos de plan (`*.tfplan`)

### 2. **Variables sensibles** marcadas como `sensitive = true`

### 3. **NSG configurado** con reglas restrictivas:
   - SSH restringido a IPs específicas
   - Reglas HTTP/HTTPS opcionales
   - Denegación por defecto

### 4. **Autenticación SSH**:
   - Uso de SSH keys en lugar de contraseñas
   - Generación automática de claves
   - Almacenamiento seguro opcional

### 5. **Validaciones robustas**:
   - Constraints en todas las variables
   - Validación de formatos y rangos
   - Verificación de entornos válidos

## Monitoreo y Observabilidad

### Boot Diagnostics
- Habilitado por defecto
- Almacenamiento en cuenta dedicada
- Diagnóstico de problemas de arranque

### Logging
- Tags consistentes en todos los recursos
- Timestamps automáticos
- Identificación de entornos

### Métricas
- Monitoreo básico de VM
- Métricas de red
- Uso de almacenamiento

## Troubleshooting

### Error: "Authentication failed"
```bash
# Verificar credenciales de Azure
az account show
az login --tenant <tenant-id>
```

### Error: "Resource group not found"
```bash
# Verificar que el resource group existe
az group list --output table
```

### Error: "VM not accessible"
```bash
# Verificar reglas de NSG
az network nsg rule list --resource-group <rg-name> --nsg-name <nsg-name>

# Verificar conectividad
az network watcher test-connectivity --source-resource <vm-id> --dest-address <ip>
```

### Error: "SSH connection failed"
```bash
# Verificar clave SSH
terraform output ssh_private_key > id_rsa
chmod 600 id_rsa
ssh -i id_rsa <username>@<public-ip>

# Verificar reglas de NSG
az network nsg rule list --resource-group <rg-name> --nsg-name <nsg-name>
```

### Error: "Terraform validation failed"
```bash
# Ejecutar validación completa
./scripts/validate.sh

# Verificar formato
terraform fmt -check -recursive

# Verificar sintaxis
terraform validate
```

## Mejoras Implementadas

### Arquitectura Modular
- **Módulo de Red**: Gestión centralizada de VNet, subredes e IPs públicas
- **Módulo de Seguridad**: NSG con reglas restrictivas y configurables
- **Módulo de Compute**: VM con opciones avanzadas de configuración

### Seguridad Mejorada
- **SSH Keys**: Autenticación por clave en lugar de contraseñas
- **NSG Restrictivo**: Reglas de seguridad más estrictas
- **Validaciones**: Constraints robustos en variables
- **Variables Sensibles**: Manejo seguro de información confidencial

### CI/CD y Automatización
- **GitHub Actions**: Pipeline automatizado para validación y despliegue
- **Validación Automática**: Formato, sintaxis y seguridad
- **Despliegue por Entornos**: Configuraciones específicas para cada entorno
- **Scripts de Utilidad**: Herramientas para facilitar el manejo

### Monitoreo y Observabilidad
- **Boot Diagnostics**: Diagnóstico de arranque de VMs
- **Logging Centralizado**: Registros estructurados
- **Tags Consistentes**: Etiquetado uniforme para todos los recursos

### Mejores Prácticas de DevOps
- **Versionado Específico**: Versiones fijas de Terraform y providers
- **Separación de Entornos**: Configuraciones independientes
- **Documentación Completa**: Guías detalladas de uso
- **Validación Continua**: Verificación automática de calidad

## Próximos Pasos Recomendados

1. **Configurar GitHub Actions**: Agregar secretos de Azure en GitHub
2. **Personalizar Entornos**: Ajustar configuraciones según tus necesidades
3. **Implementar Key Vault**: Para manejo seguro de secretos
4. **Agregar Monitoreo**: Implementar Azure Monitor y alertas
5. **Backup Strategy**: Configurar políticas de backup automático
6. **Multi-region**: Implementar despliegue en múltiples regiones
7. **Load Balancer**: Agregar balanceador de carga para alta disponibilidad