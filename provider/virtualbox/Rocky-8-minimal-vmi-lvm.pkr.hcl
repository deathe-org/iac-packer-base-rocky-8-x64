
variable "build_export_format" {
  type    = string
  default = "ova"
}

variable "build_iso_checksum" {
  type    = string
  default = "4ce0948699a26f66dffd705c0459d428439cef02d5db43d36a6ae62ba494fe9e"
}

variable "build_iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "build_iso_filename" {
  type    = string
  default = "Rocky-8.8-x86_64-minimal.iso"
}

variable "build_iso_target_path" {
  type    = string
  default = "isos/x86_64"
}

variable "build_name" {
  type    = string
  default = "Rocky-8.8-x86_64-minimal-vmi-lvm-en_US"
}

variable "build_output_directory" {
  type    = string
  default = "builds"
}

variable "guest_boot_timeout" {
  type    = string
  default = "0"
}

variable "guest_bootloader_append" {
  type    = string
  default = "net.ifnames=0 biosdevname=0 console=tty1 console=ttyS0,115200 no_timer_check"
}

variable "guest_cpus" {
  type    = string
  default = "1"
}

variable "guest_firewall_disabled" {
  type    = string
  default = "false"
}

variable "guest_hard_disk_size" {
  type    = string
  default = "4096"
}

variable "guest_keyboard" {
  type    = string
  default = "us"
}

variable "guest_language" {
  type    = string
  default = "en_US.UTF-8"
}

variable "guest_lv_root_fstype" {
  type    = string
  default = "xfs"
}

variable "guest_lv_root_mkfsoptions" {
  type    = string
  default = "-i size=512 -n ftype=1 -m bigtime=0,inobtcount=0"
}

variable "guest_lv_root_size" {
  type    = string
  default = "1024"
}

variable "guest_lv_swap_size" {
  type    = string
  default = "0"
}

variable "guest_memory" {
  type    = string
  default = "1024"
}

variable "guest_name" {
  type    = string
  default = "Rocky-8.8-x86_64-minimal-vmi-lvm-en_US"
}

variable "guest_partition_boot_fstype" {
  type    = string
  default = "xfs"
}

variable "guest_partition_boot_size" {
  type    = string
  default = "1024"
}

variable "guest_pv_root_fstype" {
  type    = string
  default = "lvmpv"
}

variable "guest_pv_root_mkfsoptions" {
  type    = string
  default = ""
}

variable "guest_selinux" {
  type    = string
  default = "permissive"
}

variable "guest_timezone" {
  type    = string
  default = "Etc/UTC"
}

variable "guest_vg_system_reserved_space" {
  type    = string
  default = "0"
}

variable "guest_vram" {
  type    = string
  default = "16"
}

variable "ssh_root_password" {
  type    = string
  default = "rocky"
}

variable "ssh_user" {
  type    = string
  default = "rocky"
}

variable "ssh_user_authorized_keys" {
  type    = string
  default = ""
}

variable "ssh_user_home" {
  type    = string
  default = "/home/rocky"
}

variable "ssh_user_password" {
  type    = string
  default = "rocky"
}

variable "ssh_user_shell" {
  type    = string
  default = "/bin/bash"
}

variable "ssh_user_sudo" {
  type    = string
  default = "ALL=(ALL) NOPASSWD:ALL"
}

source "virtualbox-iso" "build" {
  boot_command = [
    "<esc><wait>",
    "linux",
    " inst.text",
    " inst.ks=http://{{.HTTPIP}}:{{.HTTPPort}}/rockylinux-8-minimal.cfg",
    " BOOT_TIMEOUT=${var.guest_boot_timeout}",
    " BOOTLOADER_APPEND=\"${var.guest_bootloader_append}\"",
    " LANG=${var.guest_language}",
    " KEYTABLE=${var.guest_keyboard}",
    " TIMEZONE=${var.guest_timezone}",
    " ROOTPW=${var.ssh_root_password}",
    " FIREWALL_DISABLED=${var.guest_firewall_disabled}",
    " SELINUX=${var.guest_selinux}",
    " LV_ROOT_FSTYPE=${var.guest_lv_root_fstype}",
    " LV_ROOT_MKFSOPTIONS=\"${var.guest_lv_root_mkfsoptions}\"",
    " LV_ROOT_SIZE=${var.guest_lv_root_size}",
    " LV_SWAP_SIZE=${var.guest_lv_swap_size}",
    " PV_ROOT_FSTYPE=${var.guest_pv_root_fstype}",
    " PV_ROOT_MKFSOPTIONS=\"${var.guest_pv_root_mkfsoptions}\"",
    " PART_BOOT_FSTYPE=${var.guest_partition_boot_fstype}",
    " PART_BOOT_SIZE=${var.guest_partition_boot_size}",
    " VG_ROOT_RESERVED_SPACE=${var.guest_vg_system_reserved_space}",
    "<enter><wait>"
  ]
  boot_keygroup_interval = "500ms"
  boot_wait              = "3s"
  disk_size              = "${var.guest_hard_disk_size}"
  format                 = "${var.build_export_format}"
  guest_additions_mode   = "disable"
  guest_os_type          = "RedHat_64"
  hard_drive_interface   = "sata"
  headless               = true
  http_directory         = "http"
  iso_checksum           = "${var.build_iso_checksum}"
  iso_interface          = "sata"
  iso_target_path        = "${var.build_iso_target_path}"
  iso_url                = "${var.build_iso_target_path}/${var.build_iso_filename}"
  shutdown_command       = "/sbin/shutdown --no-wall -P now"
  shutdown_timeout       = "1m"
  ssh_password           = "${var.ssh_root_password}"
  ssh_port               = 22
  ssh_username           = "root"
  ssh_wait_timeout       = "10m"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--accelerate2dvideo", "off"],
    ["modifyvm", "{{.Name}}", "--accelerate3d", "off"],
    ["modifyvm", "{{.Name}}", "--audio", "none"],
    ["modifyvm", "{{.Name}}", "--biosbootmenu", "disabled"],
    ["modifyvm", "{{.Name}}", "--bioslogodisplaytime", "0"],
    ["modifyvm", "{{.Name}}", "--bioslogofadein", "off"],
    ["modifyvm", "{{.Name}}", "--bioslogofadeout", "off"],
    ["modifyvm", "{{.Name}}", "--clipboard", "disabled"],
    ["modifyvm", "{{.Name}}", "--cpus", "1"],
    ["modifyvm", "{{.Name}}", "--draganddrop", "disabled"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--hpet", "on"],
    ["modifyvm", "{{.Name}}", "--memory", "1024"],
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--usb", "off"],
    ["modifyvm", "{{.Name}}", "--vram", "10"]
  ]
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--cpus", "${var.guest_cpus}"],
    ["modifyvm", "{{.Name}}", "--memory", "${var.guest_memory}"],
    ["modifyvm", "{{.Name}}", "--vram", "${var.guest_vram}"],
    ["modifyvm", "{{.Name}}", "--vrde", "off"],
    ["storagectl", "{{.Name}}", "--name", "IDE Controller", "--remove"],
    ["storagectl", "{{.Name}}", "--name", "SATA Controller", "--hostiocache", "off"]
  ]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.guest_name}"
}

