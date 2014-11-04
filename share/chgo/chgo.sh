CHGO_VERSION="0.3.8"
GOES=()

for dir in "$PREFIX/opt/goes" "$HOME/.goes"; do
	[[ -d "$dir" && -n "$(ls -A "$dir")" ]] && GOES+=("$dir"/*)
done
unset dir

function chgo_reset()
{
	[[ -z "$GOROOT" ]] && return

	PATH=":$PATH:"; PATH="${PATH//:$GOROOT\/bin:/:}"

	PATH="${PATH#:}"; PATH="${PATH%:}"
	unset GOROOT
	hash -r
}

function chgo_use()
{
	if [[ ! -x "$1/bin/go" ]]; then
		echo "chgo: $1/bin/go not executable" >&2
		return 1
	fi

	[[ -n "$GOROOT" ]] && chgo_reset

	export GOROOT="$1"
	export PATH="$GOROOT/bin:$PATH"
}

function chgo()
{
	case "$1" in
		-h|--help)
			echo "usage: chgo [VERSION|system]"
			;;
		-V|--version)
			echo "chgo: $CHGO_VERSION"
			;;
		"")
			local dir star
			for dir in "${GOES[@]}"; do
				dir="${dir%%/}"
				if [[ "$dir" == "$GOROOT" ]]; then star="*"
				else                               star=" "
				fi

				echo " $star ${dir##*/}"
			done
			;;
		system) chgo_reset ;;
		*)
			local dir match
			for dir in "${GOES[@]}"; do
				dir="${dir%%/}"
				case "${dir##*/}" in
					"$1")	match="$dir" && break ;;
					*"$1"*)	match="$dir" ;;
				esac
			done

			if [[ -z "$match" ]]; then
				echo "chgo: unknown Go: $1" >&2
				return 1
			fi

			shift
			chgo_use "$match" "$*"
			;;
	esac
}
