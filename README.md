# GNad

GNad is a command-line configuration scripts manager. It provides command-line tools for downloading and managing configuration scripts.

**DISCLAIMER**: This software is in development, therefore its use is only recommended for testing purposes.

## Getting Started

### Prerequisites

* `git`

### Installing

#### Automated / easy way

Paste and run the command below on your terminal:

```shell
curl https://raw.githubusercontent.com/cristianarbe/gnad/master/install_script/install.sh | sh
```

#### Manual / medium way

Get the latest version from the [release page](https://github.com/cristianarbe/gnad/releases).

From your terminal:

* Make it executable

```shell
chmod a+x gnad
```
* and run!

```shell
./gnad
```

* If you want to be able to run it without the `./` you can move the file to  `.local/bin`

``` shell
mv gnad ~/.local/bin
```

* And add it to your `PATH` variable:

```shell
export PATH="$PATH:$HOME/.local/bin"
printf 'export PATH="$PATH:$HOME/.local/bin"' >>~/.bashrc
```

#### From source / hard way

Building from source will give you the latest version, which may not be the most stable. Proceed at your own risk!

To build from source, first you need to have go installed. In Debian/Ubuntu you can install it with:

```shell
sudo apt install golang
```

Then you can install it with:

```shell
go get -v github.com/cristianarbe/gnad
```

## Usage

At the moment, GNad has three main  commands:

* Getting a config script:

```shell
gnad get [REPO]
```

* Settings the config script:

```shell
gnad set [REPO]
```
* Listing downloaded scripts:

```shell
gnad ls [REPO]
```

## Feedback

Suggestions/improvements [welcome](https://github.com/cristianarbe/bootstrap-script/issues)!

## Authors

* **Cristian Ariza** - *Initial work* - [cristianarbe](https://github.com/cristianarbe)

See also the list of [contributors](https://github.com/cristianarbe/gnad/contributors) who participated in this project.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE.md](LICENSE.md) file for details