build {
  name    = "${var.build_name}"
  sources = ["source.virtualbox-iso.build"]

  provisioner "file" {
    destination = "/etc/systemd/system/grow-root.service"
    source      = "src/etc/systemd/system/grow-root.service"
  }

  provisioner "shell" {
    environment_vars = [
      "GUEST_LANG=${var.guest_language}",
      "LV_ROOT_FS_TYPE=${var.guest_lv_root_fstype}",
      "SSH_USER=${var.ssh_user}",
      "SSH_USER_AUTHORIZED_KEYS=${var.ssh_user_authorized_keys}",
      "SSH_USER_HOME=${var.ssh_user_home}",
      "SSH_USER_PASSWORD=${var.ssh_user_password}",
      "SSH_USER_SHELL=${var.ssh_user_shell}",
      "SSH_USER_SUDO=${var.ssh_user_sudo}",
      "PART_BOOT_SIZE=${var.guest_partition_boot_size}",
      "PV_ROOT_FSTYPE=${var.guest_pv_root_fstype}"
    ]
    execute_command = "chmod +x \"{{ .Path }}\"; env {{ .Vars }} /bin/bash \"{{ .Path }}\""
    remote_folder   = "/var/tmp"
    scripts = [
      "scripts/install/cloud-init.sh",
      "scripts/install/systemd-unit-file-grow-root.sh",
      "scripts/cloud-init/disable-locale-module.sh",
      "scripts/cloud-init/add-datasource-list.sh",
      "scripts/cloud-init/add-logging-output.sh",
      "scripts/cloud-init/add-preserve-hostname.sh",
      "scripts/common/disable-autovt.sh",
      "scripts/common/sshd-config-non-root-key-auth.sh",
      "scripts/common/sudoers-default-not-requiretty.sh",
      "scripts/common/ssh-user.sh",
      "scripts/common/seal-virtual-guest.sh",
      "scripts/common/locale-trim-definitions.sh",
      "scripts/common/locale-trim-translations.sh",
      "scripts/common/locale-lock-sysconfig.sh",
      "scripts/common/purge-desktop-graphics.sh",
      "scripts/common/purge-temporary-directories.sh",
      "scripts/common/dnf-cleanup.sh",
      "scripts/common/rpm-rebuild-db.sh",
      "scripts/common/stop-and-truncate-logs.sh",
      "scripts/common/zero-out-disks.sh",
      "scripts/common/lock-root-user.sh"
    ]
    skip_clean = false
  }

  post-processor "compress" {
    keep_input_artifact = true
    compression_level   = 9
    output              = "${var.build_output_directory}/${var.build_name}.${var.build_export_format}.tar.gz"
  }
  post-processor "shell-local" {
    execute_command = ["chmod +x \"{{ .Script }}\"; {{ .Vars }} /bin/bash \"{{ .Script }}\" ${var.build_output_directory} ${var.build_export_format}"]
    inline = [
      "if [[ -n $${1} ]] && [[ -n $${2} ]] && [[ -n $${PACKER_BUILD_NAME} ]] && [[ -d output-$${PACKER_BUILD_NAME} ]]; then",
      "  echo '--> Moving build artifact.'",
      "  mv -f output-$${PACKER_BUILD_NAME}/${var.guest_name}.$${2} $${1}/${var.build_name}.$${2}",
      "fi",
      "echo '--> Cleanup output directories.'",
      "find . -mindepth 1 -maxdepth 1 -type d -name \"output-*\" -exec rm -rf '{}' +"
    ]
    inline_shebang = "/bin/bash -e"
  }
}
