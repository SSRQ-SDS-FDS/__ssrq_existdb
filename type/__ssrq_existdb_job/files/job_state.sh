#!/bin/sh -e
set -e -u

if ! test -s "${__object:?}/explorer/job_params"
then
	# if the explorer does not print anything the job is absent (or the installation is fucked up)
	echo absent
fi

if
	{
		# job attributes
		if test -f "${__object:?}/parameter/name"
		then
			job_name=$(cat "${__object:?}/parameter/name")
		else
			job_name=${__object_id?:}
		fi
		printf 'name=%s\n' "${job_name}"

		while read -r param attrib
		do
			if test -f "${__object:?}/parameter/${param}"
			then
				printf '%s=%s\n' "${attrib}" "$(head -n1 "${__object:?}/parameter/${param}")"
			fi
		done <<-'EOF'
		class	class
		cron	cron-trigger
		xquery	xquery
		type	type
		EOF

		if test -f "${__object:?}/parameter/unschedule-on-exception"
		then
			printf 'unschedule-on-exception=yes\n'
		else
			printf 'unschedule-on-exception=no\n'
		fi

		# parameters
		_params=$(tr '\n' '<' <"${__object:?}/parameter/parameter")
		printf 'params=%s\n' "${_params%<}"
	} \
	| sort -t= -k1 \
	| cmp -s "${__object:?}/explorer/job_params" -
then
	echo present
else
	echo absent
fi
