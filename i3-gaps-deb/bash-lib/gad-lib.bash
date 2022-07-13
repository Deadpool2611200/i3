#  gad-lib.bash is a small bash library providing some rudimentary stuff.
#  Copyright (C) 2018  Gerhard A. Dittes
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Namespace: gad

# Variables

gad_LABEL="gad"

# Functions

gad_print()
{
	tput setaf 3 2>/dev/null || true
	printf "[${gad_LABEL}] "
	tput setaf 7 2>/dev/null || true
	printf "%s" "${@}"
	tput sgr0 2>/dev/null || true
}

gad_printLine()
{
	gad_print "${@}"; printf "\n"
}

gad_log()
{
	gad_printLine "${@}" >&2
}

gad_readAndContinue()
{
	gad_print "${@}"
	read -p " [RETURN]"
}

gad_question()
{
	local result=1 # false
	local question="${1}"
	local default="n"

	# ensure lowercase
	if [ ${#} -eq 2 ] && [ "${2}" = "y" -o "${2}" = "Y" ]; then
		default="y"
	fi

	gad_print "${question}"

	if [ ${default} = "y" ]; then
		printf " [Y/n]: "
	else
		printf " [y/N]: "
	fi

	read answer

	# ensure lowercase
	if [ "${answer}" = "Y" ]; then
		answer="y"
	elif [ "${answer}" = "N" ]; then
		answer="n"
	fi

	if [ ${default} = "y" ]; then
		if [ "${answer}" != "n" ]; then
			result=0 # true
		fi
	else
		if [ "${answer}" = "y" ]; then
			result=0 # true
		fi
	fi

	return ${result}
}

gad_logLine()
{
	local colums=$(tput cols)
	local labelLength=${#gad_LABEL}
	local extraLength=3
	local length=$((${colums} - ${labelLength} - ${extraLength}))
	local line="$(printf "%${length}s" | tr " " -)"

	gad_log "${line}"
}
