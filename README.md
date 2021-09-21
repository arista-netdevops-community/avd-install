![Arista AVD](https://img.shields.io/badge/Arista-AVD%20Automation-blue)

# avd-install

Home of the script that lives at [get.avd.sh](https://get.avd.sh)!

The purpose of the install script is for a convenience for quickly installing the latest Arista Valddiated Design environment on the supported linux distros and macos.

## Usage

Review installation script

```shell
$ curl -fsSL https://get.avd.sh -o get-avd.sh
$ sh get-docker.sh
```

- Automated installation

```shell
$ curl -fsSL https://get.avd.sh | sh
```

## Available options

- Get latest stable version: `$ curl -fsSL https://get.avd.sh | sh`
- Get latest development version: `$ curl -fsSL https://get.avd.sh/dev | sh`
- Get environment for ATD: `$ curl -fsSL https://get.avd.sh/atd | sh`
- Get environment for TOI: `$ curl -fsSL https://get.avd.sh/toi | sh`

## Local testing

```bash
docker build -t atd_test:latest .
docker run --rm -i -t atd_test generic
docker run --rm -i -t atd_test atd
docker run --rm -i -t atd_test toi
docker run --rm -i -t atd_test dev
```

## License

Project is published under [Apache License](License).
