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
# Define variables

exist_user='existdb'

# sync the following variables with explorer/conf_values and explorer/archive-sum
package_name='existdb'
opt_package_name="${package_name:?}-${version_selected:?}"
exist_home="/opt/${opt_package_name:?}"

# OS-specific variables
case $(cat "${__global:?}/explorer/os")
in
	(debian|devuan|ubuntu)
		exist_data=/var/opt/lib/existdb
		exist_logdir=/var/opt/log/existdb/${version_selected}

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

exist_conf=${exist_home:?}/etc/conf.xml  # sync with conf_values explorer
web_conf=${exist_home:?}/etc/webapp/WEB-INF/web.xml  # sync with conf_values explorer


################################################################################
# Generate download URL

exist_dist_url="https://github.com/eXist-db/exist/releases/download/eXist-${version_selected:?}/exist-distribution-${version_selected:?}-unix.tar.bz2"


# make shellcheck happy (unused variables) and ensure all have been set
: "${version_should:?}" "${version_should:?}" "${sha256_should:?}" "${size_should:?}"
: "${exist_user:?}" "${exist_home:?}" "${exist_init_type:?}"
: "${exist_data:?}" "${exist_logdir:?}" "${exist_conf:?}" "${web_conf:?}"
: "${exist_dist_url:?}"
