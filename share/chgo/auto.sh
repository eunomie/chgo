unset GO_AUTO_VERSION

function chgo_auto() {
	local dir="$PWD/" version

	until [[ -z "$dir" ]]; do
		dir="${dir%/*}"

		if { read -r version <"$dir/.go-version"; } 2>/dev/null || [[ -n "$version" ]]; then
			if [[ "$version" == "$GO_AUTO_VERSION" ]]; then return
			else
				GO_AUTO_VERSION="$version"
				chgo "$version"
				return $?
			fi
		fi
	done

	if [[ -n "$GO_AUTO_VERSION" ]]; then
		chgo_reset
		unset GO_AUTO_VERSION
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *chgo_auto* ]]; then
		preexec_functions+=("chgo_auto")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chgo_auto' DEBUG
fi
