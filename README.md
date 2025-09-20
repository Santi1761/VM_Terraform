# Infraestructura de VM en Azure con Terraform

**Autor:** Santiago Arboleda Velasco  
**Código Universitario:** A00369824  
**Curso:** Ingeniería de Software 5

## 📋 Descripción del Proyecto

Este proyecto implementa una infraestructura completa de Azure utilizando Terraform para crear una máquina virtual Linux con todos los componentes de red necesarios. La infraestructura incluye un grupo de recursos, red virtual, subred, grupo de seguridad de red, IP pública y una máquina virtual Ubuntu 22.04 LTS.


## Estructura del Proyecto

```
VM_Terraform/
├── main.tf              # Configuración principal de recursos
├── variables.tf         # Definición de variables
├── outputs.tf           # Valores de salida
├── terraform.tvars      # Valores de variables (ignorado por git)
├── .gitignore          # Archivos a ignorar en git
├── README.md           # Este archivo
└── terraform.tfstate   # Estado de Terraform (ignorado por git)
```

## 🔧 Recursos Implementados

### 1. **Resource Group** (`azurerm_resource_group`)
- Contenedor lógico para todos los recursos
- Ubicación: East US
- Etiquetas de identificación

### 2. **Virtual Network** (`azurerm_virtual_network`)
- Red virtual con espacio de direcciones: `10.0.0.0/16`
- Permite comunicación entre recursos

### 3. **Subnet** (`azurerm_subnet`)
- Subred con rango: `10.0.1.0/24`
- Aislamiento de red para la VM

### 4. **Network Security Group** (`azurerm_network_security_group`)
- Regla de seguridad para permitir SSH (puerto 22)
- Protección de la VM

### 5. **Public IP** (`azurerm_public_ip`)
- IP pública estática para acceso externo
- SKU Standard para mayor seguridad

### 6. **Network Interface** (`azurerm_network_interface`)
- Interfaz de red que conecta la VM con la subred
- Asociada con la IP pública y el NSG

### 7. **Linux Virtual Machine** (`azurerm_linux_virtual_machine`)
- Ubuntu 22.04 LTS (Gen2)
- Tamaño: Standard_B1s (1 vCPU, 1 GB RAM)
- Autenticación por contraseña habilitada

## ⚙️ Variables Configurables

| Variable | Descripción | Valor por Defecto | Ejemplo |
|----------|-------------|-------------------|---------|
| `prefix` | Prefijo para nombrar recursos | - | `icesisantiago` |
| `location` | Región de Azure | `eastus` | `eastus` |
| `vm_size` | Tamaño de la VM | `Standard_B1s` | `Standard_B1s` |
| `admin_username` | Usuario administrador | - | `santiago` |
| `admin_password` | Contraseña del admin | - | `Sanjuan176108` |

## 🚀 Instrucciones de Uso

### Prerrequisitos

1. **Terraform instalado** (versión 1.0+)
2. **Azure CLI instalado y configurado**
3. **Suscripción de Azure activa**

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

3. **Configurar variables (opcional):**
   ```bash
   # Editar terraform.tvars con tus valores
   cp terraform.tvars.example terraform.tvars
   nano terraform.tvars
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

#### 3. **Planificar la infraestructura:**
```bash
terraform plan
```
- Muestra qué recursos se van a crear/modificar/eliminar
- No hace cambios reales

#### 4. **Aplicar la configuración:**
```bash
terraform apply
```
- Crea la infraestructura en Azure
- Requiere confirmación (escribir `yes`)

#### 5. **Ver el estado:**
```bash
terraform show
```
- Muestra el estado actual de los recursos

#### 6. **Ver outputs:**
```bash
terraform output
```
- Muestra la IP pública y comando SSH

#### 7. **Conectar a la VM:**
```bash
# Usar el comando mostrado en outputs
ssh santiago@172.173.161.71

# O usar el output de Terraform
terraform output ssh_command
```

#### 8. **Destruir la infraestructura:**
```bash
terraform destroy
```
- Elimina todos los recursos creados
- Requiere confirmación

## 📊 Outputs del Sistema

El sistema genera los siguientes outputs:

- **`public_ip`**: Dirección IP pública de la VM
- **`ssh_command`**: Comando completo para conectarse vía SSH

## 🔒 Consideraciones de Seguridad

1. **Archivo `.gitignore`** configurado para excluir:
   - Archivos de estado (`*.tfstate`)
   - Variables sensibles (`*.tfvars`)
   - Directorios de Terraform (`.terraform/`)

2. **Variables sensibles** marcadas como `sensitive = true`

3. **NSG configurado** para permitir solo SSH (puerto 22)

4. **IP pública estática** para acceso controlado

## 🛠️ Troubleshooting

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
```

## Costos Estimados

- **Standard_B1s VM**: ~$3.65/mes
- **IP Pública Estática**: ~$3.65/mes
- **Almacenamiento**: ~$1.20/mes
- **Total estimado**: ~$8.50/mes

*Nota: Los costos pueden variar según la región y el uso real.*

## Recursos Adicionales

- [Documentación de Terraform](https://www.terraform.io/docs)
- [Provider de Azure para Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Mejores prácticas de Terraform](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
