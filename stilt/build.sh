#!/bin/bash
# 1. Build the base stilt image.
# 2. Build the custom stilt image.
# 3. Save the custom stilt image as a tarball.

set -e
set -u
set -x

VAULT=../devops/vault.yml
VPASS=~/.vault_password 

TAG_BASE=stiltbase
TAG_CUSTOM=stiltcustom

read -r -d '' AWK <<'EOF' || :
$1 == "vault_stilt_jena_user:" { user=$2 }
$1 == "vault_stilt_jena_password:" { password=$2 }
END {
  if (user != "" && password != "") {
    printf("--build-arg=JENASVNUSER=%s\n", user)
    printf("--build-arg=JENASVNPASSWORD=%s\n", password)
  }
}
EOF


readarray -t ARGS < <(ansible-vault decrypt "$VAULT"\
									--vault-password-file="$VPASS" \
									--output - | awk "$AWK")

if [[ ${#ARGS[@]} == 0 ]]; then
	echo "Could not find stilt svn user/password in $VAULT"
	exit 1
fi

BASE_ID=$(docker build -q --tag="$TAG_BASE" "${ARGS[@]}" base)

DOCKERFILE="$PWD/custom/Dockerfile.tmp"
trap 'rm -f -- "$DOCKERFILE"' EXIT
sed "s/^FROM.*/FROM $BASE_ID/" custom/Dockerfile > "$DOCKERFILE"

# looks like "sha256:0f96e3e9f93f538e6af476ecd0399806ddda44bade7bc0c3f4cd11b49d48e869"
CUSTOM_ID=$(docker build -q --tag="$TAG_CUSTOM" -f "$DOCKERFILE" custom)

# looks like "0f96e3e9f93f"
CSHORT_ID=${CUSTOM_ID:7:12}
OUTPUT_FN="$TAG_CUSTOM-$CSHORT_ID.tgz"

docker save "$TAG_CUSTOM" | gzip -c > "$OUTPUT_FN"
echo "$OUTPUT_FN"


