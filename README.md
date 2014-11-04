# chgo

[![Build Status](https://travis-ci.org/eunomie/chgo.png)](https://travis-ci.org/eunomie/chgo)

Changes the current Go.

## Features

* Updates `$PATH`.
* Set `$GOROOT`
* Calls `hash -r` to clear the command-lookup hash-table.
* Fuzzy matching of Go by name.
* Defaults to the system Go.
* Optionally supports auto-switching and the `.go-version` file.
* Supports [bash] and [zsh].
* Small (~90 LOC).
* Has tests.

## Anti-Features

* Does not hook `cd`.
* Does not install executable shims.
* Does not require Go be installed into your home directory.
* Does not automatically switch Go by default.

## Requirements

* [bash] >= 3 or [zsh]

## Install

    git clone https://github.com/eunomie/chgo.git
    cd chgo
    sudo make install

### setup.sh

chgo also includes a `setup.sh` script, which installs chgo.
Simply run the script as root or
via `sudo`:

    sudo ./scripts/setup.sh

### Homebrew (soon)

chgo can also be installed with [homebrew]:

    brew install chgo

Or the absolute latest chgo can be installed from source:

    brew install chgo --HEAD

### Go

#### Manually

Please install Go versions in `/opt/goes` or `~/.goes`.

#### go-install (soon)

You can also use [go-install] to install additional Go:

Installing to `/opt/goes` or `~/.goes`:

    go-install 1.3.3

#### go-build (soon)

You can also use [go-build] to install additional Go:

Installing to `/opt/goes`:

    go-build 1.4beta1 /opt/goes/1.4beta1

## Configuration

Add the following to the `~/.bashrc` or `~/.zshrc` file:

``` bash
source /usr/local/share/chgo/chgo.sh
```

### System Wide

If you wish to enable chgo system-wide, add the following to
`/etc/profile.d/chgo.sh`:

``` bash
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
  source /usr/local/share/chgo/chgo.sh
  ...
fi
```

This will prevent chgo from accidentally being loaded by `/bin/sh`, which
is not always the same as `/bin/bash`.

### Go

When chgo is first loaded by the shell, it will auto-detect Go installed
in `/opt/goes/` and `~/.goes/`. After installing new Go, you _must_
restart the shell before chgo can recognize them.

For Go installed in non-standard locations, simply append their paths to
the `GOES` variable:

``` bash
source /usr/local/share/chgo/chgo.sh

GOES=(
  /opt/go1.4beta1
  "$HOME/src/go"
)
```

### Auto-Switching

If you want chgo to auto-switch the current version of Go when you `cd`
between your different projects, simply load `auto.sh` in `~/.bashrc` or
`~/.zshrc`:

``` bash
source /usr/local/share/chgo/chgo.sh
source /usr/local/share/chgo/auto.sh
```

chgo will check the current and parent directories for a [.go-version]
file.

### Default Go

If you wish to set a default Go, simply call `chgo` in `~/.bash_profile` or
`~/.zprofile`:

    chgo 1.3.3

If you have enabled auto-switching, simply create a `.go-version` file:

    echo "1.3.3" > ~/.go-version


## Examples

List available Go:

    $ chgo
       1.2.2
       1.3.3
       1.4beta1

Select a Go:

    $ chgo 1.2.2
    $ chgo
     * 1.2.2
       1.3.3
       1.4beta1
    $ echo $PATH
    /Users/yves/.goes/1.2.2/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin
    $ go env GOROOT
    /Users/yves/.goes/1.2.2

Switch back to system Go:

    $ chgo system
    $ echo $PATH
    /usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

Run a command under a Go with `chgo-exec`:

    $ chgo-exec 1.2.2 -- go version

Switch to an arbitrary Ruby on the fly:

    $ chgo_use /path/to/go

## Uninstall

After removing the chgo configuration:

    $ sudo make uninstall

## Alternatives


## Credits

* [chruby](https://github.com/postmodern/chruby) for chruby

[bash]: http://www.gnu.org/software/bash/
[zsh]: http://www.zsh.org/
[homebrew]: http://brew.sh/
