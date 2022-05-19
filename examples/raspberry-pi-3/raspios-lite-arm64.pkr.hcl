packer {
  required_plugins {
    git-shell = {
      version = ">=v0.1.0"
      source  = "github.com/yorinasub17/git-shell"
    }
  }
}

# We configure the arm builder to start with the official Raspberry Pi OS image.
source "arm" "raspios" {
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"

  file_urls             = [local.img_url]
  file_checksum_url     = "${local.img_url}.sha256"
  file_checksum_type    = "sha256"
  file_target_extension = "zip"
  image_build_method    = "resize"
  image_path            = "raspios-arm64.img"
  image_size            = "2G"
  image_type            = "dos"
  image_chroot_env = [
    "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin",
  ]

  image_partitions {
    name         = "boot"
    type         = "c"
    start_sector = "8192"
    filesystem   = "vfat"
    size         = "256M"
    mountpoint   = "/boot"
  }

  image_partitions {
    name         = "root"
    type         = "83"
    start_sector = "532480"
    filesystem   = "ext4"
    size         = "0"
    mountpoint   = "/"
  }
}

# Provision the Raspberry Pi OS using various scripts from this repo.
build {
  sources = ["source.arm.raspios"]

  provisioner "git-shell" {
    source = "https://github.com/yorinasub17/arm-packer-common.git"
    ref    = "main"

    # Install bash-commons
    script {
      path = "install_scripts/install-bash-commons.sh"
      args = ["--version", "v0.1.9"]
    }

    # Update fake hwclock so the log timestamps are consistent
    script {
      path = "install_scripts/update-fake-hwclock.sh"
    }

    # Remove the resize routine, as we are relying on the builder to right size the image. We want to keep the partition
    # size smaller than the SD card image to prolong the lifetime of the card.
    script {
      path = "install_scripts/remove-resize.sh"
    }

    # Prolong the life of the SD card by disabling the swap file.
    script {
      path = "install_scripts/disable-swap.sh"
    }

    # Disable root and default user access.
    script {
      path = "install_scripts/disable-access.sh"
      args = ["--user", "pi"]
    }

    # Finally, uninstall bash-commons since it won't be necessary after the scripts are run.
    script {
      path = "install_scripts/uninstall-bash-commons.sh"
    }
  }
}


# Convenient local variables
locals {
  img_url = "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-${var.raspios_version}/${var.raspios_version}-raspios-bullseye-arm64-lite.zip""
}
