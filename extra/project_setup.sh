#!/bin/sh

set -e -u

if ! git submodule status protobuf >/dev/null 2>&1; then
	git submodule update --init --recursive --checkout
fi

uv python install cp39
uv venv --clear --seed -p cp39

. ./.venv/bin/activate
on_exit() {
	trap - EXIT
	deactivate
}
trap on_exit EXIT

uv tool install 'poetry==2.1.3'

# see https://github.com/chmouel/gnome-next-meeting-applet/pull/132
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

uv tool run poetry install --all-extras --all-groups

uv tool run poetry sync --all-extras --all-groups

exit 0
