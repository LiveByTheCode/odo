#!/bin/bash

# This script uses github_changelog_generator to generate a changelog
# by using the kind labels that we use..
# 
# Then outputs it to STDOUT. This helps generate a changelog when doing a release.

# Get the variables we're going to use..
if [ -z "$GITHUB_TOKEN" ]
then
  echo -e "GITHUB_TOKEN environment variable is blank..\nGet your GitHub token and then:\nexport GITHUB_TOKEN=yourtoken"
  exit 1
fi

if [ -z "$1" ]  || [ -z "$2" ]
then
  echo -e "Must provide first and next release numbers..\nex: ./changelog-script.sh v1.0.0 v1.0.1"
  exit 1
fi

MIRROR="https://mirror.openshift.com/pub/openshift-v4/clients/odo/$2/"
INSTALLATION_GUIDE="https://docs.openshift.com/container-platform/4.2/cli_reference/openshift_developer_cli/installing-odo.html"

echo -e "# Installation of $2

To install odo, follow our installation guide at [docs.openshift.com]($INSTALLATION_GUIDE)

After each release, binaries synced on [mirror.openshift.com]($MIRROR)" > /tmp/base

github_changelog_generator \
--user openshift \
--project odo \
-t $GITHUB_TOKEN \
--since-tag $1 \
--future-release $2 \
--base /tmp/base \
--output /tmp/changelog \
--header-label "# Release of $2" \
#--summary-label "**Epics & Discussions:**" \
#--summary-labels "kind/epic,kind/discussion,kind/design,kind/use-case" \
--enhancement-label "**Code Refactoring:**" \
--enhancement-labels "kind/cleanup,kind/api-change,kind/code-refactoring" \
--breaking-label "**New features:**" \
--breaking-labels "kind/feature" \
--bugs-label "**Bugs:**" \
--bug-labels "kind/bug" \
--removed-label "**Tests:**" \
--removed-labels "kind/flake,kind/test" \
--security-label "**Documentation:**" \
--security-labels "kind/docs,kind/documentation"

echo ""
echo "The changelog is located at: /tmp/changelog"
echo ""
