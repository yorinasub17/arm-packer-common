# ARM Packer Common

This repo contains a collection of reusable Bash scripts for configuring ARM SoC devices (e.g., Raspberry Pi) with
[HashiCorp Packer](https://www.packer.io/). These scripts are intended to be used with the
[git-shell](https://github.com/yorinasub17/packer-plugin-git-shell) provisioner.


## Examples

Refer to the [examples folder](/examples) for sample Packer templates that make use of these scripts.


## Available Scripts

The scripts in this repo are organized into two categories:

- [Install Scripts](#install-scripts)
- [Scripts](#scripts)

### Install Scripts

Scripts in the [install_scripts](/install_scripts) folder are intended to be run only during the provision step. These
scripts should be used with the `git-shell` packer provisioner so that they only last during the build step.

### Scripts

Scripts in the [scripts](/scripts) folder are intended to be installed and used within the provisioned board. These
scripts are provide helper utilities that streamline the boot up process of various services being provisioned on to the
board.


## Contributing

* If you think you've found a bug in the code or you have a question regarding the usage of this software, please reach
  out to us by [opening an issue](https://github.com/yorinasub17/arm-packer-common/issues) in this GitHub
  repository.
* Contributions to this project are welcome: if you want to add a feature or a fix a bug, please do so by [opening a
  Pull Request](https://github.com/yorinasub17/arm-packer-common/pulls) in this GitHub repository. In case of
  feature contribution, we kindly ask you to open an issue to discuss it beforehand.
