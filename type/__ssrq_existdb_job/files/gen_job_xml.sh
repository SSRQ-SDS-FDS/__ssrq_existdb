#!/bin/sh -e

xml_quote_attr() {
	printf '%s' "$1" | awk '
	BEGIN {
		RS = "\n"
		ORS = ""
		for (i = 0; n < 256; n++) { chr[i] = sprintf("%c", i); ord[chr[i]] = i }

		csub["<"] = "&lt;"
		csub[">"] = "&gt;"
		csub["\t"] = "&#09;"
		csub["\n"] = "&#10;"
		csub["\""] = "&#34;"

		printf "\""
	}

	NR > 1 {
		# terminate previous line
		printf "%s", csub["\n"]
	}

	{
		for (i = 1; i <= length; i++) {
			c = substr($0, i, 1)

			if (c in csub) {
				c = csub[c]
			} else if (ord[c] > 127) {
				c = sprintf("&#%u;", ord[c])
			}

			printf "%s", c
		}
	}

	END {
		printf "\""
	}'
}

job_atts=$(
	sort -t '	' -k 2 <<-'EOF' |
	name	name
	unschedule-on-exception	unschedule-on-exception
	class	class
	cron	cron-trigger
	xquery	xquery
	type	type
	EOF
	while read -r param attrib
	do
		case ${param}
		in
			(name)
				# special
				if test -f "${__object:?}/parameter/${param}"
				then
					printf ' %s=%s' "${attrib}" "$(xml_quote_attr "$(cat "${__object:?}/parameter/${param}")")"
				else
					# default to__object_id
					printf ' %s=%s' "${attrib}" "$(xml_quote_attr "${__object_id:?}")"
				fi
				;;
			(unschedule-on-exception)
				# boolean
				if test -f "${__object:?}/parameter/${param}"
				then
					printf ' %s="yes"' "${param}"
				else
					printf ' %s="no"' "${param}"
				fi
				;;
			(*)
				# optional
				if test -f "${__object:?}/parameter/${param}"
				then
					printf ' %s=%s' "${attrib}" "$(xml_quote_attr "$(head -n1 "${__object:?}/parameter/${param}")")"
				fi
				;;
		esac
	done
)

job_params=$(
	while IFS='=' read -r _name _value
	do
		printf '<parameter name=%s value=%s/>' "$(xml_quote_attr "${_name}")" "$(xml_quote_attr "${_value}")"
	done <"${__object:?}/parameter/parameter"
		  )

printf '<job%s>%s</job>\n' "${job_atts-}" "${job_params}"
