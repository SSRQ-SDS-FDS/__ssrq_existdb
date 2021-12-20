################################################################################
# Find the desired version

version_should=$(cat "${__object:?}/parameter/version")

# shellcheck disable=SC2034
IFS='	' read -r version_selected sha256_should size_should <<EOF
$(awk -F '\t' -v vers="${version_should}" '$1 == vers' "${__type:?}/files/cksums.tsv")
EOF

test -n "${version_selected}" || {
	printf 'Invalid --version: %s\n' "${version_should}" >&2
	exit 1
}

test "${version_should}" = "${version_selected}" || {
	printf '"%s" should be equal to "%s"\n' \
		"${version_should}" "${version_selected}" >&2
	exit 1
}


################################################################################
# Define OS-specific variables

exist_user='existdb'

# sync the following variables with explorer/conf_values
package_name='exist'
opt_package_name="${package_name:?}-${version_should:?}"
exist_home="/opt/${opt_package_name:?}"

case $(cat "${__global:?}/explorer/os")
in
	(debian|devuan|ubuntu)
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

exist_data="${exist_data_base:?}/${version_selected:?}"
exist_conf=${exist_home:?}/etc/conf.xml  # sync with conf_values explorer


################################################################################
# Generate download URL

exist_dist_url="https://github.com/eXist-db/exist/releases/download/eXist-${version_selected:?}/exist-distribution-${version_selected:?}-unix.tar.bz2"


# make shellcheck happy (unused variables) and ensure all have been set
: "${version_should:?}" "${version_should:?}" "${sha256_should:?}" "${size_should:?}"
: "${exist_user:?}" "${exist_home:?}" "${exist_data_base:?}" "${exist_init_type:?}"
: "${exist_data:?}" "${exist_conf:?}"
: "${exist_dist_url:?}"
