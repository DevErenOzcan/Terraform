resource "proxmox_virtual_environment_download_file" "ubuntu_server_iso" {
  content_type   = "iso"
  datastore_id   = "local"
  node_name      = var.node_name
  url            = "https://releases.ubuntu.com/26.04/ubuntu-26.04-live-server-amd64.iso"
  file_name      = "ubuntu-26.04-live-server-amd64.iso"
  upload_timeout = 3600
}

resource "proxmox_virtual_environment_download_file" "ubuntu_desktop_iso" {
  content_type   = "iso"
  datastore_id   = "local"
  node_name      = var.node_name
  url            = "https://releases.ubuntu.com/26.04/ubuntu-26.04-desktop-amd64.iso"
  file_name      = "ubuntu-26.04-desktop-amd64.iso"
  upload_timeout = 7200
}

module "ubuntu_server_vm" {
  source         = "../../modules/ubuntu_server"
  node_name      = var.node_name
  vm_id          = 101
  vm_name        = "ubuntu_server"
  ip_address     = "192.168.1.10/24"
  gateway        = "192.168.1.1"
  network_bridge = "vmbr0"
  iso_file_id    = proxmox_virtual_environment_download_file.ubuntu_server_iso.id
}

module "ubuntu_desktop_vm" {
  source         = "../../modules/ubuntu_desktop"
  node_name      = var.node_name
  vm_id          = 102
  vm_name        = "ubuntu_desktop"
  ip_address     = "192.168.1.11/24"
  gateway        = "192.168.1.1" 
  network_bridge = "vmbr0"
  iso_file_id    = proxmox_virtual_environment_download_file.ubuntu_desktop_iso.id
}
