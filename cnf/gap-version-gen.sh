#!/bin/sh

# This script generates a version string for GAP based on the VERSION file
# (if any) and the output of `git describe` (if inside a git working tree).
#
# The result is printed into cnf/GAP-VERSION-FILE, but only if the version
# string changed. This way, we do not trigger unnecessary rebuilds.

# This script is based on git.git's GIT-VERSION-GEN script

GVF=cnf/GAP-VERSION-FILE
DEF_VER=${1:-4.dev}

LF='
'

# First  try git-describe, then default.
if test -d ${GIT_DIR:-.git} -o -f .git &&
	VN=$(git describe --match "v[0-9]*" --abbrev=7 HEAD 2>/dev/null) &&
	case "$VN" in
	*$LF*) (exit 1) ;;
	v[0-9]*)
		git update-index -q --refresh
		test -z "$(git diff-index --name-only HEAD --)" ||
		VN="$VN-dirty" ;;
	esac
then
	VN=$(echo "$VN");
else
	VN="$DEF_VER"
fi

VN=$(expr "$VN" : v*'\(.*\)')

# Read GVF, if it exists. Then write the GVF back, but only
# if it is missing, or if the version changed.
if test -r $GVF
then
	VC=$(sed -e 's/^GAP_BUILD_VERSION = //' -e '/GAP_BUILD_DATETIME/d'  <$GVF)
else
	VC=unset
fi
test "$VN" = "$VC" || {
	echo >&2 "GAP_BUILD_VERSION = $VN"
	echo "GAP_BUILD_VERSION = $VN" >$GVF
	if [ -z "$SOURCE_DATE_EPOCH" ]; then
		echo "GAP_BUILD_DATETIME = $(date '+%Y-%m-%d %H:%M:%S%z')" >>$GVF
	else
		echo "GAP_BUILD_DATETIME = reproducible" >>$GVF
	fi
}
