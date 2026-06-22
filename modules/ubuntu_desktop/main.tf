terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "vm_name" {
  type = string
}

variable "ip_address" {
  type = string
}

variable "gateway" {
  type    = string
  default = "192.168.1.1"
}

variable "network_bridge" {
  type    = string
  default = "vmbr1"
}

variable "iso_file_id" {
  type = string
}

resource "proxmox_virtual_environment_vm" "ubuntu_desktop" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = var.vm_id
  machine   = "q35"
  bios      = "ovmf"
  
  operating_system {
    type = "l26"
  }
  
  cpu {
    cores   = 14
    sockets = 1
    type    = "x86-64-v2-AES"
  }
  
  memory {
    dedicated = 16384
  }
  
  vga {
    type = "none"
  }
  
  scsi_hardware = "virtio-scsi-single"
  
  disk {
    datastore_id = "lvm2"
    interface    = "scsi0"
    size         = 200
    iothread     = true
    file_format  = "raw"
  }
  
  efi_disk {
    datastore_id      = "lvm2"
    type              = "4m"
    pre_enrolled_keys = true
  }
  
  cdrom {
    enabled   = true
    file_id   = var.iso_file_id
    interface = "ide2"
  }
  
  network_device {
    bridge      = var.network_bridge
    model       = "virtio"
    mac_address = "BC:24:11:B8:0E:F8"
    firewall    = true
  }
  
  usb { host = "1a81:2232" }
  usb { host = "048d:c963" }
  usb { host = "048d:c965" }
  usb { host = "1a2c:4c5e" }
  usb { host = "13d3:56ff" }
  usb { host = "0489:e0cd" }
  
  hostpci {
    device = "hostpci0"
    id     = "0000:06:00.0"
    pcie   = true
    xvga   = true
  }
  
  hostpci {
    device = "hostpci1"
    id     = "0000:01:00.0"
    pcie   = true
  }
  
  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
  }
}