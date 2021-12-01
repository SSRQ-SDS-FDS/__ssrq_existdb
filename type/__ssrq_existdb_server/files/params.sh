################################################################################
# Find the desired version

version_should=$(cat "${__object:?}/parameter/version")

# shellcheck disable=SC2034
IFS='	' read -r version_is sha256_should size_should <<EOF
$(
	case ${version_should}
	in
		(latest)
			tail -n 1 "${__type:?}/files/cksums.tsv"
			;;
		(*)
			awk -F '\t' -v vers="${version_should}" '$1 == vers' "${__type:?}/files/cksums.tsv"
			;;
	esac
)
EOF

test -n "${version_is}" || {
	if test "${version_should}" != 'latest'
	then
		printf 'Invalid --version: %s\n' "${version_should}" >&2
	else
		printf 'No eXist-db versions are currently known.\n' >&2
	fi
	exit 1
}


################################################################################
# Define OS-specific variables

exist_user='existdb'

case $(cat "${__global:?}/explorer/os")
in
	(debian|devuan|ubuntu)
		package_name='exist'
		opt_package_name="${package_name:?}-${version_is:?}"
		exist_home="/opt/${opt_package_name:?}"

		exist_data_base=/var/opt/lib/exist

		case $(cat "${__global:?}/explorer/init")
		in
			(systemd)
				exist_init_type=systemd
				# TODO: should probably use the upstream service file
				echo 'support for systemd is not implemented' >&2
				exit 1
				;;
			(*)
				exist_init_type=debian-sysvinit
				;;
		esac
		;;
	(*)
		# This type has only been tested on Debian
		: "${__type:?}"  # make shellcheck happy
		printf "Your operating system (%s) is currently not supported by this type (%s)\n" \
			   "$(cat "${__global:?}/explorer/os")" "${__type##*/}" >&2
		printf "Please contribute an implementation for it if you can.\n" >&2
		exit 1
		;;
esac


# make shellcheck happy (unused variables) and ensure all have been set
: "${version_should:?}" "${version_is:?}" "${sha256_should:?}" "${size_should:?}"
: "${exist_user:?}" "${exist_home:?}" "${exist_data_base:?}" "${exist_init_type:?}"
